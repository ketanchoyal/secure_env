import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secure_env_core/secure_env_core.dart';
import 'package:secure_env_gui/src/providers/core_providers.dart';
import 'package:secure_env_gui/src/services/logging_service.dart';

part 'project_provider.freezed.dart';

/// Union type for project list states
@freezed
sealed class ProjectListState with _$ProjectListState {
  const factory ProjectListState.initial() = ProjectListStateInitial;
  const factory ProjectListState.loading() = ProjectListStateLoading;
  const factory ProjectListState.loaded({required List<Project> projects}) =
      ProjectListStateLoaded;
  const factory ProjectListState.error({
    required String message,
    List<Project>? projects,
  }) = ProjectListStateError;
}

final projectProvider =
    StateNotifierProvider<ProjectNotifier, ProjectListState>((ref) {
  return ProjectNotifier(ref);
});

class ProjectNotifier extends StateNotifier<ProjectListState> {
  ProjectNotifier(this.ref)
      : projectService = ref.read(projectServiceProvider),
        super(const ProjectListState.initial()) {
    loadProjects();
  }

  final Ref ref;
  final ProjectService projectService;

  Future<void> loadProjects() async {
    state = const ProjectListState.loading();
    try {
      final projects = await projectService.listProjects();
      state = ProjectListState.loaded(projects: projects);
    } catch (e, stack) {
      state = ProjectListState.error(
        message: 'Failed to load projects: $e',
        projects: switch (state) {
          ProjectListStateLoaded(:final projects) => projects,
          ProjectListStateError(:final projects) => projects,
          _ => [],
        },
      );
      ref.read(loggerProvider).error('Failed to load projects: $e');
    }
  }

  Future<void> createProject({
    required String name,
    required String path,
    String? description,
    Map<String, String>? metadata,
  }) async {
    state = const ProjectListState.loading();
    try {
      final project = await projectService.createProject(
        name: name,
        path: path,
        description: description,
        metadata: metadata,
      );
      state = switch (state) {
        ProjectListStateLoaded(:final projects) => ProjectListState.loaded(
            projects: [...projects, project],
          ),
        ProjectListStateError(:final projects) => ProjectListState.loaded(
            projects: [...(projects ?? []), project],
          ),
        _ => ProjectListState.loaded(projects: [project]),
      };
    } catch (e, stack) {
      state = ProjectListState.error(
        message: 'Failed to create project: $e',
        projects: switch (state) {
          ProjectListStateLoaded(:final projects) => projects,
          ProjectListStateError(:final projects) => projects,
          _ => [],
        },
      );
      ref.read(loggerProvider).error('Failed to create project: $e');
    }
  }

  Future<void> deleteProject(String name, String path) async {
    state = const ProjectListState.loading();
    try {
      await projectService.deleteProject(name);
      state = switch (state) {
        ProjectListStateLoaded(:final projects) => ProjectListState.loaded(
            projects: projects
                .where((p) => p.name != name || p.path != path)
                .toList(),
          ),
        ProjectListStateError(:final projects) => ProjectListState.loaded(
            projects: (projects ?? [])
                .where((p) => p.name != name || p.path != path)
                .toList(),
          ),
        _ => const ProjectListState.loaded(projects: []),
      };
    } catch (e, stack) {
      state = ProjectListState.error(
        message: 'Failed to delete project: $e',
        projects: switch (state) {
          ProjectListStateLoaded(:final projects) => projects,
          ProjectListStateError(:final projects) => projects,
          _ => [],
        },
      );
      ref.read(loggerProvider).error('Failed to delete project: $e');
    }
  }

  Future<void> updateProject(Project project) async {
    state = const ProjectListState.loading();
    try {
      final updatedProject = await projectService.updateProject(project);
      state = switch (state) {
        ProjectListStateLoaded(:final projects) => ProjectListState.loaded(
            projects: projects
                .map((p) => p.id == updatedProject.id ? updatedProject : p)
                .toList(),
          ),
        ProjectListStateError(:final projects) => ProjectListState.loaded(
            projects: (projects ?? [])
                .map((p) => p.id == updatedProject.id ? updatedProject : p)
                .toList(),
          ),
        _ => ProjectListState.loaded(projects: [updatedProject]),
      };
    } catch (e, stack) {
      state = ProjectListState.error(
        message: 'Failed to update project: $e',
        projects: switch (state) {
          ProjectListStateLoaded(:final projects) => projects,
          ProjectListStateError(:final projects) => projects,
          _ => [],
        },
      );
      ref.read(loggerProvider).error('Failed to update project: $e');
    }
  }
}
