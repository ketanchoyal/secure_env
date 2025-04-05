import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

import '../models/models.dart';
import 'services.dart';
import '../utils/logger.dart';
import '../utils/default_logger.dart';

/// Service for managing environments
class EnvironmentService {
  /// Base directory for storing environment data
  static const _baseDir = '.secure_env';

  final SecureStorageService _secureStorage;
  final Logger _logger;

  EnvironmentService({
    Logger? logger,
    SecureStorageService? secureStorage,
    EncryptionService? encryptionService,
  })  : _logger = logger ?? DefaultLogger(),
        _secureStorage = secureStorage ??
            SecureStorageService(
              encryptionService: encryptionService ?? EncryptionService()
                ..initialize('env-manager'),
              logger: logger ?? DefaultLogger(),
              storageDirectory: path.join(_baseDir, 'secrets'),
            );

  /// Get the path to the environments directory for a project
  String getProjectEnvDir(String projectName) {
    return path.join(_baseDir, projectName, 'environments');
  }

  /// Create a new environment
  Future<Environment> createEnvironment({
    required String name,
    required String projectName,
    String? description,
    Map<String, String>? initialValues,
  }) async {
    final env = Environment(
      name: name,
      projectName: projectName,
      description: description,
      values: initialValues ?? {},
      lastModified: DateTime.now(),
    );

    await saveEnvironment(env);
    return env;
  }

  /// Save an environment to disk
  ///
  /// This method:
  /// 1. Saves sensitive values using SecureStorageService
  /// 2. Saves non-sensitive values and metadata to JSON
  Future<void> saveEnvironment(Environment env) async {
    final envDir = getProjectEnvDir(env.projectName);
    await Directory(envDir).create(recursive: true);

    // Store sensitive values securely
    for (final key in env.sensitiveKeys.keys) {
      if (env.sensitiveKeys[key] == true && env.values.containsKey(key)) {
        final value = env.values[key]!;
        final stored = await _secureStorage.store(
          '${env.projectName}/${env.name}/$key',
          value,
        );
        if (!stored) {
          _logger.error('Failed to store sensitive value for key: $key');
          throw 'Failed to store sensitive value';
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

    // Save environment metadata and non-sensitive values
    final envFile = File(path.join(envDir, '${env.name}.json'));
    final safeEnv = env.copyWith(values: safeValues);
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
    required String projectName,
  }) async {
    final envDir = getProjectEnvDir(projectName);
    final envFile = File(path.join(envDir, '$name.json'));

    if (!await envFile.exists()) {
      return null;
    }

    final json = jsonDecode(await envFile.readAsString());
    final env = Environment.fromJson(json as Map<String, dynamic>);

    // Load sensitive values
    final values = Map<String, String>.from(env.values);
    for (final key in env.sensitiveKeys.keys) {
      if (env.sensitiveKeys[key] == true) {
        final value = await _secureStorage.retrieve(
          '$projectName/$name/$key',
        );
        if (value != null) {
          values[key] = value;
        } else {
          _logger.error('Failed to retrieve sensitive value for key: $key');
        }
      }
    }

    return env.copyWith(values: values);
  }

  /// List all environments for a project
  Future<List<Environment>> listEnvironments(String projectName) async {
    final envDir = getProjectEnvDir(projectName);
    final dir = Directory(envDir);

    if (!await dir.exists()) {
      return [];
    }

    final environments = <Environment>[];
    await for (final file in dir.list()) {
      if (file is File && file.path.endsWith('.json')) {
        final json = jsonDecode(await file.readAsString());
        environments.add(
          Environment.fromJson(json as Map<String, dynamic>),
        );
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
    required String projectName,
  }) async {
    final env = await loadEnvironment(
      name: name,
      projectName: projectName,
    );

    if (env == null) {
      _logger.error('Environment not found: $name');
      return;
    }

    // Delete sensitive values
    for (final key in env.sensitiveKeys.keys) {
      if (env.sensitiveKeys[key] == true) {
        final deleted = await _secureStorage.delete(
          '$projectName/$name/$key',
        );
        if (!deleted) {
          _logger.error('Failed to delete sensitive value for key: $key');
        }
      }
    }

    // Delete environment file
    final envDir = getProjectEnvDir(projectName);
    final envFile = File(path.join(envDir, '$name.json'));
    if (envFile.existsSync()) {
      await envFile.delete();
    }
  }

  /// Set a value in an environment
  ///
  /// Returns the updated environment
  Future<Environment> setValue({
    required String key,
    required String value,
    required String envName,
    required String projectName,
    bool isSecret = false,
  }) async {
    final env = await loadEnvironment(
      name: envName,
      projectName: projectName,
    );

    if (env == null) {
      throw 'Environment not found: $envName';
    }

    final updatedValues = Map<String, String>.from(env.values);
    updatedValues[key] = value;

    final updatedSensitiveKeys = Map<String, bool>.from(env.sensitiveKeys);
    updatedSensitiveKeys[key] = isSecret;

    final updatedEnv = env.copyWith(
      values: updatedValues,
      sensitiveKeys: updatedSensitiveKeys,
      lastModified: DateTime.now(),
    );

    await saveEnvironment(updatedEnv);
    return updatedEnv;
  }

  /// Get a value from an environment
  Future<String?> getValue({
    required String key,
    required String envName,
    required String projectName,
  }) async {
    final env = await loadEnvironment(
      name: envName,
      projectName: projectName,
    );

    return env?.values[key];
  }

  /// Import environment variables from a file
  Future<Environment> importEnvironment({
    required String filePath,
    required String envName,
    required String projectName,
    String? description,
  }) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw 'File not found: $filePath';
    }

    final content = await file.readAsString();
    final values = <String, String>{};

    if (filePath.endsWith('.env')) {
      // Parse .env file
      final lines = content.split('\n');
      for (final line in lines) {
        final trimmed = line.trim();
        if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
        final parts = trimmed.split('=');
        if (parts.length >= 2) {
          final key = parts[0].trim();
          final value = parts.sublist(1).join('=').trim();
          // Remove quotes (both single and double) from the start and end
          var unquoted = value;
          if ((value.startsWith('"') && value.endsWith('"')) ||
              (value.startsWith("'") && value.endsWith("'"))) {
            unquoted = value.substring(1, value.length - 1);
          }
          values[key] = unquoted;
        }
      }
    } else if (filePath.endsWith('.xcconfig')) {
      // Parse .xcconfig file
      final lines = content.split('\n');
      for (final line in lines) {
        final trimmed = line.trim();
        if (trimmed.isEmpty || trimmed.startsWith('//')) continue;
        final parts = trimmed.split('=');
        if (parts.length >= 2) {
          final key = parts[0].trim();
          final value = parts.sublist(1).join('=').trim();
          values[key] = value;
        }
      }
    } else if (filePath.endsWith('.properties')) {
      // Parse .properties file
      final lines = content.split('\n');
      for (final line in lines) {
        final trimmed = line.trim();
        if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
        final parts = trimmed.split('=');
        if (parts.length >= 2) {
          final key = parts[0].trim();
          final value = parts.sublist(1).join('=').trim();
          values[key] = value;
        }
      }
    } else {
      throw 'Unsupported file format. Supported formats: .env, .xcconfig, .properties';
    }

    return createEnvironment(
      name: envName,
      projectName: projectName,
      description: description,
      initialValues: values,
    );
  }
}
