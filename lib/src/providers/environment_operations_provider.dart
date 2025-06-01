import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:secure_env_core/secure_env_core.dart';
import 'dart:io'; // Added for File
import 'package:path/path.dart' as path; // Added for path.extension

import 'package:secure_env_gui/src/providers/core_providers.dart';
import 'package:secure_env_gui/src/providers/app_state_providers.dart';
import 'package:secure_env_gui/src/providers/exception_for_providers.dart';
import 'package:secure_env_gui/src/services/logging_service.dart';

part 'environment_operations_provider.freezed.dart';
part 'environment_operations_provider.g.dart';

/// Union type for environment operation states
@freezed
sealed class EnvironmentOperationState with _$EnvironmentOperationState {
  const factory EnvironmentOperationState.idle() = EnvironmentOperationIdle;
  const factory EnvironmentOperationState.inProgress([String? message]) =
      EnvironmentOperationInProgress;
  const factory EnvironmentOperationState.success(String message) =
      EnvironmentOperationSuccess;
  const factory EnvironmentOperationState.error(String message) =
      EnvironmentOperationError;
}

@Riverpod(keepAlive: true)
class EnvironmentOperations extends _$EnvironmentOperations {
  @override
  EnvironmentOperationState build() {
    return const EnvironmentOperationState.idle();
  }

  Logger get _logger => ref.read(loggerProvider(EnvironmentOperations));

  Project? get _project => ref.read(projectsNotifierProvider).selectedProject;

  EnvironmentService get _environmentService {
    if (_project == null) {
      throw ExceptionForProviders("Project Not found");
    }
    return ref.read(environmentServiceProvider(_project!));
  }

  Future<void> createEnvironment({
    required String name,
    String? description,
    Map<String, String>? values,
    Map<String, bool>? sensitiveKeys,
  }) async {
    state = const EnvironmentOperationState.inProgress();
    try {
      _checkForSpacesInName(name);
      await _environmentService.createEnvironment(
        name: name,
        description: description,
        initialValues: values,
        sensitiveKeys: sensitiveKeys ?? {},
      );

      _logger.info('Environment created successfully');

      state = const EnvironmentOperationState.success(
          'Environment created successfully');
    } on ExceptionForProviders catch (e) {
      state = EnvironmentOperationState.error(e.message);
      _logger.error('Failed to import environment: $e', e.error, e.stackTrace);
    } catch (e) {
      state =
          EnvironmentOperationState.error('Failed to create environment: $e');
      _logger.error('Failed to create environment: $e');
    }
  }

  Future<void> deleteEnvironment({
    required String name,
  }) async {
    state = const EnvironmentOperationState.inProgress();
    try {
      await _environmentService.deleteEnvironment(name: name);

      state = EnvironmentOperationState.success(
          'Environment $name deleted successfully');
      _logger.info('Environment $name deleted successfully');
    } on ExceptionForProviders catch (e) {
      state = EnvironmentOperationState.error(e.message);
      _logger.error('Failed to delete environment: $e', e.error, e.stackTrace);
    } catch (e, s) {
      state = EnvironmentOperationState.error('Failed to delete environment');
      _logger.error('Failed to delete environment: $e', e, s);
    }
  }

  Future<void> importEnvironment({
    required String projectId,
    required String filePath,
    required String name,
    String? description,
  }) async {
    state = const EnvironmentOperationState.inProgress();
    try {
      _checkForSpacesInName(name);
      late final EnvironmentService environmentService;
      if (projectId == _project!.id) {
        environmentService = _environmentService;
      } else {
        final project = ref
            .read(projectsNotifierProvider.notifier)
            .projectFromId(projectId);
        environmentService = ref.read(environmentServiceProvider(project!));
      }
      await environmentService.importEnvironment(
        filePath: filePath,
        envName: name,
        description: description,
      );
      _logger.info('Environment imported successfully');
      state = EnvironmentOperationState.success(
          'Environment $name imported successfully');
    } on ExceptionForProviders catch (e) {
      state = EnvironmentOperationState.error(e.message);
      _logger.error('Failed to import environment: $e', e.error, e.stackTrace);
    } catch (e, s) {
      state = EnvironmentOperationState.error('An unexpected error occurred');
      _logger.error('An unexpected error occurred: $e', e, s);
    }
  }

  Future<void> addVariableToAllEnvironment({
    required String key,
    required String value,
  }) async {
    state = const EnvironmentOperationState.inProgress();
    try {
      final allEnvironments = _project?.environments ?? [];
      for (final name in allEnvironments) {
        await _environmentService.setValue(
          key: key,
          value: value,
          envName: name,
        );
        _logger.info('Environment $name updated successfully');
      }

      state = EnvironmentOperationState.success(
          'All environments updated successfully');
    } on ExceptionForProviders catch (e) {
      state = EnvironmentOperationState.error(e.message);
      _logger.error(
          'Failed to update all environments: $e', e.error, e.stackTrace);
    } catch (e, s) {
      state =
          EnvironmentOperationState.error('Failed to update all environments');
      _logger.error('Failed to update all environments: $e', e, s);
    }
  }

  Future<void> addVariable({
    required String name,
    required String key,
    required String value,
  }) async {
    state = const EnvironmentOperationState.inProgress();
    try {
      await _environmentService.setValue(key: key, value: value, envName: name);
      _logger.info('Environment updated successfully');

      state = EnvironmentOperationState.success(
          'Environment $name updated successfully');
    } on ExceptionForProviders catch (e) {
      state = EnvironmentOperationState.error(e.message);
      _logger.error('Failed to update environment: $e', e.error, e.stackTrace);
    } catch (e, s) {
      state = EnvironmentOperationState.error('Failed to update environment');
      _logger.error('Failed to update environment: $e', e, s);
    }
  }

  Future<void> removeEnvironmentValue({
    required String envName,
    required String key,
  }) async {
    state = const EnvironmentOperationState.inProgress();
    try {
      await _environmentService.removeValue(
        envName: envName,
        key: key,
      );
      _logger.info('Environment $key from $envName removed successfully');
      state = EnvironmentOperationState.success(
          'Environment $key from $envName removed successfully');
    } on ExceptionForProviders catch (e) {
      state = EnvironmentOperationState.error(e.message);
      _logger.error(
          'Failed to remove environment value: $e', e.error, e.stackTrace);
    } catch (e) {
      state = EnvironmentOperationState.error(
          'Failed to remove environment value: $e');
      _logger.error('Failed to remove environment value: $e');
    }
  }

  /// Updates the export configuration for an environment and saves it.
  Future<void> updateExportConfig({
    required String name,
    required ExportConfig exportConfig,
  }) async {
    state = const EnvironmentOperationState.inProgress();
    try {
      final existingEnvironment =
          await _environmentService.loadEnvironment(name: name);
      if (existingEnvironment == null) {
        throw ExceptionForProviders('Environment not found');
      }
      final updatedEnvironment = existingEnvironment.copyWith(
        exportConfig: exportConfig,
        lastModified: DateTime.now(),
      );
      await _environmentService.saveEnvironment(updatedEnvironment);
      _logger.info('Export configuration saved successfully');
      state = EnvironmentOperationState.success(
          'Export configuration saved successfully');
    } on ExceptionForProviders catch (e) {
      state = EnvironmentOperationState.error(e.message);
      _logger.error('Failed to save export config: $e', e.error, e.stackTrace);
    } catch (e) {
      state =
          EnvironmentOperationState.error('Failed to save export config: $e');
      _logger.error('Failed to save export config: $e');
    }
  }

  // TODO: Remove encryption logic, does not make sense since we are going to store whole environment in a secured place

  Future<void> exportEnvironment({
    required String name,
  }) async {
    state = const EnvironmentOperationState.inProgress();
    try {
      final environment = await _environmentService.loadEnvironment(name: name);
      if (environment == null) {
        throw ExceptionForProviders(
            'Trying to update an environment that does not exist, something went wrong');
      }

      await ref.read(environmentExportServiceProvider(environment)).export();
      _logger.info('Environment exported successfully');
      state = EnvironmentOperationState.success(
          'Environment $name exported successfully');
    } on ExceptionForProviders catch (e) {
      state = EnvironmentOperationState.error(e.message);
      _logger.error('Failed to export environment: $e', e.error, e.stackTrace);
    } catch (e) {
      state =
          EnvironmentOperationState.error('Failed to export environment: $e');
      _logger.error('Failed to export environment: $e');
    }
  }

  void _checkForSpacesInName(
    String name,
  ) {
    if (name.contains(' ')) {
      throw ExceptionForProviders('Environment name cannot contain spaces');
    }
  }

  Future<void> syncEnvironmentFromFile({
    required String environmentName,
    required String filePath,
  }) async {
    state = EnvironmentOperationState.inProgress(
        'Syncing $environmentName from $filePath...');
    try {
      final existingEnvironment =
          await _environmentService.loadEnvironment(name: environmentName);
      if (existingEnvironment == null) {
        throw ExceptionForProviders(
            'Environment "$environmentName" not found for sync.');
      }

      final file = File(filePath);
      if (!await file.exists()) {
        throw ExceptionForProviders('File "$filePath" not found for sync.');
      }

      Map<String, String> newValues;
      final fileExtension = path.extension(filePath).toLowerCase();

      switch (fileExtension) {
        case '.env':
          newValues = await EnvService().readEnvFile(filePath);
          break;
        case '.properties':
          newValues = await PropertiesService().readPropertiesFile(filePath);
          break;
        case '.xcconfig':
          newValues = await XConfigService().readXConfig(filePath);
          break;
        default:
          throw ExceptionForProviders(
              'Unsupported file type for sync: $fileExtension. Supported: .env, .properties, .xcconfig');
      }

      // Basic merge: overwrite existing keys with new values, add new keys.
      // More sophisticated merge logic could be added here if needed (e.g., only update, don't add).
      final updatedValues = Map<String, String>.from(existingEnvironment.values)
        ..addAll(newValues);

      // Note: This simple sync does not update sensitiveKeys based on the file content.
      // A more advanced sync might try to infer this or provide options.

      final updatedEnvironment = existingEnvironment.copyWith(
        values: updatedValues,
        lastModified: DateTime.now(),
      );

      await _environmentService.saveEnvironment(updatedEnvironment);

      _logger.info(
          'Environment "$environmentName" synced successfully from "$filePath".');
      state = EnvironmentOperationState.success(
          'Environment "$environmentName" synced successfully.');
    } on ExceptionForProviders catch (e) {
      state = EnvironmentOperationState.error(e.message);
      _logger.error(
          'Failed to sync environment "$environmentName" from "$filePath": ${e.message}',
          e.error,
          e.stackTrace);
    } catch (e, stackTrace) {
      state = EnvironmentOperationState.error(
          'An unexpected error occurred while syncing environment "$environmentName" from "$filePath".');
      _logger.error(
          'Failed to sync environment "$environmentName" from "$filePath": $e',
          e,
          stackTrace);
    }
  }
}
