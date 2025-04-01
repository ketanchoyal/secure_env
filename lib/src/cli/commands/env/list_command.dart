import '../../../core/services/environment_service.dart';
import '../base_command.dart';

/// Command to list environments
class ListCommand extends BaseCommand {
  ListCommand({
    required super.logger,
    required this.environmentService,
  }) {
    argParser.addOption(
      'project',
      abbr: 'p',
      help: 'Project name',
      mandatory: true,
    );
  }

  final EnvironmentService environmentService;

  @override
  String get description => 'List all environments';

  @override
  String get name => 'list';

  @override
  Future<int> run() => handleErrors(() async {
        final projectName = argResults!['project'] as String;

        final environments = await environmentService.listEnvironments(projectName);

        if (environments.isEmpty) {
          logger.info('No environments found for project: $projectName');
          return BaseCommand.successExitCode;
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

        return BaseCommand.successExitCode;
      });
}
