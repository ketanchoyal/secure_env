import 'dart:io';
import 'package:path/path.dart' as path;
import '../models/export_config.dart';
import '../utils/logger.dart';
import '../utils/default_logger.dart';

/// Service to export environment variables to various config formats: .xcconfig, .env, .properties
class EnvironmentExportService {
  final ExportConfig config;
  final Logger _logger;

  EnvironmentExportService(this.config, {Logger? logger})
      : _logger = logger ?? DefaultLogger();

  /// Converts [env] to .xcconfig format string (e.g., FOO = bar;)
  String toXcconfig(Map<String, String> env) {
    return env.entries.map((e) => '${e.key} = ${e.value};').join('\n');
  }

  /// Converts [env] to .env format string (e.g., FOO=bar)
  String toDotenv(Map<String, String> env) {
    return env.entries.map((e) => '${e.key}=${e.value}').join('\n');
  }

  /// Converts [env] to .properties format string (e.g., foo=bar)
  String toProperties(Map<String, String> env) {
    return env.entries.map((e) => '${e.key}=${e.value}').join('\n');
  }

  /// Writes the formatted string to a file at [filePath]
  Future<void> exportToFile(String content, String filePath) async {
    final file = File(filePath);
    await file.writeAsString(content);
  }

  /// Exports [env] to the configured file formats based on ExportConfig.
  Future<void> export(Map<String, String> env) async {
    if (config.exportXcconfig) {
      final content = toXcconfig(env);
      final filePath = path.join(config.xcconfigPath, '${config.xcconfigFileName}.xcconfig');
      try {
        _logger.info('Exporting .xcconfig to $filePath');
        await File(filePath).parent.create(recursive: true);
        await exportToFile(content, filePath);
        _logger.success('Exported .xcconfig to $filePath');
      } catch (e, st) {
        _logger.error('Failed to export .xcconfig to $filePath', e, st);
      }
    }
    if (config.exportEnv) {
      final content = toDotenv(env);
      final filePath = path.join(config.envPath, '${config.envFileName}.env');
      try {
        _logger.info('Exporting .env to $filePath');
        await File(filePath).parent.create(recursive: true);
        await exportToFile(content, filePath);
        _logger.success('Exported .env to $filePath');
      } catch (e, st) {
        _logger.error('Failed to export .env to $filePath', e, st);
      }
    }
    if (config.exportProperties) {
      final content = toProperties(env);
      final filePath = path.join(config.propertiesPath, '${config.propertiesFileName}.properties');
      try {
        _logger.info('Exporting .properties to $filePath');
        await File(filePath).parent.create(recursive: true);
        await exportToFile(content, filePath);
        _logger.success('Exported .properties to $filePath');
      } catch (e, st) {
        _logger.error('Failed to export .properties to $filePath', e, st);
      }
    }
  }
}
