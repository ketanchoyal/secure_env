import 'package:secure_env_core/secure_env_core.dart';
import 'package:test/test.dart';
import 'package:args/command_runner.dart';
import '../../../../src/cli/commands/import/import_command.dart';
import '../../../utils/test_logger.dart';

void main() {
  late TestLogger logger;
  late CommandRunner<int> runner;
  late ProjectService projectService;

  setUp(() {
    logger = TestLogger();
    projectService = ProjectService(
      logger: logger,
      registryService: ProjectRegistryService(logger: logger),
    );

    runner = CommandRunner<int>('test', 'Test runner')
      ..addCommand(ImportCommand(
        logger: logger,
        projectService: projectService,
      ));
  });

  group('ImportCommand', () {
    test('registers all subcommands', () {
      final command =
          ImportCommand(logger: logger, projectService: projectService);

      expect(command.subcommands, contains('env'));
      expect(command.subcommands, contains('properties'));
      expect(command.subcommands, contains('xcconfig'));
      expect(command.subcommands.length, equals(3));
    });

    // test('shows help when no subcommand is provided', () async {
    //   try {
    //     await runner.run(['import']);
    //   } catch (e) {
    //     // Catch the CommandException thrown by the runner
    //     // and check if the help message is printed
    //     expect(e, isA<UsageException>());
    //   }
    //   // expect(logger.infoLogs, hasLength(1));
    //   expect(logger.infoLogs.first, contains('Available subcommands:'));
    //   expect(logger.infoLogs.first, contains('env          Import .env files'));
    //   expect(logger.infoLogs.first,
    //       contains('properties   Import .properties files'));
    //   expect(logger.infoLogs.first,
    //       contains('xcconfig     Import .xcconfig files'));
    // });

    test('has correct name and description', () {
      final command =
          ImportCommand(logger: logger, projectService: projectService);
      expect(command.name, equals('import'));
      expect(command.description, contains('Import environment files'));
    });
  });
}
