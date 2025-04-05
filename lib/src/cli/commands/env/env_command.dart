import 'package:args/command_runner.dart';

import '../../../core/logger.dart';
import '../../../core/services/environment_service.dart';
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
    EnvironmentService? environmentService,
  }) {
    addSubcommand(CreateCommand(
      logger: logger,
      environmentService: environmentService,
    ));
    addSubcommand(ListCommand(
      logger: logger,
      environmentService: environmentService,
    ));
    addSubcommand(InfoCommand(
      logger: logger,
      environmentService: environmentService,
    ));
    addSubcommand(EditCommand(
      logger: logger,
      environmentService: environmentService,
    ));
    addSubcommand(DeleteCommand(
      logger: logger,
      environmentService: environmentService,
    ));
    addSubcommand(ExportCommand(
      logger: logger,
      environmentService: environmentService,
    ));
  }

  @override
  String get description => 'Manage environments';

  @override
  String get name => 'env';
}
