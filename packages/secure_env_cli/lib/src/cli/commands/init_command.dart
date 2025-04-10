import 'package:mason_logger/mason_logger.dart';

import 'base_command.dart';

class InitCommand extends BaseCommand {
  InitCommand({required super.logger, required super.projectService}) {
    argParser
      ..addOption(
        'name',
        abbr: 'n',
        help: 'Project name',
      )
      ..addOption(
        'description',
        abbr: 'd',
        help: 'Project description',
      );
  }

  @override
  String get description => 'Initialize the secure environment.';

  @override
  String get name => 'init';

  @override
  Future<int> run() => handleErrors(() async {
        final projectName = argResults!['name'] as String?;
        final projectPath = null;
        //argResults!['path'] as String?;
        final projectDescription = argResults!['description'] as String?;
        // late final Project project;
        if (projectPath == null) {
          await projectService.createProjectFromCurrentDirectory(
            name: projectName,
            description: projectDescription,
          );
        } else {
          await projectService.createProject(
            name: projectName,
            path: projectPath,
            description: projectDescription,
          );
        }
        return ExitCode.success.code;
      });
}
