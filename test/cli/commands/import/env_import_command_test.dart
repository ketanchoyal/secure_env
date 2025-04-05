import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:test/test.dart';
import 'package:args/command_runner.dart';
import 'package:secure_env/src/cli/commands/import/env_import_command.dart';
import 'package:secure_env/src/core/services/environment_service.dart';
import 'package:secure_env/src/core/services/format/env.dart';
import '../../../utils/test_logger.dart';

void main() {
  late TestLogger logger;
  late EnvironmentService environmentService;
  late EnvService envService;
  late CommandRunner<int> runner;
  late Directory secureEnvDir;

  setUp(() async {
    logger = TestLogger();
    environmentService = EnvironmentService();
    envService = EnvService();
    runner = CommandRunner<int>('test', 'Test runner')
      ..addCommand(EnvImportCommand(
        logger: logger,
        environmentService: environmentService,
        envService: envService,
      ));

    // Create .secure_env directory in the project root
    secureEnvDir = Directory('.secure_env');
    if (!await secureEnvDir.exists()) {
      await secureEnvDir.create();
    }

    // Create test .env files
    await File('.secure_env/test1.env').writeAsString('''
API_KEY=test123
DB_URL=localhost:5432
APP_NAME="Test App"
''');

    await File('.secure_env/test2.env').writeAsString('''
API_VERSION=v1
DEBUG=true
APP_ENV=development
''');
  });

  tearDown(() async {
    // Clean up .secure_env directory
    if (await secureEnvDir.exists()) {
      final files = await secureEnvDir.list().toList();
      for (final file in files) {
        if (file is File) {
          await file.delete();
        }
      }
    }
  });

  group('EnvImportCommand', () {
    test('requires project and name arguments', () async {
      final result = await runner.run([
        'env',
      ]);
      expect(result, equals(ExitCode.usage.code));
      expect(
        logger.errorLogs,
        contains(contains('Option project is mandatory')),
      );
    });

    test('imports single .env file successfully', () async {
      final result = await runner.run([
        'env',
        '--project',
        'test_project',
        '--name',
        'test_env',
        '.secure_env/test1.env',
      ]);

      expect(result, equals(ExitCode.success.code));
      expect(logger.successLogs, contains(contains('Successfully imported')));

      // Verify environment was created with correct values
      final env = await environmentService.loadEnvironment(
        name: 'test_env',
        projectName: 'test_project',
      );
      expect(env, isNotNull);
      expect(env!.values['API_KEY'], equals('test123'));
      expect(env.values['DB_URL'], equals('localhost:5432'));
      expect(env.values['APP_NAME'], equals('Test App'));
    });

    test('imports multiple .env files and merges values', () async {
      final result = await runner.run([
        'env',
        '--project',
        'test_project',
        '--name',
        'test_env',
        '.secure_env/test1.env',
        '.secure_env/test2.env',
      ]);

      expect(result, equals(ExitCode.success.code));
      expect(logger.successLogs, contains(contains('Successfully imported')));

      // Verify environment was created with merged values
      final env = await environmentService.loadEnvironment(
        name: 'test_env',
        projectName: 'test_project',
      );
      expect(env, isNotNull);
      expect(env!.values['API_KEY'], equals('test123'));
      expect(env.values['API_VERSION'], equals('v1'));
      expect(env.values['DEBUG'], equals('true'));
    });

    test('updates existing environment when it exists', () async {
      // Create initial environment
      await environmentService.createEnvironment(
        name: 'existing_env',
        projectName: 'test_project',
        initialValues: {'EXISTING_KEY': 'old_value'},
      );

      final result = await runner.run([
        'env',
        '--project',
        'test_project',
        '--name',
        'existing_env',
        '.secure_env/test1.env',
      ]);

      expect(result, equals(ExitCode.success.code));
      expect(
          logger.infoLogs, contains(contains('Updating existing environment')));

      // Verify environment was updated
      final env = await environmentService.loadEnvironment(
        name: 'existing_env',
        projectName: 'test_project',
      );
      expect(env, isNotNull);
      expect(
          env!.values['EXISTING_KEY'], equals('old_value')); // Kept old value
      expect(env.values['API_KEY'], equals('test123')); // Added new value
    });

    test('handles invalid .env file gracefully', () async {
      // Create invalid .env file
      await File('.secure_env/invalid.env').writeAsString('''
INVALID_LINE
KEY=value=invalid
=no_key
''');

      final result = await runner.run([
        'env',
        '--project',
        'test_project',
        '--name',
        'test_env',
        '.secure_env/invalid.env',
      ]);

      expect(result, equals(ExitCode.software.code));
      expect(logger.errorLogs, contains(contains('Error: Empty key found')));
    });

    test('handles non-existent file', () async {
      final result = await runner.run([
        'env',
        '--project',
        'test_project',
        '--name',
        'test_env',
        '.secure_env/non_existent.env',
      ]);

      expect(result, equals(ExitCode.software.code));
      expect(logger.errorLogs, contains(contains('File not found')));
    });
  });
}
