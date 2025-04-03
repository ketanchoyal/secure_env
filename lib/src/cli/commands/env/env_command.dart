import 'package:secure_env/src/core/services/environment_service.dart';
import 'package:secure_env/src/cli/commands/base_command.dart';
import 'package:secure_env/src/cli/commands/env/create_command.dart';
import 'package:secure_env/src/cli/commands/env/delete_command.dart';
import 'package:secure_env/src/cli/commands/env/edit_command.dart';
import 'package:secure_env/src/cli/commands/env/info_command.dart';
import 'package:secure_env/src/cli/commands/env/list_command.dart';

/// Group command for environment management
class EnvCommand extends BaseCommand {
  EnvCommand({
    required super.logger,
  }) {
    final environmentService = EnvironmentService();

    addSubcommand(
      CreateCommand(
        logger: logger,
        environmentService: environmentService,
      ),
    );
    addSubcommand(
      ListCommand(
        logger: logger,
        environmentService: environmentService,
      ),
    );
    addSubcommand(
      InfoCommand(
        logger: logger,
        environmentService: environmentService,
      ),
    );
    addSubcommand(
      EditCommand(
        logger: logger,
        environmentService: environmentService,
      ),
    );
    addSubcommand(
      DeleteCommand(
        logger: logger,
        environmentService: environmentService,
      ),
    );
  }

  @override
  String get description => 'Manage environments';

  @override
  String get name => 'env';
}
