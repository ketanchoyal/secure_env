import 'dart:io';
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

  tearDown(() async {
    final envDir = environmentService.getProjectEnvDir('test_project');
    final dir = Directory(envDir);
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  });

  group('EditCommand', () {
    test('edits environment value successfully', () async {
      await environmentService.createEnvironment(
        name: 'test',
        projectName: 'test_project',
        initialValues: {'API_KEY': 'old_value'},
      );

      final result = await runner.run([
        'env',
        'edit',
        '--project',
        'test_project',
        '--name',
        'test',
        '--key',
        'API_KEY',
        '--value',
        'new_value',
      ]);

      expect(result, equals(0));
      expect(
          logger.successLogs, contains(contains('Updated environment: test')));
      expect(
        logger.infoLogs,
        containsAll([
          contains('Key: API_KEY'),
          contains('Value: new_value'),
        ]),
      );

      final env = await environmentService.loadEnvironment(
        name: 'test',
        projectName: 'test_project',
      );
      expect(env?.values['API_KEY'], equals('new_value'));
    });

    test('edits environment value as secret', () async {
      await environmentService.createEnvironment(
        name: 'test',
        projectName: 'test_project',
        initialValues: {'API_KEY': 'old_value'},
      );

      final result = await runner.run([
        'env',
        'edit',
        '--project',
        'test_project',
        '--name',
        'test',
        '--key',
        'API_KEY',
        '--value',
        'secret_value',
        '--secret',
      ]);

      expect(result, equals(0));
      expect(
          logger.successLogs, contains(contains('Updated environment: test')));
      expect(
        logger.infoLogs,
        containsAll([
          contains('Key: API_KEY'),
          contains('Value: ********'),
        ]),
      );

      final env = await environmentService.loadEnvironment(
        name: 'test',
        projectName: 'test_project',
      );
      expect(env?.values['API_KEY'], equals('secret_value'));
    });

    test('shows error when environment does not exist', () async {
      final result = await runner.run([
        'env',
        'edit',
        '--project',
        'test_project',
        '--name',
        'non_existent',
        '--key',
        'API_KEY',
        '--value',
        'new_value',
      ]);

      expect(result, equals(1));
      expect(logger.errorLogs, contains(contains('Environment not found')));
    });

    test('requires project, name, key, and value arguments', () async {
      final result = await runner.run(['env', 'edit']);
      expect(result, equals(1));
      expect(
        logger.errorLogs,
        contains(contains('Option project is mandatory')),
      );
    });
  });
}
