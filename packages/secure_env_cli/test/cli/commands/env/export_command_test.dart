import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:secure_env_core/secure_env_core.dart';
import 'package:test/test.dart';
import 'package:args/command_runner.dart';
import '../../../../src/cli/commands/env/export_command.dart';
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
      ..addCommand(ExportCommand(
        logger: logger,
        projectService: projectService,
      ));

    // Create a test environment
    await environmentService.createEnvironment(
      name: 'test_env',
      description: 'Test environment',
      initialValues: {
        'API_KEY': 'test123',
        'DB_URL': 'localhost:5432',
        'APP_NAME': 'Test App',
      },
    );
  });

  tearDown(() async {
    await projectService.deleteProject(
      project.path,
    );
  });

  group('ExportCommand', () {
    test('requires environment name', () async {
      final result = await runner.run([
        'export',
      ]);
      expect(result, equals(ExitCode.usage.code));
      expect(
          logger.errorLogs, contains(contains('Environment name is required')));
    });

    test('shows error when environment does not exist', () async {
      final result = await runner.run([
        'export',
        'non_existent',
      ]);
      expect(result, equals(ExitCode.software.code));
      expect(logger.errorLogs, contains(contains('Environment not found')));
    });

    test('exports to .env format by default', () async {
      final outputPath = '.secure_env/test.env';
      final result = await runner.run([
        'export',
        'test_env',
        '--output',
        outputPath,
      ]);

      expect(result, equals(ExitCode.success.code));
      expect(logger.successLogs, contains(contains('Environment exported to')));

      final content = await File(outputPath).readAsString();
      expect(content, contains('API_KEY=test123'));
      expect(content, contains('DB_URL=localhost:5432'));
      expect(content,
          contains('APP_NAME="Test App"')); // Should be quoted due to space
    });

    test('exports to properties format', () async {
      final outputPath = '.secure_env/test.properties';
      final result = await runner.run([
        'export',
        'test_env',
        '--format',
        'properties',
        '--output',
        outputPath,
      ]);

      expect(result, equals(ExitCode.success.code));
      final content = await File(outputPath).readAsString();
      expect(content, contains('API_KEY=test123'));
      expect(content, contains('DB_URL=localhost:5432'));
      expect(content, contains('APP_NAME=Test App'));
    });

    test('exports to xcconfig format', () async {
      final outputPath = '.secure_env/test.xcconfig';
      final result = await runner.run([
        'export',
        'test_env',
        '--format',
        'xcconfig',
        '--output',
        outputPath,
      ]);

      expect(result, equals(ExitCode.success.code));
      final content = await File(outputPath).readAsString();
      expect(content, contains('API_KEY = test123'));
      expect(content, contains('DB_URL = localhost:5432'));
      expect(content, contains('APP_NAME = Test App'));
    });

    test('creates output directory if it does not exist', () async {
      final outputPath = '.secure_env/nested/dir/test.env';
      final result = await runner.run([
        'export',
        'test_env',
        '--output',
        outputPath,
      ]);

      expect(result, equals(ExitCode.success.code));
      expect(await File(outputPath).exists(), isTrue);
    });

    test('uses environment name for output file if no path specified',
        () async {
      final result = await runner.run([
        'export',
        'test_env',
      ]);

      expect(result, equals(ExitCode.success.code));
      expect(await File('.secure_env/test_env.env').exists(), isTrue);
    });
  });
}
