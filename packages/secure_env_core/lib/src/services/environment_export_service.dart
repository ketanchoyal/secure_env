import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as path;
import 'package:secure_env_core/src/exceptions/exceptions.dart';
import '../models/export_config.dart';
import '../models/environment.dart';
import '../models/project_config.dart';
import '../utils/logger.dart';
import '../utils/default_logger.dart';
import 'environment_service.dart';

/// Internal struct to represent a single export job
class _ExportJob {
  final String key;
  final String content;
  final String filePath;
  _ExportJob(this.key, this.content, this.filePath);
}

/// Service to export environment variables to various config formats: .xcconfig, .env, .properties
class EnvironmentExportService {
  final Environment _environment;
  final Logger _logger;
  final EnvironmentService _environmentService;

  ExportConfig get config => _environment.exportConfig;

  EnvironmentExportService(
    this._environment, {
    required EnvironmentService environmentService,
    Logger? logger,
  })  : _logger = logger ?? DefaultLogger(),
        _environmentService = environmentService;

  /// Converts [env] to .xcconfig format string (e.g., FOO = bar;)
  String _toXcconfig(Map<String, String> env) {
    return env.entries.map((e) => '${e.key} = ${e.value};').join('\n');
  }

  /// Converts [env] to .env format string (e.g., FOO=bar)
  String _toDotenv(Map<String, String> env) {
    return env.entries.map((e) => '${e.key}=${e.value}').join('\n');
  }

  /// Converts [env] to .properties format string (e.g., foo=bar)
  String _toProperties(Map<String, String> env) {
    return env.entries.map((e) => '${e.key}=${e.value}').join('\n');
  }

  /// Writes the formatted string to a file at [filePath]
  Future<void> exportToFile(String content, String filePath) async {
    final file = File(filePath);
    await file.writeAsString(content);
  }

  /// Generates export jobs based on config
  List<_ExportJob> _createJobs(Map<String, String> env) {
    final jobs = <_ExportJob>[];
    if (config.exportXcconfig) {
      jobs.add(_ExportJob(
        'xcconfig',
        _toXcconfig(env),
        path.join(config.xcconfigPath, '${config.xcconfigFileName}.xcconfig'),
      ));
    }
    if (config.exportEnv) {
      jobs.add(_ExportJob(
        'env',
        _toDotenv(env),
        path.join(config.envPath, '${config.envFileName}.env'),
      ));
    }
    if (config.exportProperties) {
      jobs.add(_ExportJob(
        'properties',
        _toProperties(env),
        path.join(
            config.propertiesPath, '${config.propertiesFileName}.properties'),
      ));
    }
    return jobs;
  }

  /// Exports [env] to the configured file formats, computes checksums, and returns them.
  Future<Map<String, String>> export() async {
    final checksums = <String, String>{};
    final jobs = _createJobs(_environment.values);
    for (final job in jobs) {
      try {
        _logger.info('Exporting .${job.key} to ${job.filePath}');
        await File(job.filePath).parent.create(recursive: true);
        await exportToFile(job.content, job.filePath);
        _logger.success('Exported .${job.key} to ${job.filePath}');
        checksums[job.key] = sha1.convert(utf8.encode(job.content)).toString();
      } catch (e, st) {
        _logger.error('Failed to export .${job.key} to ${job.filePath}', e, st);
      }
    }
    return checksums;
  }

  /// Syncs [env] to disk based on ExportConfig and ProjectConfig conflict policy,
  /// updates lastFileChecksums, and persists the environment.
  Future<void> syncEnvironment() async {
    _logger.info('Syncing environment ${_environment.name}');
    final projectConfig = _environmentService.project.config;
    final oldChecksums = _environment.lastFileChecksums;
    final newChecksums = Map<String, String>.from(oldChecksums);
    // Collect any warn-and-skip conflicts
    final conflicts = <ExportConflictException>[];

    // Sync helper for single format
    Future<void> syncFormat({
      required String key,
      required bool enabled,
      required String filePath,
      required String content,
    }) async {
      if (!enabled) return;
      final file = File(filePath);
      String? existingChecksum;
      if (await file.exists()) {
        final existingContent = await file.readAsString();
        existingChecksum =
            sha1.convert(utf8.encode(existingContent)).toString();
      }
      final oldChecksum = oldChecksums[key];
      final shouldWrite = existingChecksum == null ||
          oldChecksum == null ||
          existingChecksum == oldChecksum;
      if (!shouldWrite &&
          projectConfig.conflictPolicy == ConflictPolicy.warnAndSkip) {
        _logger.warn('File $filePath exists but content is different');
        throw ExportConflictException(
          'Last file checksum does not match current file checksum',
        );
      }
      if (shouldWrite ||
          projectConfig.conflictPolicy == ConflictPolicy.forceOverwrite) {
        _logger.info('Writing to file $filePath');
        await File(filePath).parent.create(recursive: true);
        await exportToFile(content, filePath);
        newChecksums[key] = sha1.convert(utf8.encode(content)).toString();
      }
    }

    // Perform sync for each enabled format, collecting conflicts
    for (final job in _createJobs(_environment.values)) {
      try {
        await syncFormat(
          key: job.key,
          enabled: true,
          filePath: job.filePath,
          content: job.content,
        );
      } on ExportConflictException catch (e) {
        conflicts.add(ExportConflictException(
          'Failed to sync ${job.key} for ${_environment.name}',
          details: e.message,
        ));
      }
    }

    // Persist updated checksums
    final newEnv = _environment.copyWith(lastFileChecksums: newChecksums);
    await _environmentService.saveEnvironment(newEnv);
    // After syncing, rethrow any collected warn-and-skip conflicts
    if (conflicts.isNotEmpty) {
      if (conflicts.length == 1) throw conflicts.first;
      throw ExportConflictExceptionMultiple(
        conflicts,
        details:
            'Multiple conflicts: ${conflicts.map((e) => e.message).join('; ')}',
      );
    }
  }
}
