import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:secure_env_core/secure_env_core.dart';
import 'package:test/test.dart';
import '../utils/test_logger.dart';

void main() {
  late ProjectService projectService;
  late ProjectRegistryService registryService;
  late TestLogger logger;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory(path.join(Directory.current.path, 'Ecommerce'))
        .create();
    logger = TestLogger();

    registryService = ProjectRegistryService(
      logger: logger,
    );

    projectService = ProjectService(
      logger: logger,
      registryService: registryService,
    );
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  group('ProjectService', () {
    test('createProject creates new project with correct values', () async {
      final project = await projectService.createProject(
        name: 'test_project',
        path: tempDir.path,
        description: 'Test project',
        metadata: {'key': 'value'},
      );

      expect(project.name, equals('test_project'));
      expect(
        project.path,
        equals(tempDir.path),
      );
      expect(project.description, equals('Test project'));
      expect(project.metadata, equals({'key': 'value'}));
      expect(project.status, equals(ProjectStatus.active));
      expect(project.environments, isEmpty);
    });
    test(
        'createProjectFromCurrentDirectory creates new project with correct values',
        () async {
      projectService.testCurrentDirectoryPath = Directory.current.path +
          "/Name With Space"; // Set the current directory for testing
      final project = await projectService.createProjectFromCurrentDirectory();

      expect(project.name, equals('Name_With_Space'));
      expect(
        project.path,
        equals(projectService.testCurrentDirectoryPath),
      );
      // expect(project.description, equals('Test project'));
      expect(project.metadata, equals({'original_name': 'Name With Space'}));
      expect(project.status, equals(ProjectStatus.active));
      expect(project.environments, isEmpty);
      Directory(project.path).deleteSync(recursive: true);
    });

    test('getProject returns null for non-existent project', () async {
      final project = await projectService.getProject(tempDir.path);
      expect(project, isNull);
    });

    test('getProject returns existing project', () async {
      final created = await projectService.createProject(
        name: 'test_project',
        path: tempDir.path,
      );

      final project = await projectService.getProject(tempDir.path);
      expect(project, isNotNull);
      expect(project?.name, equals(created.name));
      expect(project?.path, equals(created.path));
    });

    test('listProjects returns all projects', () async {
      await projectService.createProject(
        name: 'project1',
        path: tempDir.path,
      );
      await projectService.createProject(
        name: 'project2',
        path: tempDir.path + Platform.pathSeparator + 'project2',
      );

      final projects = await projectService.listProjects();
      expect(projects.length, equals(2));
      expect(
        projects.map((p) => p.name).toList()..sort(),
        equals(['project1', 'project2']..sort()),
      );
    });

    test('updateProject updates project details', () async {
      final project = await projectService.createProject(
        name: 'test_project',
        path: tempDir.path,
      );

      final updated = await projectService.updateProject(
        project.copyWith(
          description: 'Updated description',
          metadata: {'key': 'value'},
        ),
      );

      expect(updated.description, equals('Updated description'));
      expect(updated.metadata, equals({'key': 'value'}));
      expect(updated.updatedAt.isAfter(project.updatedAt), isTrue);
    });

    test('archiveProject marks project as archived', () async {
      final project = await projectService.createProject(
        name: 'test_project',
        path: tempDir.path,
      );

      final archived =
          await projectService.archiveProject('test_project', project.path);
      expect(archived.status, equals(ProjectStatus.archived));
    });

    test('deleteProject removes project from storage', () async {
      final project = await projectService.createProject(
        name: 'test_project',
        path: path.join(tempDir.path, 'test_project'),
      );

      await projectService.deleteProject(project.path);
      final _project = await projectService.getProject(project.path);
      expect(_project, isNull);
    });

    group('validation', () {
      test('createProject uses directory name for empty project name',
          () async {
        final projectDir = Directory(path.join(tempDir.path, 'test_project'));
        await projectDir.create();
        final project = await projectService.createProject(
          name: '',
          path: projectDir.path,
        );
        expect(project.name, equals('test_project'));
      });

      test('createProject throws on invalid project name', () {
        expect(
          () => projectService.createProject(
            name: 'test project',
            path: path.join(tempDir.path, 'test_project'),
          ),
          throwsA(isA<ValidationException>()),
        );
      });

      test('createProject throws on empty project path', () {
        expect(
          () => projectService.createProject(
            name: 'test_project',
            path: '',
          ),
          throwsA(isA<ValidationException>()),
        );
      });

      test('createProject throws on existing project path', () async {
        final projectDir = Directory(path.join(tempDir.path, 'test_project'));
        await projectDir.create();
        await projectService.createProject(
          name: 'test_project',
          path: projectDir.path,
        );
        expect(
          () => projectService.createProject(
            name: 'test_project',
            path: projectDir.path,
          ),
          throwsA(isA<ValidationException>()),
        );
      });

      test('createProject allows non-empty directory with allowed files',
          () async {
        final projectDir = Directory(path.join(tempDir.path, 'test_project'));
        await projectDir.create();
        await File(path.join(projectDir.path, 'README.md'))
            .writeAsString('# Test');
        await File(path.join(projectDir.path, '.gitignore')).writeAsString('*');

        final project = await projectService.createProject(
          path: projectDir.path,
        );
        expect(project.path, equals(projectDir.path));
      });

      test('createProject uses directory name when name is not provided',
          () async {
        final projectDir = Directory(path.join(tempDir.path, 'my_project'));
        await projectDir.create();
        final project = await projectService.createProject(
          path: projectDir.path,
        );
        expect(project.name, equals('my_project'));
      });

      test('createProject uses current directory path', () async {
        // Create a temporary directory and set it as current
        final tempProjectDir =
            await Directory.systemTemp.createTemp('project_test_');
        final originalDir = Directory.current;
        Directory.current = tempProjectDir;

        try {
          final project = await projectService.createProject(
            name: 'test_project',
            path: tempProjectDir.path,
          );
          expect(
            Directory(project.path).resolveSymbolicLinksSync(),
            equals(Directory(tempProjectDir.path).resolveSymbolicLinksSync()),
          );
        } finally {
          // Restore original directory
          Directory.current = originalDir;
          await tempProjectDir.delete(recursive: true);
        }
      });

      test('updateProject throws for non-existent project', () {
        expect(
          () => projectService.updateProject(
            Project.create(
              name: 'non_existent',
              id: 'non_existent',
              path: path.join(tempDir.path, 'non_existent'),
            ),
          ),
          throwsA(isA<ValidationException>()),
        );
      });
    });
  });
}
