import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:secure_env_core/src/services/environment_service.dart';
import 'package:secure_env_core/src/services/format/env.dart';
import '../base_command.dart';

/// Command to import .env files
class EnvImportCommand extends BaseCommand {
  EnvImportCommand({
    required super.logger,
    required this.envService,
    required super.projectService,
  }) {
    argParser
      ..addOption(
        'name',
        abbr: 'n',
        help: 'Environment name',
        mandatory: true,
      )
      ..addOption(
        'description',
        abbr: 'd',
        help: 'Environment description',
      )
      ..addMultiOption(
        'files',
        abbr: 'f',
        help: 'Path to .env files to import',
        valueHelp: 'path/to/.env',
      );
  }

  late final EnvironmentService _environmentService;
  final EnvService envService;

  @override
  String get description => 'Import .env files';

  @override
  String get name => 'env';

  @override
  Future<int> run() => handleErrors(() async {
        final project = await projectService.getProject(Directory.current.path);
        if (project == null) {
          throw 'No project found in the current directory. Please run "secure_env init" first.';
        }
        _environmentService = await EnvironmentService.forProject(
            project: project, projectService: projectService, logger: logger);
        final envName = argResults!['name'] as String;
        final description = argResults!['description'] as String?;
        final files = argResults!['files'] as List<String>;

        if (files.isEmpty && argResults!.rest.isEmpty) {
          throw const FormatException(
              'At least one .env file path is required');
        }

        // Combine files from --files option and rest arguments
        final allFiles = [...files, ...argResults!.rest];

        // Read and merge all .env files
        final mergedValues = <String, String>{};
        for (final file in allFiles) {
          logger.info('Reading $file...');
          final values = await envService.readEnvFile(file);
          mergedValues.addAll(values);
        }

        // Create or update environment
        final existingEnv = await _environmentService.loadEnvironment(
          name: envName,
        );

        if (existingEnv != null) {
          logger.info('Updating existing environment: $envName');
          final updatedValues = Map<String, String>.from(existingEnv.values)
            ..addAll(mergedValues);

          await _environmentService.saveEnvironment(
            existingEnv.copyWith(
              values: updatedValues,
              description: description ?? existingEnv.description,
              lastModified: DateTime.now(),
            ),
          );
        } else {
          logger.info('Creating new environment: $envName');
          await _environmentService.createEnvironment(
            name: envName,
            description: description,
            initialValues: mergedValues,
          );
        }

        logger.success(
          'Successfully imported ${mergedValues.length} variables from ${allFiles.length} files',
        );
        return ExitCode.success.code;
      });
}
