import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:test/test.dart';
import 'package:args/command_runner.dart';
import 'package:secure_env/src/cli/commands/env/export_command.dart';
import 'package:secure_env/src/core/services/environment_service.dart';
import '../../../utils/test_logger.dart';

void main() {
  late TestLogger logger;
  late EnvironmentService environmentService;
  late CommandRunner<int> runner;
  late Directory secureEnvDir;

  setUp(() async {
    logger = TestLogger();
    environmentService = EnvironmentService();
    runner = CommandRunner<int>('test', 'Test runner')
      ..addCommand(ExportCommand(
        logger: logger,
        environmentService: environmentService,
      ));

    // Create .secure_env directory in the project root
    secureEnvDir = Directory('.secure_env');
    if (!await secureEnvDir.exists()) {
      await secureEnvDir.create();
    }

    // Create a test environment
    await environmentService.createEnvironment(
      name: 'test_env',
      projectName: 'test_project',
      description: 'Test environment',
      initialValues: {
        'API_KEY': 'test123',
        'DB_URL': 'localhost:5432',
        'APP_NAME': 'Test App',
      },
    );
  });

  tearDown(() async {
    // Clean up .secure_env directory
    if (await secureEnvDir.exists()) {
      // Only delete files created during tests, not the directory itself
      final files = await secureEnvDir.list().toList();
      for (final file in files) {
        if (file is File) {
          await file.delete();
        }
      }
    }
  });

  group('ExportCommand', () {
    test('requires environment name', () async {
      final result = await runner.run(['export', '--project', 'test_project']);
      expect(result, equals(ExitCode.usage.code));
      expect(
          logger.errorLogs, contains(contains('Environment name is required')));
    });

    test('shows error when environment does not exist', () async {
      final result = await runner
          .run(['export', 'non_existent', '--project', 'test_project']);
      expect(result, equals(ExitCode.software.code));
      expect(logger.errorLogs, contains(contains('Environment not found')));
    });

    test('exports to .env format by default', () async {
      final outputPath = '.secure_env/test.env';
      final result = await runner.run([
        'export',
        'test_env',
        '--project',
        'test_project',
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
        '--project',
        'test_project',
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
        '--project',
        'test_project',
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
        '--project',
        'test_project',
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
        '--project',
        'test_project',
      ]);

      expect(result, equals(ExitCode.success.code));
      expect(await File('.secure_env/test_env.env').exists(), isTrue);
    });
  });
}
