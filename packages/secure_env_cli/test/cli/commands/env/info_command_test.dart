import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:secure_env_core/secure_env_core.dart';
import 'package:test/test.dart';
import 'package:args/command_runner.dart';
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

  group('InfoCommand', () {
    test('shows error when environment does not exist', () async {
      final result = await runner.run([
        'env',
        'info',
        '--name',
        'non_existent',
      ]);
      expect(result, equals(ExitCode.software.code));
      expect(logger.errorLogs, contains(contains('Environment not found')));
    });

    test('shows environment information when it exists', () async {
      await environmentService.createEnvironment(
        name: 'test',
        description: 'Test environment',
        initialValues: {'API_KEY': 'test123'},
      );

      final result = await runner.run([
        'env',
        'info',
        '--name',
        'test',
      ]);
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

    test('shows project information when name is not provided', () async {
      final result = await runner.run(['env', 'info']);
      expect(result, equals(ExitCode.success.code));
      expect(
        logger.infoLogs,
        containsAll([
          contains('Project Information'),
          contains('Available Environments:'),
        ]),
      );
    });
  });
}
