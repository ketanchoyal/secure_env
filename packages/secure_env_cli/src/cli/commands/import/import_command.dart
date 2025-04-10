import 'package:mason_logger/mason_logger.dart';
import 'package:secure_env_core/secure_env_core.dart';

import '../base_command.dart';
import 'env_import_command.dart';
import 'properties_import_command.dart';
import 'xcconfig_import_command.dart';

/// Group command for importing environment files
class ImportCommand extends BaseCommand {
  ImportCommand({
    required super.logger,
    required super.projectService,
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
    final envService = EnvService();
    final propertiesService = PropertiesService();
    final xconfigService = XConfigService();

    addSubcommand(EnvImportCommand(
      logger: logger,
      projectService: projectService,
      envService: envService,
    ));
    addSubcommand(PropertiesImportCommand(
      logger: logger,
      propertiesService: propertiesService,
      projectService: projectService,
    ));
    addSubcommand(XConfigImportCommand(
      logger: logger,
      xconfigService: xconfigService,
      projectService: projectService,
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
