import 'dart:io';
import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as path;

import 'package:secure_env_core/src/services/environment_service.dart';
import '../base_command.dart';

/// Command to show environment information
class InfoCommand extends BaseCommand {
  InfoCommand({
    required super.logger,
    required super.projectService,
  }) {
    argParser
      ..addOption(
        'name',
        abbr: 'n',
        help: 'Environment name',
      );
  }

  late final EnvironmentService _environmentService;

  @override
  String get description => 'Show environment information';

  @override
  String get name => 'info';

  @override
  Future<int> run() => handleErrors(() async {
        final project = await projectService.getProjectFromCurrentDirectory();
        if (project == null) {
          throw 'No project found in the current directory. Please run "secure_env init" first.';
        }

        final envName = argResults!['name'] as String?;

        // Then display information about the project
        if (envName == null || envName.isEmpty) {
          logger
            ..info('Project Information')
            ..info('---------------------')
            ..info('Name: ${project.name}')
            ..info('Path: ${project.path}')
            ..info('Description: ${project.description ?? 'N/A'}')
            ..info('Last Modified: ${project.updatedAt}')
            ..info('')
            ..info('Available Environments:')
            ..info('------------------------');
          for (final env in project.environments) {
            logger.info('  • ${env}');
          }
          logger.info('');
          logger.info(
              'Use "secure_env env info --name <env_name>" to get more information about a specific environment.');
          return ExitCode.success.code;
        }

        _environmentService = await EnvironmentService.forProject(
            project: project, projectService: projectService, logger: logger);

        final env = await _environmentService.loadEnvironment(
          name: envName,
        );

        if (env == null) {
          throw 'Environment not found: $envName';
        }

        final envDir = _environmentService.getProjectEnvDir();
        final envFile = File(path.join(envDir, '$envName.json'));
        final envFileStats = await envFile.stat();

        logger
          ..info('Environment Information')
          ..info('---------------------')
          ..info('Name: ${env.name}')
          ..info('Project: ${project.name}');

        if (env.description != null) {
          logger.info('Description: ${env.description}');
        }

        logger
          ..info('Storage Location: ${envFile.path}')
          ..info('Last Modified: ${env.lastModified}')
          ..info(
              'File Size: ${(envFileStats.size / 1024).toStringAsFixed(2)} KB')
          ..info('Number of Values: ${env.values.length}')
          ..info('')
          ..info('Value Keys:')
          ..info('-----------');

        for (final key in env.values.keys) {
          logger.info('  • $key');
        }

        return ExitCode.success.code;
      });
}
