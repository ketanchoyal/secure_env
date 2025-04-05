import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:test/test.dart';
import '../../../../src/cli/commands/env/env_command.dart';
import 'package:secure_env_core/src/services/environment_service.dart';
import '../../../utils/test_logger.dart';

void main() {
  late TestLogger logger;
  late EnvironmentService environmentService;
  late CommandRunner<int> runner;

  setUp(() {
    logger = TestLogger();
    environmentService = EnvironmentService(
      logger: logger,
    );
    runner = CommandRunner<int>('test', 'Test runner')
      ..addCommand(EnvCommand(
        logger: logger,
        environmentService: environmentService,
      ));
  });

  tearDown(() async {
    final envDir = environmentService.getProjectEnvDir('test_project');
    final dir = Directory(envDir);
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  });

  group('DeleteCommand', () {
    test('deletes environment successfully', () async {
      await environmentService.createEnvironment(
        name: 'test',
        projectName: 'test_project',
      );

      final result = await runner.run([
        'env',
        'delete',
        '--project',
        'test_project',
        '--name',
        'test',
      ]);

      expect(result, equals(ExitCode.success.code));
      expect(
          logger.successLogs, contains(contains('Deleted environment: test')));

      final env = await environmentService.loadEnvironment(
        name: 'test',
        projectName: 'test_project',
      );
      expect(env, isNull);
    });

    test('handles non-existent environment gracefully and returns success',
        () async {
      final result = await runner.run([
        'env',
        'delete',
        '--project',
        'test_project',
        '--name',
        'non_existent',
      ]);

      expect(result, equals(ExitCode.success.code));
      expect(logger.errorLogs, contains(contains('Environment not found')));
    });

    test('requires project and name arguments', () async {
      final result = await runner.run(['env', 'delete']);
      expect(result, equals(ExitCode.usage.code));
      expect(
        logger.errorLogs,
        contains(contains('Option project is mandatory')),
      );
    });
  });
}
