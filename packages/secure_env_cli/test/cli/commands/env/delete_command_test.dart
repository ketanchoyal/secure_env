import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:secure_env_core/secure_env_core.dart';
import 'package:test/test.dart';
import '../../../../lib/src/cli/commands/env/env_command.dart';
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
        name: 'test_project');
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

  group('DeleteCommand', () {
    test('deletes environment successfully', () async {
      await environmentService.createEnvironment(
        name: 'test',
      );

      final result = await runner.run([
        'env',
        'delete',
        '--name',
        'test',
      ]);

      expect(result, equals(ExitCode.success.code));
      expect(
          logger.successLogs, contains(contains('Deleted environment: test')));

      final env = await environmentService.loadEnvironment(
        name: 'test',
      );
      expect(env, isNull);
    });

    test('handles non-existent environment gracefully and returns usage code',
        () async {
      final result = await runner.run([
        'env',
        'delete',
        '--name',
        'non_existent',
      ]);

      expect(result, equals(ExitCode.usage.code));
      expect(logger.errorLogs,
          contains(contains('Environment non_existent not found')));
    });
  });
}
