import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:secure_env_core/secure_env_core.dart';
import 'package:secure_env_gui/src/providers/app_state_providers.dart';
import 'package:secure_env_gui/src/providers/core_providers.dart';
import 'package:secure_env_gui/src/routing/app_snackbar.dart';
import 'package:secure_env_gui/src/services/logging_service.dart';

part 'project_provider.freezed.dart';
part 'project_provider.g.dart';

/// Union type for project operation states
@freezed
sealed class ProjectOperationState with _$ProjectOperationState {
  const factory ProjectOperationState.idle() = ProjectOperationIdle;
  const factory ProjectOperationState.inProgress([String? message]) =
      ProjectOperationInProgress;
  const factory ProjectOperationState.success(String message) =
      ProjectOperationSuccess;
  const factory ProjectOperationState.error(String message) =
      ProjectOperationError;
}

@Riverpod(keepAlive: true)
class ProjectOperations extends _$ProjectOperations {
  @override
  ProjectOperationState build() {
    listenSelf((previous, next) {
      if (next is ProjectOperationSuccess) {
        ref.read(snackbarProvider).showSnackbar(
              message: next.message,
              duration: const Duration(seconds: 2),
              action: null,
            );
      }
      if (next is ProjectOperationError) {
        ref.read(snackbarProvider).showSnackbar(
              message: next.message,
              duration: const Duration(seconds: 2),
              action: null,
            );
      }
      if (next is ProjectOperationInProgress && next.message != null) {
        ref.read(snackbarProvider).showSnackbar(
              message: next.message!,
              duration: const Duration(seconds: 2),
              action: null,
            );
      }
    });
    return const ProjectOperationState.idle();
  }

  // List<Project> get projects => ref.read(projectsNotifierProvider).projects;

  Logger get logger => ref.read(loggerProvider(ProjectOperations));

  Future<void> createProject({
    required String name,
    required String path,
    String? description,
    Map<String, String>? metadata,
  }) async {
    state = const ProjectOperationState.inProgress();
    try {
      await ref.read(projectServiceProvider).createProject(
            name: name,
            path: path,
            description: description,
            metadata: metadata,
          );

      logger.info('Project created successfully');
      state =
          ProjectOperationState.success("Project $name created successfully");
    } catch (e, stack) {
      state = ProjectOperationState.error(
        'Failed to create project',
      );
      logger.error('Failed to create project: $e', e, stack);
    }
  }

  Future<void> deleteProject(String path) async {
    state = const ProjectOperationState.inProgress();
    try {
      await ref.read(projectServiceProvider).deleteProject(path);
      logger.info('Project deleted successfully');
      state =
          const ProjectOperationState.success('Project deleted successfully');
    } catch (e, stack) {
      state = ProjectOperationState.error('Failed to delete project');
      logger.error('Failed to delete project: $e', e, stack);
    }
  }

  Future<void> renameProject(
    String id,
    String newName,
  ) async {
    state = const ProjectOperationState.inProgress();
    try {
      final project = await ref.read(projectServiceProvider).getProjectById(id);
      if (project == null) {
        throw ValidationException('Project with id "$id" not found');
      }

      await _updateProject(
        project.copyWith(name: newName),
      );
      logger.info('Project renamed successfully');
      state = const ProjectOperationState.success(
        'Project renamed successfully',
      );
    } catch (e, stack) {
      state = ProjectOperationState.error('Failed to rename project');
      logger.error('Failed to rename project: $e', e, stack);
    }
  }

  Future<void> _updateProject(Project project) async {
    await ref.read(projectServiceProvider).updateProject(project);
    logger.info('Project updated successfully');
  }

  Future<bool> updateProjectConfig(ProjectConfig config) async {
    state = const ProjectOperationState.inProgress();
    try {
      final project = ref.read(projectsNotifierProvider.notifier).selectedProject;
      if (project == null) {
        state = const ProjectOperationState.error('No project selected');
        return false;
      }
      await _updateProject(project.copyWith(config: config));
      logger.info('Project settings updated successfully');
      state = const ProjectOperationState.success('Project settings updated successfully');
      return true;
    } catch (e, stack) {
      state = const ProjectOperationState.error('Failed to save project settings');
      logger.error('Failed to save project settings: $e', e, stack);
      return false;
    }
  }
}
