import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:secure_env_core/secure_env_core.dart';
import 'package:test/test.dart';
import 'package:args/command_runner.dart';
import '../../../../lib/src/cli/commands/import/env_import_command.dart';
import '../../../utils/test_logger.dart';

void main() {
  late TestLogger logger;
  late EnvironmentService environmentService;
  late ProjectService projectService;
  late EnvService envService;
  late CommandRunner<int> runner;
  late Directory secureEnvDir;
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
    envService = EnvService();
    runner = CommandRunner<int>('test', 'Test runner')
      ..addCommand(EnvImportCommand(
        logger: logger,
        envService: envService,
        projectService: projectService,
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

    await File('.secure_env/empty.env').writeAsString('''
# This is an empty environment file
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
    await projectService.deleteProject(
      project.path,
    );
  });

  group('EnvImportCommand', () {
    test('requires project and name arguments', () async {
      final result = await runner.run([
        'env',
      ]);
      expect(result, equals(ExitCode.usage.code));
      expect(
        logger.errorLogs,
        contains(contains('Option name is mandatory')),
      );
    });

    test('imports single .env file successfully', () async {
      final result = await runner.run([
        'env',
        '--name',
        'test_env',
        '.secure_env/test1.env',
      ]);

      expect(result, equals(ExitCode.success.code));
      expect(logger.successLogs, contains(contains('Successfully imported')));

      // Verify environment was created with correct values
      final env = await environmentService.loadEnvironment(
        name: 'test_env',
      );
      expect(env, isNotNull);
      expect(env!.values['API_KEY'], equals('test123'));
      expect(env.values['DB_URL'], equals('localhost:5432'));
      expect(env.values['APP_NAME'], equals('Test App'));
    });

    test('imports multiple .env files and merges values', () async {
      final result = await runner.run([
        'env',
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
        initialValues: {'EXISTING_KEY': 'old_value'},
      );

      final result = await runner.run([
        'env',
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
        '--name',
        'test_env',
        '.secure_env/invalid.env',
      ]);

      expect(result, equals(ExitCode.usage.code));
      expect(logger.errorLogs, contains(contains('Error: Empty key found')));
    });

    test('handles non-existent file', () async {
      final result = await runner.run([
        'env',
        '--name',
        'test_env',
        '.secure_env/non_existent.env',
      ]);

      expect(result, equals(ExitCode.unavailable.code));
      expect(logger.errorLogs, contains(contains('File not found')));
    });

    test('handles empty .env file gracefully', () async {
      await File('.secure_env/empty.env').writeAsString('');

      final result = await runner.run([
        'env',
        '--name',
        'test_env',
        '.secure_env/empty.env',
      ]);

      expect(result, equals(ExitCode.usage.code));
      expect(logger.errorLogs, contains(contains('')));
    });
  });
}
