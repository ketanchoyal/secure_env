import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:secure_env_core/secure_env_core.dart';
import 'package:secure_env_gui/src/providers/core_providers.dart';
import 'package:secure_env_gui/src/services/logging_service.dart';

part 'project_provider.freezed.dart';
part 'project_provider.g.dart';

/// Union type for project operation states
@freezed
sealed class ProjectOperationState with _$ProjectOperationState {
  const factory ProjectOperationState.idle() = ProjectOperationIdle;
  const factory ProjectOperationState.operating() = ProjectOperationInProgress;
  const factory ProjectOperationState.success() = ProjectOperationSuccess;
  const factory ProjectOperationState.error({
    required String message,
  }) = ProjectOperationError;
}

@Riverpod(keepAlive: true)
class ProjectOperations extends _$ProjectOperations {
  @override
  ProjectOperationState build() {
    return const ProjectOperationState.idle();
  }

  Future<void> createProject({
    required String name,
    required String path,
    String? description,
    Map<String, String>? metadata,
  }) async {
    state = const ProjectOperationState.operating();
    try {
      await ref.read(projectServiceProvider).createProject(
            name: name,
            path: path,
            description: description,
            metadata: metadata,
          );
      state = const ProjectOperationState.success();
    } catch (e, stack) {
      state = ProjectOperationState.error(
        message: 'Failed to create project: $e',
      );
      ref.read(loggerProvider).error('Failed to create project: $e');
    }
  }

  Future<void> deleteProject(String name, String path) async {
    state = const ProjectOperationState.operating();
    try {
      await ref.read(projectServiceProvider).deleteProject(name);
      state = const ProjectOperationState.success();
    } catch (e, stack) {
      state = ProjectOperationState.error(
        message: 'Failed to delete project: $e',
      );
      ref.read(loggerProvider).error('Failed to delete project: $e');
    }
  }

  Future<void> updateProject(Project project) async {
    state = const ProjectOperationState.operating();
    try {
      await ref.read(projectServiceProvider).updateProject(project);
      state = const ProjectOperationState.success();
    } catch (e, stack) {
      state = ProjectOperationState.error(
        message: 'Failed to update project: $e',
      );
      ref.read(loggerProvider).error('Failed to update project: $e');
    }
  }
}
