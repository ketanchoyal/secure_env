import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:secure_env_core/secure_env_core.dart';
import 'package:secure_env_gui/src/providers/core_providers.dart';
import 'package:secure_env_gui/src/providers/app_state_providers.dart';
import 'package:secure_env_gui/src/providers/exception_for_providers.dart';
import 'package:secure_env_gui/src/services/logging_service.dart';

part 'environment_provider.freezed.dart';
part 'environment_provider.g.dart';

/// Union type for environment operation states
@freezed
sealed class EnvironmentOperationState with _$EnvironmentOperationState {
  const factory EnvironmentOperationState.idle() = EnvironmentOperationIdle;
  const factory EnvironmentOperationState.inProgress() =
      EnvironmentOperationInProgress;
  const factory EnvironmentOperationState.success() =
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
      checkForSpacesInName(name);
      await environmentService.createEnvironment(
        name: name,
        description: description,
        initialValues: values,
        sensitiveKeys: sensitiveKeys ?? {},
      );

      logger.info('Environment created successfully');

      state = const EnvironmentOperationState.success();
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

      state = const EnvironmentOperationState.success();
      logger.info('Environment deleted successfully');
    } on ExceptionForProviders catch (e) {
      state = EnvironmentOperationState.error(e.message);
      logger.error('Failed to import environment: $e', e.error, e.stackTrace);
    } catch (e) {
      state =
          EnvironmentOperationState.error('Failed to delete environment: $e');
      logger.error('Failed to delete environment: $e');
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
      checkForSpacesInName(name);
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
      state = const EnvironmentOperationState.success();
    } on ExceptionForProviders catch (e) {
      state = EnvironmentOperationState.error(e.message);
      logger.error('Failed to import environment: $e', e.error, e.stackTrace);
    } catch (e) {
      state =
          EnvironmentOperationState.error('An unexpected error occurred: $e');
      logger.error('An unexpected error occurred: $e');
    }
  }

  Future<void> updateEnvironment({
    required String name,
    required Map<String, String> values,
    required Map<String, bool> sensitiveKeys,
  }) async {
    state = const EnvironmentOperationState.inProgress();
    try {
      final existingEnvironment =
          await environmentService.loadEnvironment(name: name);
      if (existingEnvironment == null) {
        throw ExceptionForProviders(
            'Trying to update an environment that does not exist, something went wrong');
      }

      final updatedEnvironment = existingEnvironment.copyWith(
        values: values,
        sensitiveKeys: sensitiveKeys,
        lastModified: DateTime.now(),
      );

      await environmentService.saveEnvironment(updatedEnvironment);
      logger.info('Environment updated successfully');

      state = const EnvironmentOperationState.success();
    } on ExceptionForProviders catch (e) {
      state = EnvironmentOperationState.error(e.message);
      logger.error('Failed to import environment: $e', e.error, e.stackTrace);
    } catch (e) {
      state =
          EnvironmentOperationState.error('Failed to update environment: $e');
      logger.error('Failed to update environment: $e');
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
      logger.info('Environment removed successfully');
      state = const EnvironmentOperationState.success();
    } on ExceptionForProviders catch (e) {
      state = EnvironmentOperationState.error(e.message);
      logger.error('Failed to import environment: $e', e.error, e.stackTrace);
    } catch (e) {
      state = EnvironmentOperationState.error(
          'Failed to remove environment value: $e');
      logger.error('Failed to remove environment value: $e');
    }
  }

  void checkForSpacesInName(
    String name,
  ) {
    if (name.contains(' ')) {
      throw ExceptionForProviders('Environment name cannot contain spaces');
    }
  }
}
