import '../../../core/services/environment_service.dart';
import '../../../core/services/format/env.dart';
import '../../../core/services/format/properties.dart';
import '../../../core/services/format/xcconfig.dart';
import '../base_command.dart';
import 'env_import_command.dart';
import 'properties_import_command.dart';
import 'xcconfig_import_command.dart';

/// Group command for importing environment files
class ImportCommand extends BaseCommand {
  ImportCommand({
    required super.logger,
  }) {
    // argParser
    //   ..addFlag(
    //     'force',
    //     abbr: 'f',
    //     help: 'Force import even if environment already exists',
    //     defaultsTo: false,
    //   )
    //   ..addFlag(
    //     'merge',
    //     abbr: 'm',
    //     help: 'Merge with existing environment if it exists',
    //     defaultsTo: false,
    //   )
    //   ..addOption(
    //     'environment',
    //     abbr: 'e',
    //     help: 'Target environment name',
    //     valueHelp: 'name',
    //   );
    final environmentService = EnvironmentService();
    final envService = EnvService();
    final propertiesService = PropertiesService();
    final xconfigService = XConfigService();

    addSubcommand(EnvImportCommand(
      logger: logger,
      environmentService: environmentService,
      envService: envService,
    ));
    addSubcommand(PropertiesImportCommand(
      logger: logger,
      environmentService: environmentService,
      propertiesService: propertiesService,
    ));
    addSubcommand(XConfigImportCommand(
      logger: logger,
      environmentService: environmentService,
      xconfigService: xconfigService,
    ));
  }

  @override
  String get description => 'Import environment files';

  @override
  String get name => 'import';

  // @override
  // Future<int> run() => handleErrors(() async {
  //       if (argResults?.command == null) {
  //         // No subcommand provided, print help
  //         logger.info(usage);
  //         return ExitCode.success.code;
  //       }
  //       // Let the subcommand handle the command
  //       return ExitCode.success.code;
  //     });
}
