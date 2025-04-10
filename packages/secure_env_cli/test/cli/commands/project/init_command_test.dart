import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:secure_env_core/secure_env_core.dart';
import 'package:test/test.dart';

import '../../../../src/cli/commands/init_command.dart';
import '../../../utils/test_logger.dart';

void main() {
  late TestLogger logger;

  late ProjectService projectService;
  late CommandRunner<int> runner;

  group('InitCommand', () {
    setUp(() async {
      logger = TestLogger();
      projectService = ProjectService(
        logger: logger,
        registryService: ProjectRegistryService.test(logger: logger),
      );
      projectService.testCurrentDirectoryPath =
          Directory.systemTemp.createTempSync().path;
      runner = CommandRunner<int>('test', 'Test runner')
        ..addCommand(InitCommand(
          logger: logger,
          projectService: projectService,
        ));
    });
    tearDown(() async {
      await projectService.deleteProject(
        projectService.testCurrentDirectoryPath!,
      );
    });
    test('initializes project successfully', () async {
      final result = await runner.run([
        'init',
        '--name',
        'test_project',
        '--description',
        'Test project',
      ]);
      expect(result, ExitCode.success.code);
      final project = await projectService.getProject(
        projectService.testCurrentDirectoryPath!,
      );
      expect(project, isNotNull);
      expect(project?.name, 'test_project');
      expect(project?.description, 'Test project');
      expect(project?.path, projectService.testCurrentDirectoryPath!);
    });
  });

  group(
    'Creating multiple projects at same location',
    () {
      setUp(() async {
        logger = TestLogger();
        projectService = ProjectService(
          logger: logger,
          registryService: ProjectRegistryService.test(logger: logger),
        );
        projectService.testCurrentDirectoryPath =
            Directory.systemTemp.createTempSync().path;
        runner = CommandRunner<int>('test', 'Test runner')
          ..addCommand(InitCommand(
            logger: logger,
            projectService: projectService,
          ));
      });
      tearDown(() async {
        await projectService.deleteProject(
          projectService.testCurrentDirectoryPath!,
        );
      });
      test('fails to initialize project with existing name', () async {
        await runner.run([
          'init',
          '--name',
          'test_project',
          '--description',
          'Test project',
        ]);
        final result = await runner.run([
          'init',
          '--name',
          'test_project',
          '--description',
          'Test project 2',
        ]);
        expect(result, ExitCode.usage.code);
      });
    },
  );
  group('InitCommand with current directory without name', () {
    setUp(() async {
      logger = TestLogger();
      projectService = ProjectService(
        logger: logger,
        registryService: ProjectRegistryService.test(logger: logger),
      );
      projectService.testCurrentDirectoryPath =
          Directory.systemTemp.createTempSync().path + '/Name With Space';
      runner = CommandRunner<int>('test', 'Test runner')
        ..addCommand(InitCommand(
          logger: logger,
          projectService: projectService,
        ));
    });
    tearDown(() async {
      await projectService.deleteProject(
        projectService.testCurrentDirectoryPath!,
      );
    });
    test('initializes project successfully with current directory', () async {
      final result = await runner.run([
        'init',
        '--description',
        'Test project',
      ]);
      expect(result, ExitCode.success.code);
      final project = await projectService.getProject(
        projectService.testCurrentDirectoryPath!,
      );
      expect(project, isNotNull);
      expect(project?.description, 'Test project');
      expect(project?.path, projectService.testCurrentDirectoryPath!);
      expect(project?.name, isNotNull);
    });
  });
}
