import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
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

  // /// Get the path to a project's configuration file
  // String _getProjectConfigPath(String basePath, String projectName) {
  //   return Platform.isWindows
  //       ? '$basePath\.secure_env\$projectName\config.json'
  //       : '$basePath/.secure_env/$projectName/config.json';
  // }
  /// Get the path to a project's configuration file
  String _getProjectConfigPath(String basePath) {
    return Platform.isWindows
        ? '$basePath\.secure_env\config.json'
        : '$basePath/.secure_env/config.json';
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
  String _validateProjectName(String name, {bool returnCleanName = false}) {
    // Check if the name is empty or contains invalid characters
    // Only allow alphanumeric characters, underscores, and hyphens
    // If the name is empty, throw an exception
    // If the name contains invalid characters, replace them with underscores
    // and throw an exception with a suggestion to use the cleaned name
    // If returnCleanName is true, return the cleaned name instead of throwing an exception
    if (name.isEmpty) {
      throw ValidationException('Project name cannot be empty');
    }

    if (!RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(name)) {
      final cleanName = name.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
      if (returnCleanName) {
        return cleanName;
      }
      throw ValidationException(
        'Invalid project name "$name". Project names can only contain letters, numbers, underscores, and hyphens. '
        'Consider using "$cleanName" instead.',
      );
    }
    if (name.length > 50) {
      throw ValidationException(
        'Project name "$name" is too long. '
        'Project names must be less than 50 characters.',
      );
    }
    if (name.length < 3) {
      throw ValidationException(
        'Project name "$name" is too short. '
        'Project names must be at least 3 characters long.',
      );
    }
    return name;
  }

  /// Save project configuration and sync with registry
  Future<void> _saveProjectConfig(Project project) async {
    final configPath = _getProjectConfigPath(project.path);
    final configFile = File(configPath);
    await configFile.parent.create(recursive: true);
    await configFile.writeAsString(jsonEncode(project.toJson()));

    // Sync with registry
    try {
      final metadata = await registryService.getProjectMetadata(project.id);
      if (metadata == null) {
        // New project, register it
        await registryService.registerProject(
          ProjectMetadata(
            name: project.name,
            basePath: project.path,
            createdAt: project.createdAt,
            updatedAt: project.updatedAt,
            status: project.status,
            id: project.id,
          ),
        );
      } else if (metadata.updatedAt != project.updatedAt ||
          metadata.status != project.status ||
          metadata.id != project.id) {
        // Check if the id has changed
        // Update existing project metadata if timestamps, status, or id differ
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

  @visibleForTesting
  String? testCurrentDirectoryPath;

  /// Create a new Project in current directory
  /// This will take current directory as the base path and uses the name of the directory as the project name
  /// If the name is not provided, it will use the last part of the path as the project name
  /// If project name is invalid, it will sanitize the name and use it and store original name in metadata
  Future<Project> createProjectFromCurrentDirectory(
      {String? name, String? description}) async {
    final currentPath = testCurrentDirectoryPath ?? Directory.current.path;
    name ??= currentPath.split(Platform.pathSeparator).last;
    final cleanName = _validateProjectName(name, returnCleanName: true);

    if (name != cleanName) {
      logger.warn(
        'Project name "$name" is invalid. '
        'Using sanitized name "$cleanName" instead.',
      );
    }

    return await createProject(
      name: cleanName,
      path: currentPath,
      metadata: {
        'original_name': name,
      },
      description: description,
    );
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
    final id = now.millisecondsSinceEpoch.toString();
    final project = Project(
      name: projectName,
      path: path,
      id: id,
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

  /// Get Project from current directory
  /// This will take current directory as the base path
  Future<Project?> getProjectFromCurrentDirectory() async {
    final currentPath = testCurrentDirectoryPath ?? Directory.current.path;
    return await getProject(currentPath);
  }

  /// Get a project by name
  Future<Project?> getProject(String path) async {
    try {
      final configPath = _getProjectConfigPath(path);
      final configFile = File(configPath);
      if (!await configFile.exists()) {
        return null;
      }

      final content = await configFile.readAsString();
      final projectJson = jsonDecode(content) as Map<String, dynamic>;
      return Project.fromJson(projectJson);
    } catch (e) {
      logger.error('Failed to get project at "$path": $e');
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
        (metadata) => getProject(metadata.basePath),
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
    final existingProject = await getProject(project.path);
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
    final project = await getProject(path);
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
  Future<void> deleteProject(String path) async {
    final project = await getProject(path);
    if (project == null) {
      logger.error('Project at "$path" not found');
      return;
      // throw ValidationException('Project at "$path" not found');
    }

    // Mark project for deletion in registry
    final metadata = await registryService.getProjectMetadata(project.name);
    if (metadata != null) {
      await registryService.updateProjectMetadata(
        metadata.copyWith(status: ProjectStatus.markedForDeletion),
      );
    }

    // Remove project directory
    final secureEnvPath = Platform.isWindows
        ? '${project.path}\.secure_env'
        : '${project.path}/.secure_env';
    final projectPath = Platform.isWindows
        ? '$secureEnvPath\${project.name}'
        : '$secureEnvPath/${project.name}';
    final projectDir = Directory(projectPath);
    if (projectDir.existsSync()) {
      await projectDir.delete(recursive: true);
    }

    // Remove project configuration file
    final configPath = _getProjectConfigPath(project.path);
    final configFile = File(configPath);
    if (await configFile.exists()) {
      await configFile.delete();
    }

    // Unregister project from central registry
    await registryService.unregisterProject(project.id);

    logger.info('Deleted project at "$path" at path "$path"');
  }
}
