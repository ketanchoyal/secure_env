import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:secure_env_core/secure_env_core.dart';
import 'package:test/test.dart';
import 'package:args/command_runner.dart';
import '../../../../src/cli/commands/import/xcconfig_import_command.dart';
import '../../../utils/test_logger.dart';

void main() {
  late TestLogger logger;
  late EnvironmentService environmentService;
  late XConfigService xconfigService;
  late CommandRunner<int> runner;
  late ProjectService projectService;
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
    xconfigService = XConfigService();
    runner = CommandRunner<int>('test', 'Test runner')
      ..addCommand(XConfigImportCommand(
        logger: logger,
        xconfigService: xconfigService,
        projectService: projectService,
      ));

    // Create .secure_env directory in the project root
    secureEnvDir = Directory('.secure_env');
    if (!await secureEnvDir.exists()) {
      await secureEnvDir.create();
    }

    // Create test .xcconfig files
    await File('.secure_env/test1.xcconfig').writeAsString('''
API_KEY = test123
DB_URL = localhost:5432
APP_NAME = Test App
''');

    await File('.secure_env/test2.xcconfig').writeAsString('''
API_VERSION = v1
DEBUG = true
APP_ENV = development
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

  group('XConfigImportCommand', () {
    test('requires name arguments', () async {
      final result = await runner.run(['xcconfig']);
      expect(result, equals(ExitCode.usage.code));
      expect(
        logger.errorLogs,
        contains(contains('Option name is mandatory')),
      );
    });

    test('imports single .xcconfig file successfully', () async {
      final result = await runner.run([
        'xcconfig',
        '--name',
        'test_env',
        '.secure_env/test1.xcconfig',
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

    test('imports multiple .xcconfig files and merges values', () async {
      final result = await runner.run([
        'xcconfig',
        '--name',
        'test_env',
        '.secure_env/test1.xcconfig',
        '.secure_env/test2.xcconfig',
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

    test('handles includes and variable substitution in xcconfig files',
        () async {
      await File('.secure_env/base.xcconfig').writeAsString('''
// Base configuration
BASE_URL = https://api.example.com
ENV = production
''');

      await File('.secure_env/complex.xcconfig').writeAsString('''
#include "base.xcconfig"
API_ENDPOINT = \$(BASE_URL)/v1
DEBUG_MODE = false
SERVICE_URL = \$(BASE_URL)/\$(ENV)/api
''');

      final result = await runner.run([
        'xcconfig',
        '--name',
        'test_env',
        '.secure_env/complex.xcconfig',
      ]);

      expect(result, equals(ExitCode.success.code));

      // Verify environment includes base values and resolved variables
      final env = await environmentService.loadEnvironment(
        name: 'test_env',
      );
      expect(env, isNotNull);
      expect(env!.values['BASE_URL'], equals('https://api.example.com'));
      expect(env.values['ENV'], equals('production'));
      expect(env.values['API_ENDPOINT'], equals('https://api.example.com/v1'));
      expect(env.values['DEBUG_MODE'], equals('false'));
      expect(env.values['SERVICE_URL'],
          equals('https://api.example.com/production/api'));
    });

    test('updates existing environment when it exists', () async {
      // Create initial environment
      await environmentService.createEnvironment(
        name: 'existing_env',
        initialValues: {'EXISTING_KEY': 'old_value'},
      );

      final result = await runner.run([
        'xcconfig',
        '--name',
        'existing_env',
        '.secure_env/test1.xcconfig',
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

    test('handles invalid .xcconfig file gracefully', () async {
      // Create invalid .xcconfig file
      await File('.secure_env/invalid.xcconfig').writeAsString('''
INVALID_LINE
KEY = value = invalid
= no_key
''');

      final result = await runner.run([
        'xcconfig',
        '--name',
        'test_env',
        '.secure_env/invalid.xcconfig',
      ]);

      expect(result, equals(ExitCode.usage.code));
      expect(logger.errorLogs, contains(contains('Error: Empty key found')));
    });

    test('handles non-existent file', () async {
      final result = await runner.run([
        'xcconfig',
        '--name',
        'test_env',
        '.secure_env/non_existent.xcconfig',
      ]);

      expect(result, equals(ExitCode.unavailable.code));
      expect(logger.errorLogs, contains(contains('File not found')));
    });

    test('handles missing include files gracefully', () async {
      await File('.secure_env/missing_include.xcconfig').writeAsString('''
#include "non_existent.xcconfig"
TEST_KEY = value
''');

      final result = await runner.run([
        'xcconfig',
        '--name',
        'test_env',
        '.secure_env/missing_include.xcconfig',
      ]);

      expect(result, equals(ExitCode.unavailable.code));
      expect(logger.errorLogs, contains(contains('File not found')));
    });
  });
}
