import '../../../core/services/environment_service.dart';
import '../../../core/services/format/env.dart';
import '../base_command.dart';

/// Command to import .env files
class EnvImportCommand extends BaseCommand {
  EnvImportCommand({
    required super.logger,
    required this.environmentService,
    required this.envService,
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
        help: 'Path to .env files to import',
        valueHelp: 'path/to/.env',
      );
  }

  final EnvironmentService environmentService;
  final EnvService envService;

  @override
  String get description => 'Import .env files';

  @override
  String get name => 'env';

  @override
  Future<int> run() => handleErrors(() async {
        final projectName = argResults!['project'] as String;
        final envName = argResults!['name'] as String;
        final description = argResults!['description'] as String?;
        final files = argResults!['files'] as List<String>;

        if (files.isEmpty && argResults!.rest.isEmpty) {
          throw const FormatException('At least one .env file path is required');
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
