import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:secure_env_core/secure_env_core.dart';
import 'package:secure_env_gui/src/providers/core_providers.dart';
import 'package:secure_env_gui/src/services/logging_service.dart';

part 'app_state_providers.freezed.dart';
part 'app_state_providers.g.dart';

/// Union type for project states
@freezed
sealed class ProjectState with _$ProjectState {
  const factory ProjectState.initial() = _Initial;
  const factory ProjectState.loading() = _Loading;
  const factory ProjectState.loaded({
    required List<Project> projects,
    String? selectedProjectName,
    Project? selectedProject,
  }) = _Loaded;
  const factory ProjectState.error({
    required String message,
    List<Project>? projects,
    String? selectedProjectName,
    Project? selectedProject,
  }) = _Error;
}

/// Union type for environment states
@freezed
sealed class EnvironmentState with _$EnvironmentState {
  const factory EnvironmentState.initial() = _EnvInitial;
  const factory EnvironmentState.loading() = _EnvLoading;
  const factory EnvironmentState.loaded({
    required List<Environment> environments,
    String? selectedEnvironmentName,
    Environment? selectedEnvironment,
    @Default({}) Map<String, String> environmentValues,
    @Default(false) bool isEditing,
  }) = _EnvLoaded;
  const factory EnvironmentState.error({
    required String message,
    List<Environment>? environments,
    String? selectedEnvironmentName,
    Environment? selectedEnvironment,
    Map<String, String>? environmentValues,
    bool? isEditing,
  }) = _EnvError;
}

/// Provider for managing projects state
@riverpod
class ProjectsNotifier extends _$ProjectsNotifier {
  @override
  ProjectState build() {
    return const ProjectState.initial();
  }

  Future<void> loadProjects() async {
    state = const ProjectState.loading();
    try {
      final projectService = ref.read(projectServiceProvider);
      final projects = await projectService.listProjects();
      final selectedProjectName = switch (state) {
        _Loaded(:final selectedProjectName) => selectedProjectName,
        _ => null,
      };
      state = ProjectState.loaded(
        projects: projects,
        selectedProjectName: selectedProjectName,
        selectedProject: switch (state) {
          _Loaded(:final selectedProject) => selectedProject,
          _Error(:final selectedProject) => selectedProject,
          _ => null,
        },
      );
    } catch (e, stack) {
      state = ProjectState.error(
        message: 'Failed to load projects: $e',
        projects: switch (state) {
          _Loaded(:final projects) => projects,
          _Error(:final projects) => projects,
          _ => [],
        },
        selectedProjectName: switch (state) {
          _Loaded(:final selectedProjectName) => selectedProjectName,
          _Error(:final selectedProjectName) => selectedProjectName,
          _ => null,
        },
        selectedProject: switch (state) {
          _Loaded(:final selectedProject) => selectedProject,
          _Error(:final selectedProject) => selectedProject,
          _ => null,
        },
      );
      ref.read(loggerProvider).error('Failed to load projects: $e');
    }
  }

  Future<void> createProject({
    required String name,
    required String path,
    String? description,
  }) async {
    state = const ProjectState.loading();
    try {
      final projectService = ref.read(projectServiceProvider);
      final project = await projectService.createProject(
        name: name,
        path: path,
        description: description,
      );
      state = switch (state) {
        _Loaded(
          :final projects,
          :final selectedProjectName,
          :final selectedProject,
        ) =>
          ProjectState.loaded(
            projects: [...projects, project],
            selectedProjectName: selectedProjectName,
            selectedProject: selectedProject,
          ),
        _Error(
          :final projects,
          :final selectedProjectName,
          :final selectedProject,
        ) =>
          ProjectState.loaded(
            projects: [...(projects ?? []), project],
            selectedProjectName: selectedProjectName,
            selectedProject: selectedProject,
          ),
        _ => ProjectState.loaded(projects: [project]),
      };
    } catch (e, stack) {
      state = ProjectState.error(
        message: 'Failed to create project: $e',
        projects: switch (state) {
          _Loaded(:final projects) => projects,
          _Error(:final projects) => projects,
          _ => [],
        },
        selectedProjectName: switch (state) {
          _Loaded(:final selectedProjectName) => selectedProjectName,
          _Error(:final selectedProjectName) => selectedProjectName,
          _ => null,
        },
        selectedProject: switch (state) {
          _Loaded(:final selectedProject) => selectedProject,
          _Error(:final selectedProject) => selectedProject,
          _ => null,
        },
      );
      ref.read(loggerProvider).error('Failed to create project: $e');
    }
  }

  Future<void> deleteProject(String name) async {
    state = const ProjectState.loading();
    try {
      final projectService = ref.read(projectServiceProvider);
      await projectService.deleteProject(name);
      state = switch (state) {
        _Loaded(
          :final projects,
          :final selectedProjectName,
          :final selectedProject,
        ) =>
          ProjectState.loaded(
            projects: projects.where((p) => p.name != name).toList(),
            selectedProjectName:
                selectedProjectName == name ? null : selectedProjectName,
            selectedProject:
                selectedProject?.name == name ? null : selectedProject,
          ),
        _Error(
          :final projects,
          :final selectedProjectName,
          :final selectedProject,
        ) =>
          ProjectState.loaded(
            projects: (projects ?? []).where((p) => p.name != name).toList(),
            selectedProjectName:
                selectedProjectName == name ? null : selectedProjectName,
            selectedProject:
                selectedProject?.name == name ? null : selectedProject,
          ),
        _ => const ProjectState.loaded(projects: []),
      };
    } catch (e, stack) {
      state = ProjectState.error(
        message: 'Failed to delete project: $e',
        projects: switch (state) {
          _Loaded(:final projects) => projects,
          _Error(:final projects) => projects,
          _ => [],
        },
        selectedProjectName: switch (state) {
          _Loaded(:final selectedProjectName) => selectedProjectName,
          _Error(:final selectedProjectName) => selectedProjectName,
          _ => null,
        },
        selectedProject: switch (state) {
          _Loaded(:final selectedProject) => selectedProject,
          _Error(:final selectedProject) => selectedProject,
          _ => null,
        },
      );
      ref.read(loggerProvider).error('Failed to delete project: $e');
    }
  }

  void selectProject(String name) {
    if (state is _Loaded) {
      final loaded = state as _Loaded;
      state = ProjectState.loaded(
        projects: loaded.projects,
        selectedProjectName: name,
        selectedProject: loaded.projects.firstWhere(
          (p) => p.name == name,
          orElse: () => throw Exception('Project not found: $name'),
        ),
      );
    } else if (state is _Error) {
      final error = state as _Error;
      if (error.projects != null) {
        state = ProjectState.error(
          message: error.message,
          projects: error.projects,
          selectedProjectName: name,
          selectedProject: error.projects!.firstWhere(
            (p) => p.name == name,
            orElse: () => throw Exception('Project not found: $name'),
          ),
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
        _Loaded(:final selectedProject) => selectedProject,
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
          _EnvLoaded(:final selectedEnvironmentName) => selectedEnvironmentName,
          _EnvError(:final selectedEnvironmentName) => selectedEnvironmentName,
          _ => null,
        },
        selectedEnvironment: switch (state) {
          _EnvLoaded(:final selectedEnvironment) => selectedEnvironment,
          _EnvError(:final selectedEnvironment) => selectedEnvironment,
          _ => null,
        },
        environmentValues: switch (state) {
          _EnvLoaded(:final environmentValues) => environmentValues,
          _EnvError(:final environmentValues) => environmentValues ?? {},
          _ => {},
        },
        isEditing: switch (state) {
          _EnvLoaded(:final isEditing) => isEditing,
          _EnvError(:final isEditing) => isEditing ?? false,
          _ => false,
        },
      );
    } catch (e, stack) {
      state = EnvironmentState.error(
        message: 'Failed to load environments: $e',
        environments: switch (state) {
          _EnvLoaded(:final environments) => environments,
          _EnvError(:final environments) => environments,
          _ => [],
        },
        selectedEnvironmentName: switch (state) {
          _EnvLoaded(:final selectedEnvironmentName) => selectedEnvironmentName,
          _EnvError(:final selectedEnvironmentName) => selectedEnvironmentName,
          _ => null,
        },
        selectedEnvironment: switch (state) {
          _EnvLoaded(:final selectedEnvironment) => selectedEnvironment,
          _EnvError(:final selectedEnvironment) => selectedEnvironment,
          _ => null,
        },
        environmentValues: switch (state) {
          _EnvLoaded(:final environmentValues) => environmentValues,
          _EnvError(:final environmentValues) => environmentValues,
          _ => {},
        },
        isEditing: switch (state) {
          _EnvLoaded(:final isEditing) => isEditing,
          _EnvError(:final isEditing) => isEditing,
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
        _Loaded(:final selectedProject) => selectedProject,
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
        _EnvLoaded(
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
        _EnvError(
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
          _EnvLoaded(:final environments) => environments,
          _EnvError(:final environments) => environments,
          _ => [],
        },
        selectedEnvironmentName: switch (state) {
          _EnvLoaded(:final selectedEnvironmentName) => selectedEnvironmentName,
          _EnvError(:final selectedEnvironmentName) => selectedEnvironmentName,
          _ => null,
        },
        selectedEnvironment: switch (state) {
          _EnvLoaded(:final selectedEnvironment) => selectedEnvironment,
          _EnvError(:final selectedEnvironment) => selectedEnvironment,
          _ => null,
        },
        environmentValues: switch (state) {
          _EnvLoaded(:final environmentValues) => environmentValues,
          _EnvError(:final environmentValues) => environmentValues,
          _ => {},
        },
        isEditing: switch (state) {
          _EnvLoaded(:final isEditing) => isEditing,
          _EnvError(:final isEditing) => isEditing,
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
        _Loaded(:final selectedProject) => selectedProject,
        _ => null,
      };
      if (project == null) {
        throw Exception('No project selected');
      }

      final environmentService = ref.read(environmentServiceProvider(project));
      await environmentService.deleteEnvironment(name: name);
      state = switch (state) {
        _EnvLoaded(
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
        _EnvError(
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
          _EnvLoaded(:final environments) => environments,
          _EnvError(:final environments) => environments,
          _ => [],
        },
        selectedEnvironmentName: switch (state) {
          _EnvLoaded(:final selectedEnvironmentName) => selectedEnvironmentName,
          _EnvError(:final selectedEnvironmentName) => selectedEnvironmentName,
          _ => null,
        },
        selectedEnvironment: switch (state) {
          _EnvLoaded(:final selectedEnvironment) => selectedEnvironment,
          _EnvError(:final selectedEnvironment) => selectedEnvironment,
          _ => null,
        },
        environmentValues: switch (state) {
          _EnvLoaded(:final environmentValues) => environmentValues,
          _EnvError(:final environmentValues) => environmentValues,
          _ => {},
        },
        isEditing: switch (state) {
          _EnvLoaded(:final isEditing) => isEditing,
          _EnvError(:final isEditing) => isEditing,
          _ => false,
        },
      );
      ref.read(loggerProvider).error('Failed to delete environment: $e');
    }
  }

  void selectEnvironment(String name) {
    if (state is _EnvLoaded) {
      final loaded = state as _EnvLoaded;
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
    } else if (state is _EnvError) {
      final error = state as _EnvError;
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
      _EnvLoaded(
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
      _EnvError(
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
