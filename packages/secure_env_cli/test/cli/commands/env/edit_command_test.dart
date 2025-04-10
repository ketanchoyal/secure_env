import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:secure_env_core/secure_env_core.dart';
import 'package:test/test.dart';
import '../../../../src/cli/commands/env/env_command.dart';
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
      registryService: ProjectRegistryService.test(logger: logger),
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

  group('EditCommand', () {
    test('edits environment value successfully', () async {
      await environmentService.createEnvironment(
        name: 'test',
        initialValues: {'API_KEY': 'old_value'},
      );

      final result = await runner.run([
        'env',
        'edit',
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
      );
      expect(env?.values['API_KEY'], equals('new_value'));
    });

    test('edits environment value as secret', () async {
      await environmentService.createEnvironment(
        name: 'test',
        initialValues: {'API_KEY': 'old_value'},
      );

      final result = await runner.run([
        'env',
        'edit',
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
      );
      expect(env?.values['API_KEY'], equals('secret_value'));
    });

    test('shows error when environment does not exist', () async {
      final result = await runner.run([
        'env',
        'edit',
        '--name',
        'non_existent',
        '--key',
        'API_KEY',
        '--value',
        'new_value',
      ]);

      expect(result, equals(ExitCode.usage.code));
      expect(logger.errorLogs,
          contains(contains('Environment non_existent not found')));
    });

    test('requires name, key, and value arguments', () async {
      final result = await runner.run(['env', 'edit']);
      expect(result, equals(ExitCode.usage.code));
      expect(
        logger.errorLogs,
        contains(contains('Option name is mandatory')),
      );
    });

    test('requires value argument when editing', () async {
      final result = await runner
          .run(['env', 'edit', '--name', 'test', '--key', 'API_KEY']);
      expect(result, equals(ExitCode.usage.code));
      expect(
        logger.errorLogs,
        contains(contains('Option value is mandatory')),
      );
    });
  });
}
