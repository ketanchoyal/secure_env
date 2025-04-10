import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:secure_env_core/src/services/environment_service.dart';
import '../base_command.dart';

/// Command to list all environments
class ListCommand extends BaseCommand {
  ListCommand({
    required super.logger,
    required super.projectService,
  }) {
    argParser.addOption(
      'project',
      abbr: 'p',
      help: 'Project name',
      mandatory: true,
    );
  }

  late final EnvironmentService _environmentService;

  @override
  String get description => 'List all environments';

  @override
  String get name => 'list';

  @override
  Future<int> run() => handleErrors(() async {
        final project = await projectService.getProject(Directory.current.path);
        if (project == null) {
          throw 'No project found in the current directory. Please run "secure_env init" first.';
        }
        _environmentService = await EnvironmentService.forProject(
            project: project, projectService: projectService, logger: logger);
        final projectName = argResults!['project'] as String;

        final environments = await _environmentService.listEnvironments();

        if (environments.isEmpty) {
          logger.info('No environments found for project: $projectName');
          return ExitCode.success.code;
        }

        logger.info('Environments for project: $projectName\n');

        for (final env in environments) {
          logger
            ..info('  ${env.name}')
            ..info('  ${'-' * env.name.length}');

          if (env.description != null) {
            logger.info('  Description: ${env.description}');
          }

          logger
            ..info('  Last modified: ${env.lastModified ?? 'Never'}')
            ..info('  Values: ${env.values.length}')
            ..info('');
        }

        return ExitCode.success.code;
      });
}
