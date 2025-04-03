import 'package:secure_env/src/core/services/environment_service.dart';
import 'package:secure_env/src/cli/commands/base_command.dart';

/// Command to edit an environment
class EditCommand extends BaseCommand {
  EditCommand({
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
      )
      ..addOption(
        'key',
        abbr: 'k',
        help: 'Key to edit',
        mandatory: true,
      )
      ..addOption(
        'value',
        abbr: 'v',
        help: 'Value to set',
        mandatory: true,
      )
      ..addFlag(
        'secret',
        abbr: 's',
        help: 'Mark value as secret',
      );
  }

  final EnvironmentService _environmentService;

  @override
  String get description => 'Edit an environment value';

  @override
  String get name => 'edit';

  @override
  Future<int> run() => handleErrors(() async {
        final projectName = argResults!['project'] as String;
        final envName = argResults!['name'] as String;
        final key = argResults!['key'] as String;
        final value = argResults!['value'] as String;
        final isSecret = argResults!['secret'] as bool;

        final env = await _environmentService.setValue(
          key: key,
          value: value,
          envName: envName,
          projectName: projectName,
          isSecret: isSecret,
        );

        logger.success('Updated environment: ${env.name}');
        logger.info('Key: $key');
        logger.info('Value: ${isSecret ? '********' : value}');
        return BaseCommand.successExitCode;
      });
}
