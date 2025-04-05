import 'package:mason_logger/mason_logger.dart';
import 'package:test/test.dart';
import 'package:args/command_runner.dart';
import 'package:secure_env/src/cli/commands/env/env_command.dart';
import 'package:secure_env/src/core/services/environment_service.dart';
import '../../../utils/test_logger.dart';

void main() {
  late TestLogger logger;
  late EnvironmentService environmentService;
  late CommandRunner<int> runner;

  setUp(() {
    logger = TestLogger();
    environmentService = EnvironmentService();
    runner = CommandRunner<int>('test', 'Test runner')
      ..addCommand(EnvCommand(
        logger: logger,
        environmentService: environmentService,
      ));
  });

  group('InfoCommand', () {
    test('shows error when environment does not exist', () async {
      final result = await runner
          .run(['env', 'info', '--project', 'test', '--name', 'non_existent']);
      expect(result, equals(ExitCode.software.code));
      expect(logger.errorLogs, contains(contains('Environment not found')));
    });

    test('shows environment information when it exists', () async {
      await environmentService.createEnvironment(
        name: 'test',
        projectName: 'test_project',
        description: 'Test environment',
        initialValues: {'API_KEY': 'test123'},
      );

      final result = await runner
          .run(['env', 'info', '--project', 'test_project', '--name', 'test']);
      expect(result, equals(ExitCode.success.code));
      expect(
        logger.infoLogs,
        containsAll([
          contains('Environment Information'),
          contains('Name: test'),
          contains('Project: test_project'),
          contains('Description: Test environment'),
          contains('API_KEY'),
        ]),
      );
    });

    test('requires project and name arguments', () async {
      final result = await runner.run(['env', 'info']);
      expect(result, equals(ExitCode.usage.code));
      expect(
        logger.errorLogs,
        contains(contains('Option project is mandatory')),
      );
    });
  });
}
