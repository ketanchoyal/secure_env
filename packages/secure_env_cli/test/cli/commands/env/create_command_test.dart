import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import '../../../../src/cli/commands/env/env_command.dart';
import 'package:secure_env_core/secure_env_core.dart';
import 'package:test/test.dart';

import '../../../utils/test_logger.dart';

void main() {
  late TestLogger logger;
  late EnvironmentService environmentService;
  late ProjectService projectService;
  late CommandRunner<int> runner;
  late String currentDirectoryPath;
  late Project project;

  setUp(() async {
    logger = TestLogger();
    currentDirectoryPath = Directory.systemTemp.createTempSync().path;
    projectService = ProjectService(
      logger: logger,
      registryService: ProjectRegistryService(logger: logger),
    );
    projectService.testCurrentDirectoryPath = currentDirectoryPath;
    project = await projectService.createProjectFromCurrentDirectory(
      name: 'test_project',
    );
    environmentService = await EnvironmentService.forProject(
      project: project,
      projectService: projectService,
      logger: logger,
    );
    runner = CommandRunner<int>('test', 'Test runner')
      ..addCommand(EnvCommand(
        logger: logger,
        projectService: projectService,
      ));
  });

  tearDown(() async {
    await projectService.deleteProject(
      project.path,
    );
  });

  group('CreateCommand', () {
    test('creates environment successfully', () async {
      // await environmentService.deleteEnvironment(
      //   name: 'test',
      //   projectName: 'test_project',
      // );
      final result = await runner.run([
        'env',
        'create',
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
      );
      expect(env, isNotNull);
      expect(env?.name, equals('test'));
      expect(env?.description, equals('Test environment'));
      expect(env?.values, equals({'API_KEY': 'test123'}));
    });

    test('creates environment with multiple key-value pairs', () async {
      final result = await runner.run([
        'env',
        'create',
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
      );
      expect(env, isNotNull);
      expect(env?.name, equals('test'));
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
      );

      final result = await runner.run([
        'env',
        'create',
        'test',
      ]);

      expect(result, equals(ExitCode.software.code));
      expect(
        logger.errorLogs,
        contains(contains('Environment already exists')),
      );
    });

    test('requires name arguments', () async {
      final result = await runner.run(['env', 'create']);
      expect(result, equals(ExitCode.usage.code));
      expect(
        logger.errorLogs,
        contains(contains('Environment name is required')),
      );
    });

    test('creates environment with no initial values', () async {
      final result = await runner.run([
        'env',
        'create',
        'test',
      ]);

      expect(result, equals(ExitCode.success.code));
      expect(
        logger.successLogs,
        contains(contains('Created environment: test')),
      );

      final env = await environmentService.loadEnvironment(
        name: 'test',
      );
      expect(env, isNotNull);
      expect(env?.name, equals('test'));
      expect(env?.values, isEmpty);
    });
  });
}
