import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:secure_env_core/secure_env_core.dart';
import 'package:secure_env_gui/src/providers/core_providers.dart';
import 'package:secure_env_gui/src/providers/app_state_providers.dart';
import 'package:secure_env_gui/src/providers/exception_for_providers.dart';
import 'package:secure_env_gui/src/routing/app_snackbar.dart';
import 'package:secure_env_gui/src/services/logging_service.dart';

part 'environment_provider.freezed.dart';
part 'environment_provider.g.dart';

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
    listenSelf((previous, next) {
      if (next is EnvironmentOperationSuccess) {
        ref.read(snackbarProvider).showSnackbar(
              message: next.message,
              duration: const Duration(seconds: 2),
              action: null,
            );
      }
      if (next is EnvironmentOperationError) {
        ref.read(snackbarProvider).showSnackbar(
              message: next.message,
              duration: const Duration(seconds: 2),
              action: null,
            );
      }
      if (next is EnvironmentOperationInProgress && next.message != null) {
        ref.read(snackbarProvider).showSnackbar(
              message: next.message!,
              duration: const Duration(seconds: 2),
              action: null,
            );
      }
    });
    return const EnvironmentOperationState.idle();
  }

  Logger get logger => ref.read(loggerProvider(EnvironmentOperations));

  Project? get project =>
      ref.read(projectsNotifierProvider.notifier).selectedProject;

  EnvironmentService get environmentService {
    if (project == null) {
      throw ExceptionForProviders("Project Not found");
    }
    return ref.read(environmentServiceProvider(project!));
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
      await environmentService.createEnvironment(
        name: name,
        description: description,
        initialValues: values,
        sensitiveKeys: sensitiveKeys ?? {},
      );

      logger.info('Environment created successfully');

      state = const EnvironmentOperationState.success(
          'Environment created successfully');
    } on ExceptionForProviders catch (e) {
      state = EnvironmentOperationState.error(e.message);
      logger.error('Failed to import environment: $e', e.error, e.stackTrace);
    } catch (e) {
      state =
          EnvironmentOperationState.error('Failed to create environment: $e');
      logger.error('Failed to create environment: $e');
    }
  }

  Future<void> deleteEnvironment({
    required String name,
  }) async {
    state = const EnvironmentOperationState.inProgress();
    try {
      await environmentService.deleteEnvironment(name: name);

      state = EnvironmentOperationState.success(
          'Environment $name deleted successfully');
      logger.info('Environment $name deleted successfully');
    } on ExceptionForProviders catch (e) {
      state = EnvironmentOperationState.error(e.message);
      logger.error('Failed to delete environment: $e', e.error, e.stackTrace);
    } catch (e, s) {
      state = EnvironmentOperationState.error('Failed to delete environment');
      logger.error('Failed to delete environment: $e', e, s);
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
      if (projectId == project!.id) {
        environmentService = this.environmentService;
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
      logger.info('Environment imported successfully');
      state = EnvironmentOperationState.success(
          'Environment $name imported successfully');
    } on ExceptionForProviders catch (e) {
      state = EnvironmentOperationState.error(e.message);
      logger.error('Failed to import environment: $e', e.error, e.stackTrace);
    } catch (e, s) {
      state = EnvironmentOperationState.error('An unexpected error occurred');
      logger.error('An unexpected error occurred: $e', e, s);
    }
  }

  Future<void> addVariableToAllEnvironment({
    required String key,
    required String value,
  }) async {
    state = const EnvironmentOperationState.inProgress();
    try {
      final allEnvironments = project?.environments ?? [];
      for (final name in allEnvironments) {
        await environmentService.setValue(
          key: key,
          value: value,
          envName: name,
        );
        logger.info('Environment $name updated successfully');
      }

      state = EnvironmentOperationState.success(
          'All environments updated successfully');
    } on ExceptionForProviders catch (e) {
      state = EnvironmentOperationState.error(e.message);
      logger.error(
          'Failed to update all environments: $e', e.error, e.stackTrace);
    } catch (e, s) {
      state =
          EnvironmentOperationState.error('Failed to update all environments');
      logger.error('Failed to update all environments: $e', e, s);
    }
  }

  Future<void> addVariable({
    required String name,
    required String key,
    required String value,
  }) async {
    state = const EnvironmentOperationState.inProgress();
    try {
      await environmentService.setValue(key: key, value: value, envName: name);
      logger.info('Environment updated successfully');

      state = EnvironmentOperationState.success(
          'Environment $name updated successfully');
    } on ExceptionForProviders catch (e) {
      state = EnvironmentOperationState.error(e.message);
      logger.error('Failed to update environment: $e', e.error, e.stackTrace);
    } catch (e, s) {
      state = EnvironmentOperationState.error('Failed to update environment');
      logger.error('Failed to update environment: $e', e, s);
    }
  }

  Future<void> removeEnvironmentValue({
    required String envName,
    required String key,
  }) async {
    state = const EnvironmentOperationState.inProgress();
    try {
      await environmentService.removeValue(
        envName: envName,
        key: key,
      );
      logger.info('Environment $key from $envName removed successfully');
      state = EnvironmentOperationState.success(
          'Environment $key from $envName removed successfully');
    } on ExceptionForProviders catch (e) {
      state = EnvironmentOperationState.error(e.message);
      logger.error(
          'Failed to remove environment value: $e', e.error, e.stackTrace);
    } catch (e) {
      state = EnvironmentOperationState.error(
          'Failed to remove environment value: $e');
      logger.error('Failed to remove environment value: $e');
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
          await environmentService.loadEnvironment(name: name);
      if (existingEnvironment == null) {
        throw ExceptionForProviders('Environment not found');
      }
      final updatedEnvironment = existingEnvironment.copyWith(
        exportConfig: exportConfig,
        lastModified: DateTime.now(),
      );
      await environmentService.saveEnvironment(updatedEnvironment);
      logger.info('Export configuration saved successfully');
      state = EnvironmentOperationState.success(
          'Export configuration saved successfully');
    } on ExceptionForProviders catch (e) {
      state = EnvironmentOperationState.error(e.message);
      logger.error('Failed to save export config: $e', e.error, e.stackTrace);
    } catch (e) {
      state =
          EnvironmentOperationState.error('Failed to save export config: $e');
      logger.error('Failed to save export config: $e');
    }
  }

  // TODO: Remove encryption logic, does not make sense since we are going to store whole environment in a secured place

  Future<void> exportEnvironment({
    required String name,
  }) async {
    state = const EnvironmentOperationState.inProgress();
    try {
      final environment = await environmentService.loadEnvironment(name: name);
      if (environment == null) {
        throw ExceptionForProviders(
            'Trying to update an environment that does not exist, something went wrong');
      }

      await ref.read(environmentExportServiceProvider(environment)).export();
      logger.info('Environment exported successfully');
      state = EnvironmentOperationState.success(
          'Environment $name exported successfully');
    } on ExceptionForProviders catch (e) {
      state = EnvironmentOperationState.error(e.message);
      logger.error('Failed to export environment: $e', e.error, e.stackTrace);
    } catch (e) {
      state =
          EnvironmentOperationState.error('Failed to export environment: $e');
      logger.error('Failed to export environment: $e');
    }
  }

  void _checkForSpacesInName(
    String name,
  ) {
    if (name.contains(' ')) {
      throw ExceptionForProviders('Environment name cannot contain spaces');
    }
  }
}
