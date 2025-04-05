import 'dart:convert';
import 'dart:io';

import 'package:secure_env_core/secure_env_core.dart';
import '../base_command.dart';

/// Command to import .xcconfig files
class XConfigImportCommand extends BaseCommand {
  XConfigImportCommand({
    required super.logger,
    required this.environmentService,
    required this.xconfigService,
  }) {
    argParser
      ..addOption(
        'project',
        abbr: 'p',
        help: 'Project name',
        mandatory: true,
      )
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
        help: 'Path to .xcconfig files to import',
        valueHelp: 'path/to/file.xcconfig',
      )
      ..addOption(
        'config',
        help: 'Path to env_config.json',
      );
  }

  final EnvironmentService environmentService;
  final XConfigService xconfigService;

  @override
  String get description => 'Import .xcconfig files';

  @override
  String get name => 'xcconfig';

  @override
  Future<int> run() => handleErrors(() async {
        final projectName = argResults!['project'] as String;
        final envName = argResults!['name'] as String;
        final description = argResults!['description'] as String?;
        final files = argResults!['files'] as List<String>;
        final configPath = argResults!['config'] as String?;

        if (files.isEmpty && argResults!.rest.isEmpty) {
          throw const FormatException(
            'At least one .xcconfig file path is required',
          );
        }

        // Load config if provided
        Config? config;
        if (configPath != null) {
          final configFile = File(configPath);
          if (await configFile.exists()) {
            final configJson = jsonDecode(await configFile.readAsString());
            config = Config.fromJson(configJson as Map<String, dynamic>);
          }
        }

        // Combine files from --files option and rest arguments
        final allFiles = [...files, ...argResults!.rest];

        // Read and merge all .xcconfig files
        final mergedValues = <String, String>{};
        for (final file in allFiles) {
          logger.info('Reading $file...');
          final values = await xconfigService.readXConfig(file);

          // Apply config transformations if available
          if (config != null) {
            final transformedValues = <String, String>{};
            for (final entry in values.entries) {
              if (!config.ignoreKeys.contains(entry.key)) {
                final mappedKey = config.keyMapping[entry.key] ?? entry.key;
                transformedValues[mappedKey] = entry.value;
              }
            }
            mergedValues.addAll(transformedValues);
          } else {
            mergedValues.addAll(values);
          }
        }

        // Create or update environment
        final existingEnv = await environmentService.loadEnvironment(
          name: envName,
          projectName: projectName,
        );

        if (existingEnv != null) {
          logger.info('Updating existing environment: $envName');
          final updatedValues = Map<String, String>.from(existingEnv.values)
            ..addAll(mergedValues);

          await environmentService.saveEnvironment(
            existingEnv.copyWith(
              values: updatedValues,
              description: description ?? existingEnv.description,
              lastModified: DateTime.now(),
            ),
          );
        } else {
          logger.info('Creating new environment: $envName');
          await environmentService.createEnvironment(
            name: envName,
            projectName: projectName,
            description: description,
            initialValues: mergedValues,
          );
        }

        logger.success(
          'Successfully imported ${mergedValues.length} variables from ${allFiles.length} files',
        );
        return BaseCommand.successExitCode;
      });
}
