import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:secure_env_core/secure_env_core.dart';
import 'package:secure_env_gui/src/providers/core_providers.dart';
import 'package:secure_env_gui/src/providers/env_sync_provider.dart';
import 'package:secure_env_gui/src/providers/environment_operations_provider.dart';
import 'package:secure_env_gui/src/providers/project_operations_provider.dart';
import 'package:secure_env_gui/src/providers/registry_watcher_provider.dart';
import 'package:secure_env_gui/src/routing/app_snackbar.dart';
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
    String? selectedProjectId,
    @Default(false) bool isEditing,
    String? errorMessage,
  }) = _ProjectState;

  Project? projectFromId(String id) {
    Project? project = projects.firstWhereOrNull((p) => p.id == id);
    if (project != null && project.status != ProjectStatus.markedForDeletion) {
      return project;
    }
    return null;
  }

  Project? get selectedProject {
    if (selectedProjectId == null) {
      return null;
    }
    return projectFromId(selectedProjectId!);
  }

  factory ProjectState.initial() =>
      const ProjectState(state: NotifierState.initial);

  ProjectState loading({
    List<Project>? projects,
    String? selectedProjectId,
  }) =>
      ProjectState(
        state: NotifierState.loading,
        projects: projects ?? this.projects,
        selectedProjectId: selectedProjectId ?? this.selectedProjectId,
        errorMessage: null,
        isEditing: false,
      );

  ProjectState loaded({
    required List<Project> projects,
    String? selectedProjectId,
  }) {
    return ProjectState(
      state: NotifierState.loaded,
      projects: projects,
      selectedProjectId: selectedProjectId,
      errorMessage: null,
      isEditing: false,
    );
  }

  ProjectState error({
    required String message,
    List<Project>? projects,
    String? selectedProjectId,
  }) {
    return ProjectState(
      state: NotifierState.error,
      projects: projects ?? this.projects,
      selectedProjectId: selectedProjectId ?? this.selectedProjectId,
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
    bool envChanged = false,
  }) =>
      EnvironmentState(
        state: NotifierState.loading,
        environments:
            envChanged ? environments ?? [] : environments ?? this.environments,
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

    ref.listen(registryWatcherProvider, (previous, next) {
      if (next) {
        loadProjects();
      }
    });

    loadProjects();
    return state;
  }

  Logger get _logger => ref.read(loggerProvider(ProjectsNotifier));

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
      final projects =
          await ref.read(projectOperationsProvider.notifier).getProjects();

      state = state.loaded(
        projects: projects,
        selectedProjectId: state.selectedProjectId,
      );
      _logger.info('Projects loaded: ${projects.length}');
    } catch (e, stack) {
      state = state.error(
        message: 'Failed to load projects: $e',
      );
      _logger.error('Failed to load projects: $e', e, stack);
    }
  }

  Project? _lastSelectedProject;

  void selectProject(String? projectId) {
    if (state.selectedProject != null) {
      _lastSelectedProject = state.selectedProject;
    }
    if (projectId == null) {
      state = state.loaded(projects: state.projects, selectedProjectId: null);
      return;
    }
    final project = projectFromId(projectId);
    state =
        state.loaded(projects: state.projects, selectedProjectId: projectId);

    if (project != null) {
      ref
          .read(environmentsNotifierProvider.notifier)
          .loadEnvironments(_lastSelectedProject != project);
    }
  }
}

/// Provider for managing environments state
///
/// This provider is just for fetching environments and not for managing them.
/// For managing environments, use [EnvironmentNotifier].
@Riverpod(keepAlive: true, dependencies: [ProjectsNotifier])
class EnvironmentsNotifier extends _$EnvironmentsNotifier {
  Project? get _project => ref.read(projectsNotifierProvider).selectedProject;

  @override
  EnvironmentState build() {
    state = EnvironmentState.initial();
    ref.listen(environmentOperationsProvider, (previous, next) async {
      if (next is EnvironmentOperationSuccess) {
        _logger.info('Environment operation success: Reloading environments');
        ref.read(snackbarProvider).showSnackbar(
              message: next.message,
              duration: const Duration(seconds: 2),
              action: null,
            );
        loadEnvironments();
        await ref.read(envSyncProvider.future);
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

    ref.listen(registryWatcherProvider, (previous, next) {
      if (next) {
        _logger.info('Registry watcher triggered: Reloading environments');
        loadEnvironments();
      }
    });
    loadEnvironments();
    return state;
  }

  Logger get _logger => ref.read(loggerProvider(EnvironmentsNotifier));

  Future<void> loadEnvironments([bool envChanged = false]) async {
    if (_project == null) {
      return;
    }
    state = state.loading(envChanged: envChanged);

    try {
      final environmentService =
          ref.read(environmentServiceProvider(_project!));
      final environments = await environmentService.listEnvironments();
      if (envChanged) {
        await Future.delayed(const Duration(milliseconds: 400));
      }
      state = state.loaded(
        environments: environments,
      );
      _logger.info('${environments.length} Environments loaded');
    } catch (e, stack) {
      state = state.error(
        message: 'Failed to load environments: $e',
      );
      _logger.error('Failed to load environments: $e', e, stack);
    }
  }
}
