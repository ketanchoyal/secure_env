import 'package:mason_logger/mason_logger.dart';
import 'package:secure_env/src/core/services/environment_service.dart';
import '../base_command.dart';

/// Command to delete an environment
class DeleteCommand extends BaseCommand {
  DeleteCommand({
    required super.logger,
    EnvironmentService? environmentService,
  }) : _environmentService = environmentService ?? EnvironmentService() {
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

  final EnvironmentService _environmentService;

  @override
  String get description => 'Delete an environment';

  @override
  String get name => 'delete';

  @override
  Future<int> run() => handleErrors(() async {
        final projectName = argResults!['project'] as String;
        final envName = argResults!['name'] as String;

        await _environmentService.deleteEnvironment(
          name: envName,
          projectName: projectName,
        );

        logger.success('Deleted environment: $envName');
        return ExitCode.success.code;
      });
}
