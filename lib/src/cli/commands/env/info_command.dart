import 'dart:io';
import 'package:path/path.dart' as path;

import '../../../core/services/environment_service.dart';
import '../base_command.dart';

/// Command to show environment information
class InfoCommand extends BaseCommand {
  InfoCommand({
    required super.logger,
    required this.environmentService,
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
      );
  }

  final EnvironmentService environmentService;

  @override
  String get description => 'Show environment information';

  @override
  String get name => 'info';

  @override
  Future<int> run() => handleErrors(() async {
        final projectName = argResults!['project'] as String;
        final envName = argResults!['name'] as String;

        final env = await environmentService.loadEnvironment(
          name: envName,
          projectName: projectName,
        );

        if (env == null) {
          throw 'Environment not found: $envName';
        }

        final envDir = environmentService.getProjectEnvDir(projectName);
        final envFile = File(path.join(envDir, '$envName.json'));
        final envFileStats = await envFile.stat();

        logger
          ..info('Environment Information')
          ..info('---------------------')
          ..info('Name: ${env.name}')
          ..info('Project: ${env.projectName}');

        if (env.description != null) {
          logger.info('Description: ${env.description}');
        }

        logger
          ..info('Storage Location: ${envFile.path}')
          ..info('Last Modified: ${env.lastModified}')
          ..info('File Size: ${(envFileStats.size / 1024).toStringAsFixed(2)} KB')
          ..info('Number of Values: ${env.values.length}')
          ..info('')
          ..info('Value Keys:')
          ..info('-----------');

        for (final key in env.values.keys) {
          logger.info('  • $key');
        }

        return BaseCommand.successExitCode;
      });
}
