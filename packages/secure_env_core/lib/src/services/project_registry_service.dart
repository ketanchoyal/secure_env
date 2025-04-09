import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:secure_env_core/src/exceptions/exceptions.dart';
import 'package:secure_env_core/src/models/models.dart';
import 'package:secure_env_core/src/utils/logger.dart';

/// Service for managing a central registry of all secure_env projects.
class ProjectRegistryService {
  /// Creates a new instance of [ProjectRegistryService].
  ProjectRegistryService({
    required this.logger,
  }) {
    _initializeRegistry();
  }

  /// Logger instance for tracking operations.
  final Logger logger;

  /// The path to the registry directory.
  late final String _registryPath;

  /// The path to the registry file containing project metadata.
  late final String _registryFilePath;

  /// Initialize the registry directory and file.
  void _initializeRegistry() {
    final homeDir = Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
    if (homeDir == null) {
      throw StateError('Could not determine user home directory');
    }

    _registryPath = path.join(homeDir, '.secure_env_registry');
    _registryFilePath = path.join(_registryPath, 'registry.json');

    final registryDir = Directory(_registryPath);
    if (!registryDir.existsSync()) {
      registryDir.createSync(recursive: true);
      // Initialize empty registry
      File(_registryFilePath).writeAsStringSync(jsonEncode({'projects': []}));
    }
  }

  /// Register a new project in the central registry.
  Future<ProjectMetadata> registerProject(ProjectMetadata metadata) async {
    final existingProject = await getProjectMetadata(metadata.name);
    if (existingProject != null) {
      throw ValidationException('Project "${metadata.name}" already exists');
    }

    final now = DateTime.now();
    final newMetadata = metadata.copyWith(
      createdAt: now,
      updatedAt: now,
    );

    final registry = await _readRegistry();
    registry['projects'] = [
      ...registry['projects'] as List,
      newMetadata.toJson(),
    ];

    await _writeRegistry(registry);
    logger.info('Registered project "${metadata.name}" in central registry');
    return newMetadata;
  }

  /// Update the metadata for an existing project.
  Future<ProjectMetadata> updateProjectMetadata(ProjectMetadata metadata) async {
    final existingProject = await getProjectMetadata(metadata.name);
    if (existingProject == null) {
      throw ValidationException('Project "${metadata.name}" not found');
    }

    final updatedMetadata = metadata.copyWith(
      createdAt: existingProject.createdAt,
      updatedAt: DateTime.now(),
    );

    final registry = await _readRegistry();
    final projects = registry['projects'] as List;
    final index = projects.indexWhere(
      (p) => (p as Map<String, dynamic>)['name'] == metadata.name,
    );
    projects[index] = updatedMetadata.toJson();

    await _writeRegistry(registry);
    logger.info('Updated metadata for project "${metadata.name}" in central registry');
    return updatedMetadata;
  }

  /// Remove a project from the central registry.
  Future<void> unregisterProject(String name) async {
    final registry = await _readRegistry();
    final projects = registry['projects'] as List;
    final index = projects.indexWhere(
      (p) => (p as Map<String, dynamic>)['name'] == name,
    );

    if (index == -1) {
      throw ValidationException('Project "$name" not found');
    }

    projects.removeAt(index);
    await _writeRegistry(registry);
    logger.info('Unregistered project "$name" from central registry');
  }

  /// Get the metadata for a specific project.
  Future<ProjectMetadata?> getProjectMetadata(String name) async {
    final registry = await _readRegistry();
    final projects = registry['projects'] as List;
    final projectJson = projects.cast<Map<String, dynamic>>().firstWhere(
          (p) => p['name'] == name,
          orElse: () => <String, dynamic>{},
        );

    if (projectJson.isEmpty) {
      return null;
    }

    return ProjectMetadata.fromJson(projectJson);
  }

  /// List all registered projects.
  Future<List<ProjectMetadata>> listProjects({ProjectStatus? status}) async {
    final registry = await _readRegistry();
    final projects = registry['projects'] as List;
    final allProjects = projects
        .cast<Map<String, dynamic>>()
        .map(ProjectMetadata.fromJson)
        .toList();

    if (status != null) {
      return allProjects.where((p) => p.status == status).toList();
    }

    return allProjects;
  }

  /// Read the registry file.
  Future<Map<String, dynamic>> _readRegistry() async {
    try {
      final file = File(_registryFilePath);
      if (!await file.exists()) {
        return {'projects': []};
      }

      final content = await file.readAsString();
      return jsonDecode(content) as Map<String, dynamic>;
    } catch (e) {
      logger.error('Failed to read project registry: $e');
      return {'projects': []};
    }
  }

  /// Write to the registry file.
  Future<void> _writeRegistry(Map<String, dynamic> registry) async {
    try {
      final file = File(_registryFilePath);
      await file.writeAsString(jsonEncode(registry));
    } catch (e) {
      logger.error('Failed to write project registry: $e');
      throw StateError('Failed to update project registry');
    }
  }
}
