import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as path;

import 'package:secure_env_core/src/services/environment_service.dart';
import '../base_command.dart';

/// Command to export an environment to a file
class ExportCommand extends BaseCommand {
  /// Creates a new export command
  ExportCommand({
    required super.logger,
    required super.projectService,
  }) {
    argParser
      ..addOption(
        'format',
        abbr: 'f',
        help: 'Output format (env, properties, xcconfig)',
        allowed: ['env', 'properties', 'xcconfig'],
        defaultsTo: 'env',
      )
      ..addOption(
        'output',
        abbr: 'o',
        help: 'Output file path',
      );
  }

  late final EnvironmentService _environmentService;

  @override
  String get description => 'Export an environment to a file';

  @override
  String get name => 'export';

  @override
  Future<int> run() => handleErrors(() async {
        final project = await projectService.getProjectFromCurrentDirectory();
        if (project == null) {
          throw 'No project found in the current directory. Please run "secure_env init" first.';
        }
        _environmentService = await EnvironmentService.forProject(
            project: project, projectService: projectService, logger: logger);
        final envName =
            argResults?.rest.isEmpty ?? true ? null : argResults!.rest.first;
        if (envName == null) {
          logger.error('Environment name is required');
          return ExitCode.usage.code;
        }

        final format = argResults!['format'] as String;
        String? outputPath = argResults!['output'] as String?;

        // Load the environment
        final env = await _environmentService.loadEnvironment(
          name: envName,
        );

        if (env == null) {
          logger.error('Environment not found: $envName');
          return ExitCode.software.code;
        }

        // If no output path is specified, use the environment name with appropriate extension
        if (outputPath == null) {
          final currentDir = Directory.current.path;
          final extension = switch (format) {
            'env' => '.env',
            'properties' => '.properties',
            'xcconfig' => '.xcconfig',
            _ => '.env',
          };
          outputPath = '$currentDir/.secure_env/$envName$extension';
        }

        // Ensure the output directory exists
        final outputDir = path.dirname(outputPath);
        if (outputDir != '.') {
          await Directory(outputDir).create(recursive: true);
        }

        // Generate the output content based on format
        final content = switch (format) {
          'env' => _generateEnvFormat(env.values),
          'properties' => _generatePropertiesFormat(env.values),
          'xcconfig' => _generateXcconfigFormat(env.values),
          _ => _generateEnvFormat(env.values),
        };

        // Write to file
        await File(outputPath).writeAsString(content);

        logger.success('Environment exported to: $outputPath');
        return ExitCode.success.code;
      });

  String _generateEnvFormat(Map<String, String> values) {
    final buffer = StringBuffer();
    for (final entry in values.entries) {
      // Quote the value if it contains spaces
      final value =
          entry.value.contains(' ') ? '"${entry.value}"' : entry.value;
      buffer.writeln('${entry.key}=$value');
    }
    return buffer.toString();
  }

  String _generatePropertiesFormat(Map<String, String> values) {
    final buffer = StringBuffer();
    for (final entry in values.entries) {
      buffer.writeln('${entry.key}=${entry.value}');
    }
    return buffer.toString();
  }

  String _generateXcconfigFormat(Map<String, String> values) {
    final buffer = StringBuffer();
    for (final entry in values.entries) {
      buffer.writeln('${entry.key} = ${entry.value}');
    }
    return buffer.toString();
  }
}
