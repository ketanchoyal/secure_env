import 'package:mason_logger/mason_logger.dart';
import 'package:secure_env_core/secure_env_core.dart';
import '../base_command.dart';

/// Command to import .properties files
class PropertiesImportCommand extends BaseCommand {
  PropertiesImportCommand({
    required super.logger,
    required this.propertiesService,
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
        help: 'Path to .properties files to import',
        valueHelp: 'path/to/file.properties',
      )
      ..addFlag(
        'android',
        help: 'Parse as Android resource file',
        defaultsTo: false,
      );
  }

  late final EnvironmentService _environmentService;
  final PropertiesService propertiesService;

  @override
  String get description => 'Import .properties files';

  @override
  String get name => 'properties';

  @override
  Future<int> run() => handleErrors(() async {
        final project = await projectService.getProjectFromCurrentDirectory();
        if (project == null) {
          throw 'No project found in the current directory. Please run "secure_env init" first.';
        }
        _environmentService = await EnvironmentService.forProject(
            project: project, projectService: projectService, logger: logger);
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
