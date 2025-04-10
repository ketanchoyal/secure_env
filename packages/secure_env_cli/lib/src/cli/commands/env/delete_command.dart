import 'package:mason_logger/mason_logger.dart';
import 'package:secure_env_core/src/services/environment_service.dart';
import '../base_command.dart';

/// Command to delete an environment
class DeleteCommand extends BaseCommand {
  DeleteCommand({
    required super.logger,
    required super.projectService,
  }) {
    argParser
      ..addOption(
        'name',
        abbr: 'n',
        help: 'Environment name',
        mandatory: true,
      );
  }

  late final EnvironmentService _environmentService;

  @override
  String get description => 'Delete an environment';

  @override
  String get name => 'delete';

  @override
  Future<int> run() => handleErrors(() async {
        final project = await projectService.getProjectFromCurrentDirectory();
        if (project == null) {
          throw 'No project found in the current directory. Please run "secure_env init" first.';
        }
        _environmentService = await EnvironmentService.forProject(
            project: project, projectService: projectService, logger: logger);

        final envName = argResults!['name'] as String;

        await _environmentService.deleteEnvironment(
          name: envName,
        );

        logger.success('Deleted environment: $envName');
        return ExitCode.success.code;
      });
}
