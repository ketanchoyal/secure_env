import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:secure_env_core/secure_env_core.dart';
import 'package:secure_env_gui/src/providers/core_providers.dart';
import 'package:secure_env_gui/src/providers/environment_provider.dart';
import 'package:secure_env_gui/src/providers/project_provider.dart';
import 'package:secure_env_gui/src/providers/registry_watcher_provider.dart';
import 'package:secure_env_gui/src/services/logging_service.dart';
import 'package:secure_env_gui/src/utils/extensions/iterable.dart';

part 'app_state_providers.freezed.dart';
part 'app_state_providers.g.dart';

enum NotifierState {
  initial,
  loading,
  loaded,
  error,
}

/// Union type for project states
@freezed
abstract class ProjectState with _$ProjectState {
  const ProjectState._();

  const factory ProjectState({
    @Default(NotifierState.initial) NotifierState state,
    @Default([]) List<Project> projects,
    Project? selectedProject,
    @Default(false) bool isEditing,
    String? errorMessage,
  }) = _ProjectState;

  factory ProjectState.initial() =>
      const ProjectState(state: NotifierState.initial);

  ProjectState loading({
    List<Project>? projects,
    Project? selectedProject,
  }) =>
      ProjectState(
        state: NotifierState.loading,
        projects: projects ?? this.projects,
        selectedProject: selectedProject ?? this.selectedProject,
        errorMessage: null,
        isEditing: false,
      );

  ProjectState loaded({
    required List<Project> projects,
    Project? selectedProject,
  }) {
    return ProjectState(
      state: NotifierState.loaded,
      projects: projects,
      selectedProject: selectedProject ?? this.selectedProject,
      errorMessage: null,
      isEditing: false,
    );
  }

  ProjectState error({
    required String message,
    List<Project>? projects,
    Project? selectedProject,
  }) {
    return ProjectState(
      state: NotifierState.error,
      projects: projects ?? this.projects,
      selectedProject: selectedProject ?? this.selectedProject,
      errorMessage: message,
      isEditing: false,
    );
  }

  when({
    required Function(ProjectState state) initial,
    required Function(ProjectState state) loading,
    required Function(ProjectState state) loaded,
    required Function(String message, ProjectState state) error,
  }) {
    return switch (state) {
      NotifierState.initial => initial(this),
      NotifierState.loading => loading(this),
      NotifierState.loaded => loaded(this),
      NotifierState.error => error(errorMessage ?? 'Unknown error', this),
    };
  }
}

/// Union type for environment states
@freezed
abstract class EnvironmentState with _$EnvironmentState {
  const EnvironmentState._();

  const factory EnvironmentState({
    @Default(NotifierState.initial) NotifierState state,
    @Default([]) List<Environment> environments,
    String? errorMessage,
  }) = _EnvironmentState;

  factory EnvironmentState.initial() =>
      const EnvironmentState(state: NotifierState.initial);

  EnvironmentState loading({
    List<Environment>? environments,
  }) =>
      EnvironmentState(
        state: NotifierState.loading,
        environments: environments ?? this.environments,
        errorMessage: null,
      );

  EnvironmentState loaded({
    required List<Environment> environments,
  }) =>
      EnvironmentState(
        state: NotifierState.loaded,
        environments: environments,
        errorMessage: null,
      );

  EnvironmentState error({
    required String message,
    List<Environment>? environments,
  }) =>
      EnvironmentState(
        state: NotifierState.error,
        environments: environments ?? this.environments,
        errorMessage: message,
      );
}

/// Provider for managing projects state
///
/// This provider is just for fetching projects and not for managing them.
/// For managing projects, use [ProjectNotifier].
@Riverpod(keepAlive: true)
class ProjectsNotifier extends _$ProjectsNotifier {
  @override
  ProjectState build() {
    state = ProjectState.initial();
    ref.listen(projectOperationsProvider, (previous, next) {
      if (next is ProjectOperationSuccess) {
        loadProjects();
      }
    });

    ref.listen(registryWatcherProvider, (previous, next) {
      if (next) {
        loadProjects();
      }
    });

    loadProjects();
    return state;
  }

  Project? get selectedProject {
    return state.selectedProject;
  }

  Logger get logger => ref.read(loggerProvider(ProjectsNotifier));

  Project? projectFromId(String id) {
    Project? project = state.projects.firstWhereOrNull((p) => p.id == id);
    if (project != null && project.status != ProjectStatus.markedForDeletion) {
      return project;
    }
    return null;
  }

  Future<void> loadProjects() async {
    state = state.loading();
    try {
      final projectService = ref.read(projectServiceProvider);
      final projects = await projectService.listProjects();

      state = state.loaded(projects: projects);
      logger.info('Projects loaded: ${projects.length}');
    } catch (e, stack) {
      state = state.error(
        message: 'Failed to load projects: $e',
      );
      logger.error('Failed to load projects: $e');
    }
  }

  void selectProject(String? projectId) {
    if (projectId == null) {
      state = state.loaded(projects: state.projects, selectedProject: null);
      return;
    }
    final project = projectFromId(projectId);
    state = state.loaded(projects: state.projects, selectedProject: project);

    if (project != null) {
      ref.read(environmentsNotifierProvider.notifier).loadEnvironments();
    }
  }
}

/// Provider for managing environments state
///
/// This provider is just for fetching environments and not for managing them.
/// For managing environments, use [EnvironmentNotifier].
@Riverpod(keepAlive: true, dependencies: [ProjectsNotifier])
class EnvironmentsNotifier extends _$EnvironmentsNotifier {
  String? get projectId =>
      ref.read(projectsNotifierProvider.notifier).selectedProject?.id;

  @override
  EnvironmentState build() {
    state = EnvironmentState.initial();
    ref.watch(projectsNotifierProvider.notifier).selectedProject;
    ref.listen(environmentOperationsProvider, (previous, next) {
      if (next is EnvironmentOperationSuccess) {
        logger.info('Environment operation success: Reloading environments');
        loadEnvironments();
      }
    });

    ref.listen(registryWatcherProvider, (previous, next) {
      if (next) {
        logger.info('Registry watcher triggered: Reloading environments');
        loadEnvironments();
      }
    });
    loadEnvironments();
    return state;
  }

  Logger get logger => ref.read(loggerProvider(EnvironmentsNotifier));

  Future<void> loadEnvironments() async {
    if (projectId == null) {
      return;
    }
    state = state.loading();
    try {
      final project = ref
          .watch(projectsNotifierProvider.notifier)
          .projectFromId(projectId!);

      final environmentService = ref.read(environmentServiceProvider(project!));
      final environments = await environmentService.listEnvironments();
      state = state.loaded(
        environments: environments,
      );
      logger.info('${environments.length} Environments loaded');
    } catch (e, stack) {
      state = state.error(
        message: 'Failed to load environments: $e',
      );
      logger.error('Failed to load environments: $e', e, stack);
    }
  }
}
