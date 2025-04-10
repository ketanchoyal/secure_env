import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' show join;

import '../models/project.dart';

/// Service for managing projects in the Secure Env application
class ProjectService {
  Future<void> createProject({
    required String name,
    required String path,
    String? description,
  }) async {
    // Validate project name and path
    if (name.isEmpty) {
      throw ArgumentError('Project name cannot be empty');
    }
    if (path.isEmpty) {
      throw ArgumentError('Project path cannot be empty');
    }

    // Normalize path and ensure it exists
    final projectPath = path.trim();
    final directory = Directory(projectPath);

    // Create directory if it doesn't exist
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    // Create project config file
    final configFile = File(join(projectPath, 'secure_env.json'));
    if (await configFile.exists()) {
      throw Exception('Project config already exists at ${configFile.path}');
    }

    // Create project instance
    final project = Project(
      name: name,
      path: projectPath,
      description: description,
    );

    // Write config to file
    await configFile.writeAsString(
      const JsonEncoder.withIndent('  ').convert(project.toJson()),
    );
  }

  /// List all projects by scanning for secure_env.json files
  Future<List<Project>> listProjects() async {
    // TODO: Replace with actual config directory scanning
    // For now, return dummy data
    return [
      Project(
        name: 'Demo Project',
        path: '/path/to/demo',
        description: 'A demo project',
      ),
      Project(
        name: 'Test Project',
        path: '/path/to/test',
        description: 'A test project',
      ),
    ];
  }

  // TODO: Add methods for:
  // - getProject
  // - updateProject
  // - deleteProject
  // - validateProjectPath
  // - validateProjectName
}
