import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

import '../exceptions/exceptions.dart';
import '../models/models.dart';
import 'services.dart';
import '../utils/logger.dart';
import '../utils/default_logger.dart';

/// Service for managing environments
class EnvironmentService {
  final SecureStorageService _secureStorage;
  final Logger _logger;
  final ProjectService projectService;
  final Project project;

  EnvironmentService._(
    this.project, {
    required this.projectService,
    Logger? logger,
    SecureStorageService? secureStorage,
    EncryptionService? encryptionService,
  })  : _logger = logger ?? DefaultLogger(),
        _secureStorage = secureStorage ??
            SecureStorageService(
              encryptionService: encryptionService ?? EncryptionService()
                ..initialize('env-manager'),
              logger: logger ?? DefaultLogger(),
              storageDirectory: 'secrets',
            );

  /// Create an EnvironmentService for a specific project
  static EnvironmentService forProject({
    required Project project,
    required ProjectService projectService,
    Logger? logger,
    SecureStorageService? secureStorage,
    EncryptionService? encryptionService,
  }) {
    if (project.status == ProjectStatus.markedForDeletion) {
      throw ValidationException('Project is pending deletion');
    }
    if (project.status != ProjectStatus.active) {
      throw ValidationException('Project is not in active state');
    }

    return EnvironmentService._(
      project,
      projectService: projectService,
      logger: logger,
      secureStorage: secureStorage,
      encryptionService: encryptionService,
    );
  }

  /// Get the path to the environments directory for this project
  String getProjectEnvDir() {
    return path.join(project.path, '.secure_env', 'environments');
  }

  /// Get the path to the environment type directory
  String _getEnvTypeDir(String envType) {
    return path.join(getProjectEnvDir(), envType);
  }

  /// Sanitize a name for use in file paths
  String _sanitizeName(String name) {
    return name.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_').toLowerCase();
  }

  /// Create a new environment
  Future<Environment> createEnvironment({
    required String name,
    String? description,
    Map<String, String>? initialValues,
    Map<String, bool>? sensitiveKeys,
  }) async {
    // Create environment
    final env = Environment(
      name: name,
      description: description,
      values: initialValues ?? {},
      sensitiveKeys: sensitiveKeys ?? {},
      lastModified: DateTime.now(),
    );

    // Save environment
    await saveEnvironment(env);

    // Update project's environment list
    if (!project.environments.contains(name)) {
      await projectService.updateProject(
        project.copyWith(
          environments: [...project.environments, name],
        ),
      );
    }

    return env;
  }

  /// Import environment from a .env file
  Future<Environment> importFromEnv({
    required String filePath,
    required String name,
    String? description,
    Map<String, bool>? sensitiveKeys,
  }) async {
    final envService = EnvService();
    final values = await envService.readEnvFile(filePath);

    return createEnvironment(
      name: name,
      description: description,
      initialValues: values,
      sensitiveKeys: sensitiveKeys,
    );
  }

  /// Import environment from a .properties file
  Future<Environment> importFromProperties({
    required String filePath,
    required String name,
    String? description,
    Map<String, bool>? sensitiveKeys,
  }) async {
    final propertiesService = PropertiesService();
    final values = await propertiesService.readPropertiesFile(filePath);

    return createEnvironment(
      name: name,
      description: description,
      initialValues: values,
      sensitiveKeys: sensitiveKeys,
    );
  }

  /// Import environment from a .xcconfig file
  Future<Environment> importFromXcconfig({
    required String filePath,
    required String name,
    String? description,
    Map<String, bool>? sensitiveKeys,
  }) async {
    final xcconfigService = XConfigService();
    final values = await xcconfigService.readXConfig(filePath);

    return createEnvironment(
      name: name,
      description: description,
      initialValues: values,
      sensitiveKeys: sensitiveKeys,
    );
  }

  /// Import environment from a file, automatically detecting the format
  /// Supported formats: .env, .properties, .xcconfig
  Future<Environment> importEnvironment({
    required String filePath,
    required String envName,
    String? description,
  }) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw FileNotFoundException('File does not exist');
    }

    final extension = path.extension(filePath).toLowerCase();
    switch (extension) {
      case '.env':
        return importFromEnv(
          filePath: filePath,
          name: envName,
          description: description,
        );
      case '.properties':
        return importFromProperties(
          filePath: filePath,
          name: envName,
          description: description,
        );
      case '.xcconfig':
        return importFromXcconfig(
          filePath: filePath,
          name: envName,
          description: description,
        );
      default:
        throw ValidationException(
            'Unsupported file format. Supported formats: .env, .xcconfig, .properties');
    }
  }

  /// Save an environment to disk
  ///
  /// This method:
  /// 1. Saves sensitive values using SecureStorageService
  /// 2. Saves non-sensitive values and metadata to JSON
  Future<void> saveEnvironment(Environment env) async {
    final envDir = getProjectEnvDir();
    await Directory(envDir).create(recursive: true);

    // Store sensitive values securely
    for (final key in env.sensitiveKeys.keys) {
      if (env.sensitiveKeys[key] == true && env.values.containsKey(key)) {
        final value = env.values[key]!;
        final stored = await _secureStorage.store(
          '${project.name}/${env.name}/$key',
          value,
        );
        if (!stored) {
          _logger.error('Failed to store sensitive value for key: $key');
          throw ValidationException('Failed to store sensitive value');
        }
      }
    }

    // Create a copy of values without sensitive data
    final safeValues = Map<String, String>.from(env.values);
    for (final key in env.sensitiveKeys.keys) {
      if (env.sensitiveKeys[key] == true) {
        safeValues[key] = '********';
      }
    }

    // Create environment type directory
    final sanitizedName = _sanitizeName(env.name);
    final envTypeDir = _getEnvTypeDir(sanitizedName);
    await Directory(envTypeDir).create(recursive: true);

    // Save environment metadata and non-sensitive values
    final envFile =
        File(path.join(envTypeDir, '${_sanitizeName(env.name)}.json'));
    final safeEnv = env.copyWith(
      values: safeValues,
      metadata: {
        ...env.metadata,
        'originalName': env.name,
      },
    );
    await envFile.writeAsString(
      jsonEncode(safeEnv.toJson()),
      flush: true,
    );
  }

  /// Load an environment from disk
  ///
  /// This method:
  /// 1. Loads environment metadata from JSON
  /// 2. Retrieves sensitive values from SecureStorageService
  Future<Environment?> loadEnvironment({
    required String name,
  }) async {
    final sanitizedName = _sanitizeName(name);
    final envTypeDir = _getEnvTypeDir(sanitizedName);
    final envFile = File(path.join(envTypeDir, '$sanitizedName.json'));

    if (!await envFile.exists()) {
      return null;
    }

    try {
      final json = jsonDecode(await envFile.readAsString());
      final env = Environment.fromJson(json as Map<String, dynamic>);

      // Load sensitive values
      final values = Map<String, String>.from(env.values);
      for (final key in env.sensitiveKeys.keys) {
        if (env.sensitiveKeys[key] == true) {
          final value = await _secureStorage.retrieve(
            '${project.name}/${env.name}/$key',
          );
          if (value != null) {
            values[key] = value;
          } else {
            _logger.error('Failed to retrieve sensitive value for key: $key');
          }
        }
      }

      return env.copyWith(
        values: values,
        metadata: {
          ...env.metadata,
          'sanitizedName': sanitizedName,
        },
      );
    } catch (e) {
      _logger.error('Failed to parse environment file: ${envFile.path}');
      return null;
    }
  }

  /// List all environments for a project
  Future<List<Environment>> listEnvironments() async {
    final envDir = getProjectEnvDir();
    final dir = Directory(envDir);

    if (!await dir.exists()) {
      return [];
    }

    final environments = <Environment>[];
    await for (final typeDir in dir.list()) {
      if (typeDir is Directory) {
        await for (final file in typeDir.list()) {
          if (file is File && file.path.endsWith('.json')) {
            try {
              final json = jsonDecode(await file.readAsString());
              final env = Environment.fromJson(json as Map<String, dynamic>);

              // Load sensitive values
              final values = Map<String, String>.from(env.values);
              for (final key in env.sensitiveKeys.keys) {
                if (env.sensitiveKeys[key] == true) {
                  final value = await _secureStorage.retrieve(
                    '${project.name}/${env.name}/$key',
                  );
                  if (value != null) {
                    values[key] = value;
                  }
                }
              }

              environments.add(env.copyWith(
                values: values,
                metadata: {
                  ...env.metadata,
                  'sanitizedName': _sanitizeName(env.name),
                },
              ));
            } catch (e) {
              _logger.error('Failed to parse environment file: ${file.path}');
              continue;
            }
          }
        }
      }
    }

    return environments;
  }

  /// Delete an environment
  ///
  /// This method:
  /// 1. Deletes the environment metadata file
  /// 2. Securely deletes any sensitive values
  Future<void> deleteEnvironment({
    required String name,
  }) async {
    final env = await loadEnvironment(
      name: name,
    );

    if (env == null) {
      throw ValidationException('Environment $name not found');
    }

    // Delete sensitive values
    for (final key in env.sensitiveKeys.keys) {
      if (env.sensitiveKeys[key] == true) {
        await _secureStorage.delete('${project.name}/${env.name}/$key');
      }
    }

    // Delete environment file
    final sanitizedName = _sanitizeName(name);
    final typeDir = Directory(_getEnvTypeDir(sanitizedName));
    final envFile = File(path.join(typeDir.path, '$sanitizedName.json'));

    if (await envFile.exists()) {
      await envFile.delete();
    }

    // Delete the type directory if it exists and is empty
    if (await typeDir.exists()) {
      final contents = await typeDir.list().toList();
      if (contents.isEmpty) {
        await typeDir.delete();
      }
    }

    // Update project's environment list
    if (project.environments.contains(name)) {
      await projectService.updateProject(
        project.copyWith(
          environments:
              project.environments.where((envName) => envName != name).toList(),
        ),
      );
    }
  }

  /// Set a value in an environment
  ///
  /// Returns the updated environment
  Future<Environment> setValue({
    required String key,
    required String value,
    required String envName,
    bool isSecret = false,
  }) async {
    final env = await loadEnvironment(
      name: envName,
    );

    if (env == null) {
      throw ValidationException('Environment $envName not found');
    }

    final values = Map<String, String>.from(env.values);
    values[key] = value;

    final sensitiveKeys = Map<String, bool>.from(env.sensitiveKeys);
    sensitiveKeys[key] = isSecret;

    final updatedEnv = env.copyWith(
      values: values,
      sensitiveKeys: sensitiveKeys,
      lastModified: DateTime.now(),
    );

    await saveEnvironment(updatedEnv);

    return updatedEnv;
  }

  /// Get a value from an environment
  Future<String?> getValue({
    required String key,
    required String envName,
  }) async {
    final env = await loadEnvironment(
      name: envName,
    );

    return env?.values[key];
  }
}
