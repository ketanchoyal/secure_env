import '../../../core/services/environment_service.dart';
import '../base_command.dart';
import 'create_command.dart';
import 'list_command.dart';
import 'info_command.dart';

/// Group command for environment management
class EnvCommand extends BaseCommand {
  EnvCommand({
    required super.logger,
  }) {
    final environmentService = EnvironmentService();

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
  }

  @override
  String get description => 'Manage environments';

  @override
  String get name => 'env';
}
