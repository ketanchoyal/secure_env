import 'package:mason_logger/mason_logger.dart';
import 'package:test/test.dart';
import 'package:args/command_runner.dart';
import '../../../../src/cli/commands/import/import_command.dart';
import '../../../utils/test_logger.dart';

void main() {
  late TestLogger logger;
  late CommandRunner<int> runner;

  setUp(() {
    logger = TestLogger();
    runner = CommandRunner<int>('test', 'Test runner')
      ..addCommand(ImportCommand(logger: logger));
  });

  group('ImportCommand', () {
    test('registers all subcommands', () {
      final command = ImportCommand(logger: logger);

      expect(command.subcommands, contains('env'));
      expect(command.subcommands, contains('properties'));
      expect(command.subcommands, contains('xcconfig'));
      expect(command.subcommands.length, equals(3));
    });

    // test('shows help when no subcommand is provided', () async {
    //   try {
    //     await runner.run(['import']);
    //   } catch (e) {}
    //   // expect(logger.infoLogs, hasLength(1));
    //   expect(logger.infoLogs.first, contains('Available subcommands:'));
    //   expect(logger.infoLogs.first, contains('env          Import .env files'));
    //   expect(logger.infoLogs.first,
    //       contains('properties   Import .properties files'));
    //   expect(logger.infoLogs.first,
    //       contains('xcconfig     Import .xcconfig files'));
    // });

    test('has correct name and description', () {
      final command = ImportCommand(logger: logger);
      expect(command.name, equals('import'));
      expect(command.description, contains('Import environment files'));
    });
  });
}
