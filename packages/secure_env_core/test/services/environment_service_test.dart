import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:secure_env_core/secure_env_core.dart';
import 'package:secure_env_core/src/exceptions/file_not_found_exception.dart';
import 'package:test/test.dart';
import '../utils/test_logger.dart';

void main() {
  late ProjectService projectService;
  late ProjectRegistryService registryService;
  late EnvironmentService environmentService;
  late TestLogger logger;
  late Directory projectStorageDir;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('secure_env_test_');
    logger = TestLogger();
    final encryptionService = EncryptionService()..initialize('test-password');

    // Create storage directories
    projectStorageDir = Directory(path.join(tempDir.path, 'project_storage'));
    final envStorageDir = Directory(path.join(tempDir.path, 'env_storage'));
    await projectStorageDir.create();
    await envStorageDir.create();

    // Initialize storage services
    final envStorageService = SecureStorageService(
      encryptionService: encryptionService,
      logger: logger,
      storageDirectory: envStorageDir.path,
    );

    // Initialize services
    registryService = ProjectRegistryService(
      logger: logger,
    );

    projectService = ProjectService(
      logger: logger,
      registryService: registryService,
    );
    // Create test project
    final project = await projectService.createProject(
      name: 'test_project',
      path: path.join(tempDir.path, 'test_project'),
      description: 'Test project',
    );

    // Initialize environment service for project
    environmentService = await EnvironmentService.forProject(
      project: project,
      projectService: projectService,
      secureStorage: envStorageService,
      logger: logger,
    );
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  group('EnvironmentService', () {
    test('createEnvironment creates new environment with correct values',
        () async {
      final env = await environmentService.createEnvironment(
        name: 'test',
        description: 'Test environment',
        initialValues: {'KEY': 'value'},
      );

      expect(env.name, equals('test'));
      expect(env.description, equals('Test environment'));
      expect(env.values, equals({'KEY': 'value'}));
    });

    test('loadEnvironment returns null for non-existent environment', () async {
      final env = await environmentService.loadEnvironment(
        name: 'non_existent',
      );

      expect(env, isNull);
    });

    test('saveEnvironment persists environment to disk', () async {
      final env = Environment(
        name: 'test',
        values: {'KEY': 'value'},
        lastModified: DateTime.now(),
      );

      await environmentService.saveEnvironment(env);

      final loaded = await environmentService.loadEnvironment(
        name: 'test',
      );

      expect(loaded, isNotNull);
      expect(loaded?.name, equals(env.name));
      expect(loaded?.values, equals(env.values));
    });

    test('listEnvironments returns all environments for project', () async {
      // Clean up any existing environments first
      final dir = Directory(environmentService.getProjectEnvDir());
      if (dir.existsSync()) {
        await dir.delete(recursive: true);
      }

      await environmentService.createEnvironment(
        name: 'dev',
      );
      await environmentService.createEnvironment(
        name: 'prod',
      );

      final envs = await environmentService.listEnvironments();

      expect(envs.length, equals(2));
      expect(
        envs.map((e) => e.name).toList()..sort(),
        equals(['dev', 'prod']..sort()),
      );
    });

    test('deleteEnvironment removes environment from disk', () async {
      await environmentService.createEnvironment(
        name: 'test',
      );

      await environmentService.deleteEnvironment(
        name: 'test',
      );

      final env = await environmentService.loadEnvironment(
        name: 'test',
      );

      expect(env, isNull);
    });

    group('importEnvironment', () {
      test('imports from .env file', () async {
        final envFile = File('test/fixtures/env/dev.env');

        final env = await environmentService.importEnvironment(
          filePath: envFile.path,
          envName: 'test',
          description: 'Imported from .env',
        );

        expect(env.name, equals('test'));
        expect(env.description, equals('Imported from .env'));
        expect(
          env.values,
          equals({
            'KEY1': 'value1',
            'KEY2': 'quoted value',
            'KEY3': 'single quoted',
            'MULTI': 'first=second=third',
          }),
        );
      });

      test('imports from Debug.xcconfig file', () async {
        final debugXcconfigFile = File('test/fixtures/xcconfig/Debug.xcconfig');

        final env = await environmentService.importEnvironment(
          filePath: debugXcconfigFile.path,
          envName: 'debug',
          description: 'Debug configuration',
        );

        expect(env.name, equals('debug'));
        expect(env.description, equals('Debug configuration'));
        expect(
          env.values,
          equals({
            'PRODUCT_BUNDLE_IDENTIFIER': 'com.example.myapp',
            'MARKETING_VERSION': '1.0.0',
            'CURRENT_PROJECT_VERSION': '1',
            'DEVELOPMENT_TEAM': 'ABCD12345E',
            'SWIFT_VERSION': '5.0',
            'IPHONEOS_DEPLOYMENT_TARGET': '14.0',
            'TARGETED_DEVICE_FAMILY': '1,2',
          }),
        );
      });

      test('imports from .properties file', () async {
        final propertiesFile = File('test/fixtures/properties/app.properties');

        final env = await environmentService.importEnvironment(
          filePath: propertiesFile.path,
          envName: 'test',
          description: 'Imported from properties',
        );

        expect(env.name, equals('test'));
        expect(env.description, equals('Imported from properties'));
        expect(
          env.values,
          equals({
            'app.name': 'MyApp',
            'app.version': '1.0.0',
            'app.build': '123',
            'multi.value': 'first=second',
          }),
        );
      });

      test('throws error for unsupported file format', () async {
        final invalidFile = File('${tempDir.path}/test.txt');
        await invalidFile.writeAsString('invalid=content');

        expect(
          () async => await environmentService.importEnvironment(
            filePath: invalidFile.path,
            envName: 'test',
          ),
          throwsA(isA<ValidationException>().having(
              (e) => e.message,
              'message',
              contains(
                  'Unsupported file format. Supported formats: .env, .xcconfig, .properties'))),
        );
      });

      test('throws error for non-existent file', () async {
        expect(
          () => environmentService.importEnvironment(
            filePath: '${tempDir.path}/non_existent.env',
            envName: 'test',
          ),
          throwsA(isA<FileNotFoundException>()),
        );
      });
    });
  });
}
