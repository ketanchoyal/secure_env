import 'package:secure_env/src/core/utils/validation_utils.dart';

import '../../../core/services/environment_service.dart';
import '../../../core/services/format/properties.dart';
import '../base_command.dart';

/// Command to import .properties files
class PropertiesImportCommand extends BaseCommand {
  PropertiesImportCommand({
    required super.logger,
    required this.environmentService,
    required this.propertiesService,
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
        help: 'Path to .properties files to import',
        valueHelp: 'path/to/file.properties',
      )
      ..addFlag(
        'android',
        help: 'Parse as Android resource file',
        defaultsTo: false,
      );
  }

  final EnvironmentService environmentService;
  final PropertiesService propertiesService;

  @override
  String get description => 'Import .properties files';

  @override
  String get name => 'properties';

  @override
  Future<int> run() => handleErrors(() async {
        final projectName = argResults!['project'] as String;
        final envName = argResults!['name'] as String;
        final description = argResults!['description'] as String?;
        final files = argResults!['files'] as List<String>;
        final isAndroid = argResults!['android'] as bool;

        if (files.isEmpty && argResults!.rest.isEmpty) {
          throw const FormatException(
            'At least one .properties file path is required',
          );
        }

        // Combine files from --files option and rest arguments
        final allFiles = [...files, ...argResults!.rest];

        // Read and merge all .properties files
        final mergedValues = <String, String>{};
        for (final file in allFiles) {
          logger.info('Reading $file...');
          final values = await propertiesService.readPropertiesFile(
            file,
            androidStyle: isAndroid,
          );
          mergedValues.addAll(values);
        }

        // Validate secrets
        validateSecrets(mergedValues);

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
