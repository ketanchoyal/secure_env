import 'dart:convert';
import 'dart:io';

import 'package:secure_env_core/src/exceptions/exceptions.dart';
import 'package:secure_env_core/src/utils/logger.dart';
import 'package:secure_env_core/src/models/models.dart';

import 'project_registry_service.dart';

/// Service for managing secure environment projects
class ProjectService {
  /// Creates a new instance of [ProjectService]
  ProjectService({
    required this.logger,
    required this.registryService,
  });

  /// Registry service for managing project metadata
  final ProjectRegistryService registryService;

  /// Logger instance
  final Logger logger;

  /// Get the path to a project's configuration file
  String _getProjectConfigPath(String basePath, String projectName) {
    return Platform.isWindows
        ? '$basePath\.secure_env\$projectName\config.json'
        : '$basePath/.secure_env/$projectName/config.json';
  }

  /// Validate project path
  Future<void> _validateProjectPath(String path) async {
    //path will always have .secure_env so remove it
    final originalPath = path.replaceFirst(
        Platform.isWindows ? '\.secure_env' : '/.secure_env', '');
    if (originalPath.isEmpty) {
      throw ValidationException('Project path cannot be empty');
    }

    final dir = Directory(path);
    if (await dir.exists()) {
      throw ValidationException('There is already a project at the given path');
    }
  }

  /// Validate project name
  void _validateProjectName(String name) {
    if (name.isEmpty) {
      throw ValidationException('Project name cannot be empty');
    }

    if (!RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(name)) {
      final cleanName = name.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
      throw ValidationException(
        'Invalid project name "$name". Project names can only contain letters, numbers, underscores, and hyphens. '
        'Consider using "$cleanName" instead.',
      );
    }
  }

  /// Save project configuration and sync with registry
  Future<void> _saveProjectConfig(Project project) async {
    final configPath = _getProjectConfigPath(project.path, project.name);
    final configFile = File(configPath);
    await configFile.parent.create(recursive: true);
    await configFile.writeAsString(jsonEncode(project.toJson()));

    // Sync with registry
    try {
      final metadata = await registryService.getProjectMetadata(project.name);
      if (metadata == null) {
        // New project, register it
        await registryService.registerProject(
          ProjectMetadata(
            name: project.name,
            basePath: project.path,
            createdAt: project.createdAt,
            updatedAt: project.updatedAt,
            status: project.status,
          ),
        );
      } else if (metadata.updatedAt != project.updatedAt ||
          metadata.status != project.status) {
        // Update existing project metadata if timestamps or status differ
        await registryService.updateProjectMetadata(
          metadata.copyWith(
            updatedAt: project.updatedAt,
            status: project.status,
          ),
        );
      }
    } catch (e) {
      logger.error('Failed to sync project with registry: $e');
    }
  }

  /// Create a new project
  Future<Project> createProject({
    String? name,
    required String path,
    String? description,
    Map<String, String>? metadata,
  }) async {
    final projectName = (name?.isNotEmpty ?? false)
        ? name!
        : path.split(Platform.pathSeparator).last;

    // Create project directory structure
    final secureEnvPath =
        Platform.isWindows ? '$path\.secure_env' : '$path/.secure_env';

    // Validate project path and name
    await _validateProjectPath(secureEnvPath);
    _validateProjectName(projectName);

    final now = DateTime.now();
    final project = Project(
      name: projectName,
      path: path,
      description: description,
      environments: [],
      config: {},
      metadata: metadata ?? {},
      createdAt: now,
      updatedAt: now,
    );

    final projectPath = Platform.isWindows
        ? '$secureEnvPath\$projectName'
        : '$secureEnvPath/$projectName';

    await Directory(projectPath).create(recursive: true);

    // Save project configuration
    await _saveProjectConfig(project);

    return project;
  }

  /// Get a project by name
  Future<Project?> getProject(String name, String path) async {
    try {
      final configPath = _getProjectConfigPath(path, name);
      final configFile = File(configPath);
      if (!await configFile.exists()) {
        return null;
      }

      final content = await configFile.readAsString();
      final projectJson = jsonDecode(content) as Map<String, dynamic>;
      return Project.fromJson(projectJson);
    } catch (e) {
      logger.error('Failed to get project "$name": $e');
      return null;
    }
  }

  /// List all projects
  Future<List<Project>> listProjects() async {
    final projects = <Project>[];

    try {
      final registeredProjects = await registryService.listProjects(
        status: ProjectStatus.active,
      );

      final futures = registeredProjects.map(
        (metadata) => getProject(metadata.name, metadata.basePath),
      );
      final results = await Future.wait(futures);
      projects.addAll(results.whereType<Project>());

      return projects;
    } catch (e) {
      logger.error('Failed to list projects: $e');
      return [];
    }
  }

  /// Update project details
  Future<Project> updateProject(Project project) async {
    // Ensure project exists
    final existingProject = await getProject(project.name, project.path);
    if (existingProject == null) {
      throw ValidationException('Project "${project.name}" not found');
    }

    final now = DateTime.now();

    // Update project with new timestamp
    final updatedProject = project.copyWith(
      updatedAt: now,
    );

    // Save updated project
    await _saveProjectConfig(updatedProject);

    // Update registry metadata
    final metadata = await registryService.getProjectMetadata(project.name);
    if (metadata != null) {
      await registryService.updateProjectMetadata(
        metadata.copyWith(
          updatedAt: now,
        ),
      );
    }

    logger.info('Updated project "${project.name}"');
    return updatedProject;
  }

  /// Archive a project
  Future<Project> archiveProject(String name, String path) async {
    final project = await getProject(name, path);
    if (project == null) {
      throw ValidationException('Project "$name" not found');
    }

    final now = DateTime.now();

    final archivedProject = project.copyWith(
      status: ProjectStatus.archived,
      updatedAt: now,
    );

    await _saveProjectConfig(archivedProject);

    // Update registry metadata
    final metadata = await registryService.getProjectMetadata(name);
    if (metadata != null) {
      await registryService.updateProjectMetadata(
        metadata.copyWith(
          status: ProjectStatus.archived,
          updatedAt: now,
        ),
      );
    }

    logger.info('Archived project "$name"');
    return archivedProject;
  }

  /// Delete a project
  Future<void> deleteProject(String name, String path) async {
    final project = await getProject(name, path);
    if (project == null) {
      throw ValidationException('Project "$name" not found');
    }

    // Mark project for deletion in registry
    final metadata = await registryService.getProjectMetadata(name);
    if (metadata != null) {
      await registryService.updateProjectMetadata(
        metadata.copyWith(status: ProjectStatus.markedForDeletion),
      );
    }

    // Remove project directory
    final secureEnvPath = Platform.isWindows
        ? '${project.path}\.secure_env'
        : '${project.path}/.secure_env';
    final projectPath =
        Platform.isWindows ? '$secureEnvPath\$name' : '$secureEnvPath/$name';
    final projectDir = Directory(projectPath);
    if (projectDir.existsSync()) {
      await projectDir.delete(recursive: true);
    }

    // Remove project configuration file
    final configPath = _getProjectConfigPath(project.path, name);
    final configFile = File(configPath);
    if (await configFile.exists()) {
      await configFile.delete();
    }

    // Unregister project from central registry
    await registryService.unregisterProject(name);
  }
}
