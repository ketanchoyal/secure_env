import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:secure_env_core/src/services/environment_service.dart';
import '../base_command.dart';

/// Command to edit an environment
class EditCommand extends BaseCommand {
  EditCommand({
    required super.logger,
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

  late final EnvironmentService _environmentService;

  @override
  String get description => 'Edit an environment value';

  @override
  String get name => 'edit';

  @override
  Future<int> run() => handleErrors(() async {
        final project = await projectService.getProjectFromCurrentDirectory();
        if (project == null) {
          throw 'No project found in the current directory. Please run "secure_env init" first.';
        }
        _environmentService = await EnvironmentService.forProject(
            project: project, projectService: projectService, logger: logger);
        final envName = argResults!['name'] as String;
        final key = argResults!['key'] as String;
        final value = argResults!['value'] as String;
        final isSecret = argResults!['secret'] as bool;

        final env = await _environmentService.setValue(
          key: key,
          value: value,
          envName: envName,
          isSecret: isSecret,
        );

        logger.success('Updated environment: ${env.name}');
        logger.info('Key: $key');
        logger.info('Value: ${isSecret ? '********' : value}');
        return ExitCode.success.code;
      });
}
