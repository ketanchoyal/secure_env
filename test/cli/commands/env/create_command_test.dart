import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:secure_env/src/cli/commands/env/env_command.dart';
import 'package:secure_env/src/core/services/environment_service.dart';
import 'package:test/test.dart';

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

  group('CreateCommand', () {
    test('creates environment successfully', () async {
      //Delete existing environment
      await environmentService.deleteEnvironment(
        name: 'test',
        projectName: 'test_project',
      );
      final result = await runner.run([
        'env',
        'create',
        '--project',
        'test_project',
        'test',
        '--description',
        'Test environment',
        '--key',
        'API_KEY',
        '--value',
        'test123',
      ]);

      expect(result, equals(ExitCode.success.code));
      expect(
        logger.successLogs,
        contains(contains('Created environment: test')),
      );

      final env = await environmentService.loadEnvironment(
        name: 'test',
        projectName: 'test_project',
      );
      expect(env, isNotNull);
      expect(env?.name, equals('test'));
      expect(env?.projectName, equals('test_project'));
      expect(env?.description, equals('Test environment'));
      expect(env?.values, equals({'API_KEY': 'test123'}));
    });

    test('creates environment with multiple key-value pairs', () async {
      //Delete existing environment
      await environmentService.deleteEnvironment(
        name: 'test',
        projectName: 'test_project_2',
      );
      final result = await runner.run([
        'env',
        'create',
        '--project',
        'test_project_2',
        'test',
        '--description',
        'Test environment',
        '--key',
        'API_KEY',
        '--value',
        'test123',
        '--key',
        'DEBUG',
        '--value',
        'true',
      ]);

      expect(result, equals(ExitCode.success.code));
      expect(
        logger.successLogs,
        contains(contains('Created environment: test')),
      );

      final env = await environmentService.loadEnvironment(
        name: 'test',
        projectName: 'test_project_2',
      );
      expect(env, isNotNull);
      expect(env?.name, equals('test'));
      expect(env?.projectName, equals('test_project_2'));
      expect(env?.description, equals('Test environment'));
      expect(
        env?.values,
        equals({
          'API_KEY': 'test123',
          'DEBUG': 'true',
        }),
      );
    });

    test('shows error when environment already exists', () async {
      await environmentService.createEnvironment(
        name: 'test',
        projectName: 'test_project',
      );

      final result = await runner.run([
        'env',
        'create',
        '--project',
        'test_project',
        'test',
      ]);

      expect(result, equals(ExitCode.software.code));
      expect(
        logger.errorLogs,
        contains(contains('Environment already exists')),
      );
    });

    test('requires project and name arguments', () async {
      final result = await runner.run(['env', 'create']);
      expect(result, equals(ExitCode.usage.code));
      expect(
        logger.errorLogs,
        contains(contains('Option project is mandatory')),
      );
    });

    test('creates environment with no initial values', () async {
      //Delete existing environment
      await environmentService.deleteEnvironment(
        name: 'test',
        projectName: 'test_project_3',
      );
      final result = await runner.run([
        'env',
        'create',
        '--project',
        'test_project_3',
        'test',
      ]);

      expect(result, equals(ExitCode.success.code));
      expect(
        logger.successLogs,
        contains(contains('Created environment: test')),
      );

      final env = await environmentService.loadEnvironment(
        name: 'test',
        projectName: 'test_project_3',
      );
      expect(env, isNotNull);
      expect(env?.name, equals('test'));
      expect(env?.projectName, equals('test_project_3'));
      expect(env?.values, isEmpty);
    });
  });
}
