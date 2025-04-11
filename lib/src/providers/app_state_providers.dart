import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:secure_env_core/secure_env_core.dart';
import 'package:secure_env_gui/src/providers/core_providers.dart';
import 'package:secure_env_gui/src/providers/project_provider.dart';
import 'package:secure_env_gui/src/providers/registry_watcher_provider.dart';
import 'package:secure_env_gui/src/services/logging_service.dart';

part 'app_state_providers.freezed.dart';
part 'app_state_providers.g.dart';

/// Union type for project states
@freezed
sealed class ProjectState with _$ProjectState {
  const factory ProjectState.initial() = ProjectStateInitial;

  const factory ProjectState.loading({
    @Default([]) List<Project> projects,
    Project? selectedProject,
  }) = ProjectStateLoading;
  const factory ProjectState.loaded({
    required List<Project> projects,
    Project? selectedProject,
  }) = ProjectStateLoaded;
  const factory ProjectState.error({
    required String message,
    List<Project>? projects,
    Project? selectedProject,
  }) = ProjectStateError;
}

/// Union type for environment states
@freezed
sealed class EnvironmentState with _$EnvironmentState {
  const factory EnvironmentState.initial() = EnvironmentStateInitial;
  const factory EnvironmentState.loading() = EnvironmentStateLoading;
  const factory EnvironmentState.loaded({
    required List<Environment> environments,
    String? selectedEnvironmentName,
    Environment? selectedEnvironment,
    @Default({}) Map<String, String> environmentValues,
    @Default(false) bool isEditing,
  }) = EnvironmentStateLoaded;
  const factory EnvironmentState.error({
    required String message,
    List<Environment>? environments,
    String? selectedEnvironmentName,
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
    state = const ProjectState.initial();
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
    return const ProjectState.initial();
  }

  Future<void> loadProjects() async {
    if (state is ProjectStateLoaded) {
      // ignore: no_leading_underscores_for_local_identifiers
      final _state = state as ProjectStateLoaded;
      state = ProjectState.loading(
        projects: _state.projects,
        selectedProject: _state.selectedProject,
      );
    } else {
      state = const ProjectState.loading();
    }
    try {
      final projectService = ref.read(projectServiceProvider);
      final projects = await projectService.listProjects();

      state = ProjectState.loaded(
        projects: projects,
        selectedProject: switch (state) {
          ProjectStateLoaded(:final selectedProject) => selectedProject,
          ProjectStateError(:final selectedProject) => selectedProject,
          _ => null,
        },
      );
      ref.read(loggerProvider).info('Projects loaded: ${projects.length}');
    } catch (e, stack) {
      state = ProjectState.error(
        message: 'Failed to load projects: $e',
        projects: switch (state) {
          ProjectStateLoaded(:final projects) => projects,
          ProjectStateError(:final projects) => projects,
          _ => [],
        },
        selectedProject: switch (state) {
          ProjectStateLoaded(:final selectedProject) => selectedProject,
          ProjectStateError(:final selectedProject) => selectedProject,
          _ => null,
        },
      );
      ref.read(loggerProvider).error('Failed to load projects: $e');
    }
  }

  void selectProject(Project project) {
    if (state is ProjectStateLoaded) {
      final loaded = state as ProjectStateLoaded;
      state = ProjectState.loaded(
        projects: loaded.projects,
        selectedProject: project,
      );
    } else if (state is ProjectStateError) {
      final error = state as ProjectStateError;
      if (error.projects != null) {
        state = ProjectState.error(
          message: error.message,
          projects: error.projects,
          selectedProject: project,
        );
      }
    }
  }
}

/// Provider for managing environments state
@riverpod
class EnvironmentsNotifier extends _$EnvironmentsNotifier {
  @override
  EnvironmentState build() {
    return const EnvironmentState.initial();
  }

  Future<void> loadEnvironments(String projectName) async {
    state = const EnvironmentState.loading();
    try {
      final project = switch (ref.read(projectsNotifierProvider)) {
        ProjectStateLoaded(:final selectedProject) => selectedProject,
        _ => null,
      };
      if (project == null) {
        throw Exception('No project selected');
      }

      final environmentService = ref.read(environmentServiceProvider(project));
      final environments = await environmentService.listEnvironments();
      state = EnvironmentState.loaded(
        environments: environments,
        selectedEnvironmentName: switch (state) {
          EnvironmentStateLoaded(:final selectedEnvironmentName) =>
            selectedEnvironmentName,
          EnvironmentStateError(:final selectedEnvironmentName) =>
            selectedEnvironmentName,
          _ => null,
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
    } catch (e, stack) {
      state = EnvironmentState.error(
        message: 'Failed to load environments: $e',
        environments: switch (state) {
          EnvironmentStateLoaded(:final environments) => environments,
          EnvironmentStateError(:final environments) => environments,
          _ => [],
        },
        selectedEnvironmentName: switch (state) {
          EnvironmentStateLoaded(:final selectedEnvironmentName) =>
            selectedEnvironmentName,
          EnvironmentStateError(:final selectedEnvironmentName) =>
            selectedEnvironmentName,
          _ => null,
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
      ref.read(loggerProvider).error('Failed to load environments: $e');
    }
  }

  Future<void> createEnvironment({
    required String name,
    String? description,
    Map<String, String>? values,
    Map<String, bool>? sensitiveKeys,
  }) async {
    state = const EnvironmentState.loading();
    try {
      final project = switch (ref.read(projectsNotifierProvider)) {
        ProjectStateLoaded(:final selectedProject) => selectedProject,
        _ => null,
      };
      if (project == null) {
        throw Exception('No project selected');
      }

      final environmentService = ref.read(environmentServiceProvider(project));

      final environment = await environmentService.createEnvironment(
        name: name,
        description: description,
        initialValues: values,
        sensitiveKeys: sensitiveKeys ?? {},
      );
      state = switch (state) {
        EnvironmentStateLoaded(
          :final environments,
          :final selectedEnvironmentName,
          :final selectedEnvironment,
          :final environmentValues,
          :final isEditing,
        ) =>
          EnvironmentState.loaded(
            environments: [...environments, environment],
            selectedEnvironmentName: selectedEnvironmentName,
            selectedEnvironment: selectedEnvironment,
            environmentValues: environmentValues,
            isEditing: isEditing,
          ),
        EnvironmentStateError(
          :final environments,
          :final selectedEnvironmentName,
          :final selectedEnvironment,
          :final environmentValues,
          :final isEditing,
        ) =>
          EnvironmentState.loaded(
            environments: [...(environments ?? []), environment],
            selectedEnvironmentName: selectedEnvironmentName,
            selectedEnvironment: selectedEnvironment,
            environmentValues: environmentValues ?? {},
            isEditing: isEditing ?? false,
          ),
        _ => EnvironmentState.loaded(environments: [environment]),
      };
    } catch (e, stack) {
      state = EnvironmentState.error(
        message: 'Failed to create environment: $e',
        environments: switch (state) {
          EnvironmentStateLoaded(:final environments) => environments,
          EnvironmentStateError(:final environments) => environments,
          _ => [],
        },
        selectedEnvironmentName: switch (state) {
          EnvironmentStateLoaded(:final selectedEnvironmentName) =>
            selectedEnvironmentName,
          EnvironmentStateError(:final selectedEnvironmentName) =>
            selectedEnvironmentName,
          _ => null,
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
      ref.read(loggerProvider).error('Failed to create environment: $e');
    }
  }

  Future<void> deleteEnvironment(String name, String projectName) async {
    state = const EnvironmentState.loading();
    try {
      final project = switch (ref.read(projectsNotifierProvider)) {
        ProjectStateLoaded(:final selectedProject) => selectedProject,
        _ => null,
      };
      if (project == null) {
        throw Exception('No project selected');
      }

      final environmentService = ref.read(environmentServiceProvider(project));
      await environmentService.deleteEnvironment(name: name);
      state = switch (state) {
        EnvironmentStateLoaded(
          :final environments,
          :final selectedEnvironmentName,
          :final selectedEnvironment,
          :final environmentValues,
          :final isEditing,
        ) =>
          EnvironmentState.loaded(
            environments: environments.where((e) => e.name != name).toList(),
            selectedEnvironmentName: selectedEnvironmentName == name
                ? null
                : selectedEnvironmentName,
            selectedEnvironment:
                selectedEnvironment?.name == name ? null : selectedEnvironment,
            environmentValues: environmentValues,
            isEditing: isEditing,
          ),
        EnvironmentStateError(
          :final environments,
          :final selectedEnvironmentName,
          :final selectedEnvironment,
          :final environmentValues,
          :final isEditing,
        ) =>
          EnvironmentState.loaded(
            environments:
                (environments ?? []).where((e) => e.name != name).toList(),
            selectedEnvironmentName: selectedEnvironmentName == name
                ? null
                : selectedEnvironmentName,
            selectedEnvironment:
                selectedEnvironment?.name == name ? null : selectedEnvironment,
            environmentValues: environmentValues ?? {},
            isEditing: isEditing ?? false,
          ),
        _ => const EnvironmentState.loaded(environments: []),
      };
    } catch (e, stack) {
      state = EnvironmentState.error(
        message: 'Failed to delete environment: $e',
        environments: switch (state) {
          EnvironmentStateLoaded(:final environments) => environments,
          EnvironmentStateError(:final environments) => environments,
          _ => [],
        },
        selectedEnvironmentName: switch (state) {
          EnvironmentStateLoaded(:final selectedEnvironmentName) =>
            selectedEnvironmentName,
          EnvironmentStateError(:final selectedEnvironmentName) =>
            selectedEnvironmentName,
          _ => null,
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
      ref.read(loggerProvider).error('Failed to delete environment: $e');
    }
  }

  void selectEnvironment(String name) {
    if (state is EnvironmentStateLoaded) {
      final loaded = state as EnvironmentStateLoaded;
      state = EnvironmentState.loaded(
        environments: loaded.environments,
        selectedEnvironmentName: name,
        selectedEnvironment: loaded.environments.firstWhere(
          (e) => e.name == name,
          orElse: () => throw Exception('Environment not found: $name'),
        ),
        environmentValues: Map<String, String>.from(
          loaded.environments
              .firstWhere(
                (e) => e.name == name,
                orElse: () => throw Exception('Environment not found: $name'),
              )
              .values,
        ),
        isEditing: loaded.isEditing,
      );
    } else if (state is EnvironmentStateError) {
      final error = state as EnvironmentStateError;
      if (error.environments != null) {
        state = EnvironmentState.error(
          message: error.message,
          environments: error.environments,
          selectedEnvironmentName: name,
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

  void updateEnvironmentValue(String key, String value) {}

  void removeEnvironmentValue(String key) {}

  void toggleEditing() {
    state = switch (state) {
      EnvironmentStateLoaded(
        :final environments,
        :final selectedEnvironmentName,
        :final selectedEnvironment,
        :final environmentValues,
        :final isEditing,
      ) =>
        EnvironmentState.loaded(
          environments: environments,
          selectedEnvironmentName: selectedEnvironmentName,
          selectedEnvironment: selectedEnvironment,
          environmentValues: environmentValues,
          isEditing: !isEditing,
        ),
      EnvironmentStateError(
        :final message,
        :final environments,
        :final selectedEnvironmentName,
        :final selectedEnvironment,
        :final environmentValues,
        :final isEditing,
      ) =>
        EnvironmentState.error(
          message: message,
          environments: environments,
          selectedEnvironmentName: selectedEnvironmentName,
          selectedEnvironment: selectedEnvironment,
          environmentValues: environmentValues,
          isEditing: !(isEditing ?? false),
        ),
      _ => state,
    };
  }
}
