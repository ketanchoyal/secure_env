import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:secure_env_core/secure_env_core.dart';
import '../base_command.dart';

/// Command to create a new environment
class CreateCommand extends BaseCommand {
  CreateCommand({
    required super.logger,
    required super.projectService,
  }) {
    argParser
      ..addOption(
        'description',
        abbr: 'd',
        help: 'Environment description',
      )
      ..addOption(
        'template',
        abbr: 't',
        help: 'Template to use for initial values',
      )
      ..addMultiOption(
        'key',
        abbr: 'k',
        help: 'Key to add to the environment',
      )
      ..addMultiOption(
        'value',
        abbr: 'v',
        help: 'Value to add to the environment',
      );
  }

  late final EnvironmentService _environmentService;

  @override
  String get description => 'Create a new environment';

  @override
  String get name => 'create';

  @override
  Future<int> run() => handleErrors(() async {
        final project = await projectService.getProjectFromCurrentDirectory();
        if (project == null) {
          throw 'No project found in the current directory. Please run "secure_env init" first.';
        }
        _environmentService = await EnvironmentService.forProject(
            project: project, projectService: projectService, logger: logger);
        // final projectName = argResults!['project'] as String;
        final description = argResults!['description'] as String?;
        final template = argResults!['template'] as String?;
        final keys = argResults!['key'] as List<String>;
        final values = argResults!['value'] as List<String>;

        if (argResults!.rest.isEmpty) {
          throw const ValidationException('Environment name is required');
        }

        final envName = argResults!.rest.first;

        // Check if environment already exists
        final existingEnv = await _environmentService.loadEnvironment(
          name: envName,
        );

        if (existingEnv != null) {
          throw 'Environment already exists: $envName';
        }

        Map<String, String>? initialValues;
        if (template != null) {
          // Load values from template
          final templateEnv = await _environmentService.loadEnvironment(
            name: template,
          );

          if (templateEnv == null) {
            throw 'Template environment not found: $template';
          }

          initialValues = Map.from(templateEnv.values);
        }

        // Add key-value pairs if provided
        if (keys.isNotEmpty) {
          if (keys.length != values.length) {
            throw 'Number of keys and values must match';
          }

          initialValues ??= {};
          for (var i = 0; i < keys.length; i++) {
            initialValues[keys[i]] = values[i];
          }
        }

        final env = await _environmentService.createEnvironment(
          name: envName,
          description: description,
          initialValues: initialValues,
        );

        logger.success('Created environment: ${env.name}');
        if (env.description != null) {
          logger.info('Description: ${env.description}');
        }

        return ExitCode.success.code;
      });
}
