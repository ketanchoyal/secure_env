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
  // const factory ProjectState.initial() = ProjectStateInitial;

  // const factory ProjectState.loading({
  //   @Default([]) List<Project> projects,
  //   Project? selectedProject,
  // }) = ProjectStateLoading;
  // const factory ProjectState.loaded({
  //   required List<Project> projects,
  //   Project? selectedProject,
  // }) = ProjectStateLoaded;
  // const factory ProjectState.error({
  //   required String message,
  //   List<Project>? projects,
  //   Project? selectedProject,
  // }) = ProjectStateError;

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
      projects: projects ?? [],
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
sealed class EnvironmentState with _$EnvironmentState {
  const factory EnvironmentState.initial() = EnvironmentStateInitial;
  const factory EnvironmentState.loading({
    @Default([]) List<Environment> environments,
    Environment? selectedEnvironment,
    @Default({}) Map<String, String> environmentValues,
    @Default(false) bool isEditing,
  }) = EnvironmentStateLoading;
  const factory EnvironmentState.loaded({
    required List<Environment> environments,
    Environment? selectedEnvironment,
    @Default({}) Map<String, String> environmentValues,
    @Default(false) bool isEditing,
  }) = EnvironmentStateLoaded;
  const factory EnvironmentState.error({
    required String message,
    List<Environment>? environments,
    Environment? selectedEnvironment,
    Map<String, String>? environmentValues,
    bool? isEditing,
  }) = EnvironmentStateError;
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
    // if (state is ProjectStateLoading) {
    //   //do nothing
    // } else if (state is ProjectStateLoaded) {
    //   // ignore: no_leading_underscores_for_local_identifiers
    //   final _state = state as ProjectStateLoaded;
    //   state = ProjectState.loading(
    //     projects: _state.projects,
    //     selectedProject: _state.selectedProject,
    //   );
    // } else if (state is ProjectStateError) {
    //   // ignore: no_leading_underscores_for_local_identifiers
    //   final _state = state as ProjectStateError;
    //   state = ProjectState.loading(
    //     projects: _state.projects ?? [],
    //     selectedProject: _state.selectedProject,
    //   );
    // }
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
    if (state is EnvironmentStateLoaded) {
      // ignore: no_leading_underscores_for_local_identifiers
      final _state = state as EnvironmentStateLoaded;
      state = EnvironmentState.loading(
        environments: _state.environments,
        selectedEnvironment: _state.selectedEnvironment,
        environmentValues: _state.environmentValues,
        isEditing: _state.isEditing,
      );
    } else {
      state = EnvironmentState.loading();
    }
    try {
      final project = ref
          .watch(projectsNotifierProvider.notifier)
          .projectFromId(projectId!);

      final environmentService = ref.read(environmentServiceProvider(project!));
      final environments = await environmentService.listEnvironments();
      state = EnvironmentState.loaded(
        environments: environments,
        selectedEnvironment: switch (state) {
          EnvironmentStateLoaded(:final selectedEnvironment) =>
            selectedEnvironment,
          EnvironmentStateError(:final selectedEnvironment) =>
            selectedEnvironment,
          _ => null,
        },
        environmentValues: switch (state) {
          EnvironmentStateLoaded(:final environmentValues) => environmentValues,
          EnvironmentStateError(:final environmentValues) =>
            environmentValues ?? {},
          _ => {},
        },
        isEditing: switch (state) {
          EnvironmentStateLoaded(:final isEditing) => isEditing,
          EnvironmentStateError(:final isEditing) => isEditing ?? false,
          _ => false,
        },
      );
      logger.info('${environments.length} Environments loaded');
    } catch (e, stack) {
      state = EnvironmentState.error(
        message: 'Failed to load environments: $e',
        environments: switch (state) {
          EnvironmentStateLoaded(:final environments) => environments,
          EnvironmentStateError(:final environments) => environments,
          _ => [],
        },
        selectedEnvironment: switch (state) {
          EnvironmentStateLoaded(:final selectedEnvironment) =>
            selectedEnvironment,
          EnvironmentStateError(:final selectedEnvironment) =>
            selectedEnvironment,
          _ => null,
        },
        environmentValues: switch (state) {
          EnvironmentStateLoaded(:final environmentValues) => environmentValues,
          EnvironmentStateError(:final environmentValues) => environmentValues,
          _ => {},
        },
        isEditing: switch (state) {
          EnvironmentStateLoaded(:final isEditing) => isEditing,
          EnvironmentStateError(:final isEditing) => isEditing,
          _ => false,
        },
      );
      logger.error('Failed to load environments: $e', e, stack);
    }
  }

  void selectEnvironment(String name) {
    if (state is EnvironmentStateLoaded) {
      final loaded = state as EnvironmentStateLoaded;
      final selectedEnvironment = loaded.environments.firstWhere(
        (e) => e.name == name,
        orElse: () => throw Exception('Environment not found: $name'),
      );
      state = EnvironmentState.loaded(
        environments: loaded.environments,
        selectedEnvironment: selectedEnvironment,
        environmentValues: Map<String, String>.from(selectedEnvironment.values),
        isEditing: loaded.isEditing,
      );
    } else if (state is EnvironmentStateError) {
      final error = state as EnvironmentStateError;
      if (error.environments != null) {
        state = EnvironmentState.error(
          message: error.message,
          environments: error.environments,
          selectedEnvironment: error.environments!.firstWhere(
            (e) => e.name == name,
            orElse: () => throw Exception('Environment not found: $name'),
          ),
          environmentValues: Map<String, String>.from(
            error.environments!
                .firstWhere(
                  (e) => e.name == name,
                  orElse: () => throw Exception('Environment not found: $name'),
                )
                .values,
          ),
          isEditing: error.isEditing,
        );
      }
    }
  }

  void toggleEditing() {
    state = switch (state) {
      EnvironmentStateLoaded(
        :final environments,
        :final selectedEnvironment,
        :final environmentValues,
        :final isEditing,
      ) =>
        EnvironmentState.loaded(
          environments: environments,
          selectedEnvironment: selectedEnvironment,
          environmentValues: environmentValues,
          isEditing: !isEditing,
        ),
      EnvironmentStateError(
        :final message,
        :final environments,
        :final selectedEnvironment,
        :final environmentValues,
        :final isEditing,
      ) =>
        EnvironmentState.error(
          message: message,
          environments: environments,
          selectedEnvironment: selectedEnvironment,
          environmentValues: environmentValues,
          isEditing: !(isEditing ?? false),
        ),
      _ => state,
    };
  }
}

// @Riverpod(keepAlive: true, dependencies: [currentProjectSelectorProvider])
// Project? currentProject(Ref ref) {
//   ref.watch(projectsNotifierProvider);
//   return null;
// }

// /// Provider for the current project based on projectId
// @Riverpod(keepAlive: true)
// void currentProjectSelector(Ref ref, String projectId) {
//   final projectState = ref.watch(projectsNotifierProvider);

//   final project = switch (projectState) {
//     ProjectStateLoaded(:final projects) => projects.firstWhere(
//         (p) => p.id == projectId,
//         orElse: () => throw Exception('Project not found'),
//       ),
//     _ => null,
//   };
//   currentProjectProvider.overrideWithValue(project);
// }

/// Provider for the current project's environments
// @riverpod
// List<Environment> currentProjectEnvironments(Ref ref, String projectId) {
//   final environmentState = ref.watch(environmentsNotifierProvider(projectId));

//   return switch (environmentState) {
//     EnvironmentStateInitial() => [],
//     EnvironmentStateLoaded(:final environments) => environments,
//     EnvironmentStateLoading(:final environments) => environments,
//     EnvironmentStateError(:final environments) => environments ?? [],
//   };
// }
