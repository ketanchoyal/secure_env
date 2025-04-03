import 'package:args/command_runner.dart';
import 'package:test/test.dart';
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
      ..addCommand(EnvCommand(logger: logger));
  });

  group('DeleteCommand', () {
    test('deletes environment successfully', () async {
      await environmentService.createEnvironment(
        name: 'test',
        projectName: 'test_project',
        initialValues: {'API_KEY': 'value'},
      );

      final result = await runner.run([
        'env',
        'delete',
        '--project',
        'test_project',
        '--name',
        'test',
      ]);

      expect(result, equals(0));
      expect(
        logger.successLogs,
        contains(contains('Deleted environment: test')),
      );

      final env = await environmentService.loadEnvironment(
        name: 'test',
        projectName: 'test_project',
      );
      expect(env, isNull);
    });

    test('shows error when environment does not exist', () async {
      final result = await runner.run([
        'env',
        'delete',
        '--project',
        'test_project',
        '--name',
        'non_existent',
      ]);

      expect(result, equals(1));
      expect(logger.errorLogs, contains(contains('Environment not found')));
    });

    test('requires project and name arguments', () async {
      final result = await runner.run(['env', 'delete']);
      expect(result, equals(1));
      expect(
        logger.errorLogs,
        contains(contains('Option project is mandatory')),
      );
    });
  });
}
