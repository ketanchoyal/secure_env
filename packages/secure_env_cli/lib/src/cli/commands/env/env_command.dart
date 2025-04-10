import 'package:args/command_runner.dart';
import 'package:secure_env_core/secure_env_core.dart';

import 'create_command.dart';
import 'delete_command.dart';
import 'edit_command.dart';
import 'export_command.dart';
import 'info_command.dart';
import 'list_command.dart';

/// Environment management commands
class EnvCommand extends Command<int> {
  /// Creates a new environment command
  EnvCommand({
    required Logger logger,
    required ProjectService projectService,
  }) {
    addSubcommand(CreateCommand(
      logger: logger,
      projectService: projectService,
    ));
    addSubcommand(ListCommand(
      logger: logger,
      projectService: projectService,
    ));
    addSubcommand(InfoCommand(
      logger: logger,
      projectService: projectService,
    ));
    addSubcommand(EditCommand(
      logger: logger,
      projectService: projectService,
    ));
    addSubcommand(DeleteCommand(
      logger: logger,
      projectService: projectService,
    ));
    addSubcommand(ExportCommand(
      logger: logger,
      projectService: projectService,
    ));
  }

  @override
  String get description => 'Manage environments';

  @override
  String get name => 'env';
}
