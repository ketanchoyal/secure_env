import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:secure_env_core/secure_env_core.dart';
import 'package:test/test.dart';
import 'package:args/command_runner.dart';
import '../../../../lib/src/cli/commands/import/properties_import_command.dart';
import '../../../utils/test_logger.dart';

void main() {
  late TestLogger logger;
  late EnvironmentService environmentService;
  late PropertiesService propertiesService;
  late ProjectService projectService;
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
    propertiesService = PropertiesService();
    runner = CommandRunner<int>('test', 'Test runner')
      ..addCommand(PropertiesImportCommand(
          logger: logger,
          propertiesService: propertiesService,
          projectService: projectService));

    // Create .secure_env directory in the project root
    secureEnvDir = Directory('.secure_env');
    if (!await secureEnvDir.exists()) {
      await secureEnvDir.create();
    }

    // Create test .properties files
    await File('.secure_env/test1.properties').writeAsString('''
api.key=test123
db.url=localhost:5432
app.name=Test App
''');

    await File('.secure_env/test2.properties').writeAsString('''
api.version=v1
debug=true
app.env=development
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

  group('PropertiesImportCommand', () {
    test('requires name arguments', () async {
      final result = await runner.run(['properties']);
      expect(result, equals(ExitCode.usage.code));
      expect(
        logger.errorLogs,
        contains(contains('Option name is mandatory')),
      );
    });

    test('imports single .properties file successfully', () async {
      final result = await runner.run([
        'properties',
        '--name',
        'test_env',
        '.secure_env/test1.properties',
      ]);

      expect(result, equals(ExitCode.success.code));
      expect(logger.successLogs, contains(contains('Successfully imported')));

      // Verify environment was created with correct values
      final env = await environmentService.loadEnvironment(
        name: 'test_env',
      );
      expect(env, isNotNull);
      expect(env!.values['api.key'],
          equals('test123')); // Should be converted to uppercase
      expect(env.values['db.url'], equals('localhost:5432'));
      expect(env.values['app.name'], equals('Test App'));
    });

    test('imports multiple .properties files and merges values', () async {
      final result = await runner.run([
        'properties',
        '--name',
        'test_env',
        '.secure_env/test1.properties',
        '.secure_env/test2.properties',
      ]);

      expect(result, equals(ExitCode.success.code));
      expect(logger.successLogs, contains(contains('Successfully imported')));

      // Verify environment was created with merged values
      final env = await environmentService.loadEnvironment(
        name: 'test_env',
      );
      expect(env, isNotNull);
      expect(env!.values['api.key'], equals('test123'));
      expect(env.values['api.version'], equals('v1'));
      expect(env.values['debug'], equals('true'));
    });

    test('updates existing environment when it exists', () async {
      // Create initial environment
      await environmentService.createEnvironment(
        name: 'existing_env',
        initialValues: {'EXISTING_KEY': 'old_value'},
      );

      final result = await runner.run([
        'properties',
        '--name',
        'existing_env',
        '.secure_env/test1.properties',
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
      expect(env.values['api.key'], equals('test123')); // Added new value
    });

    test('handles invalid .properties file gracefully', () async {
      // Create invalid .properties file
      await File('.secure_env/invalid.properties').writeAsString('''
invalid_line
key=value=invalid
=no_key
''');

      final result = await runner.run([
        'properties',
        '--name',
        'test_env',
        '.secure_env/invalid.properties',
      ]);

      expect(result, equals(ExitCode.usage.code));
      expect(logger.errorLogs, contains(contains('Error: Empty key found')));
    });

    test('handles non-existent file', () async {
      final result = await runner.run([
        'properties',
        '--name',
        'test_env',
        '.secure_env/non_existent.properties',
      ]);

      expect(result, equals(ExitCode.unavailable.code));
      expect(logger.errorLogs, contains(contains('File not found')));
    });

    test('converts property keys to environment format', () async {
      await File('.secure_env/format.properties').writeAsString('''
my.api.key=value123
some.nested.config=nested-value
camelCase.key=camel-value
''');

      final result = await runner.run([
        'properties',
        '--name',
        'test_env',
        '.secure_env/format.properties',
      ]);

      expect(result, equals(ExitCode.success.code));

      // Verify key format conversion
      final env = await environmentService.loadEnvironment(
        name: 'test_env',
      );
      expect(env, isNotNull);
      expect(env!.values['my.api.key'], equals('value123'));
      expect(env.values['some.nested.config'], equals('nested-value'));
      expect(env.values['camelCase.key'], equals('camel-value'));
    });
  });
}
