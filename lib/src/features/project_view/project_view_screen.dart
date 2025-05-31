import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:secure_env_core/secure_env_core.dart';
import 'package:secure_env_gui/src/features/project_view/widgets/modals/project_settings_modal.dart';
import 'package:secure_env_gui/src/features/shared_widgets/modals/create_environment_modal.dart';
import 'package:secure_env_gui/src/providers/app_state_providers.dart';
import 'package:secure_env_gui/src/features/shared_widgets/modals/import_environment_modal.dart';
import 'dart:async'; // For StreamSubscription

import 'package:secure_env_gui/src/features/project_view/widgets/environment_detail_view.dart';
import 'package:secure_env_gui/src/features/project_view/widgets/empty_state.dart';
import 'package:secure_env_gui/src/features/project_view/widgets/project_notification_button.dart';
import 'package:secure_env_gui/src/providers/environment_file_watcher_provider.dart'; // Added
import 'package:secure_env_gui/src/providers/environment_provider.dart';
import 'package:secure_env_gui/src/services/logging_service.dart'; // For logger

class ProjectViewScreen extends ConsumerStatefulWidget {
  final String projectId;
  final String? environmentName;

  const ProjectViewScreen(
      {super.key, required this.projectId, this.environmentName});

  @override
  ConsumerState<ProjectViewScreen> createState() => _ProjectViewScreenState();
}

class _ProjectViewScreenState extends ConsumerState<ProjectViewScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  List<Environment> _environments = [];
  StreamSubscription<FileWatchEventInfo>?
      _fileWatcherSubscription; // Updated type
  bool _showSyncButton = false;
  String? _changedFilePath; // To store the path of the changed file
  String?
      _changedEnvironmentName; // To store the name of the affected environment

  @override
  void initState() {
    super.initState();
  }

  void _setupFileWatcher() {
    _fileWatcherSubscription?.cancel(); // Cancel previous subscription
    // Watch the provider to get the stream.
    final stream = ref.watch(environmentFileWatcherProvider(
        widget.projectId)); // Stream type is now Stream<FileWatchEventInfo>
    _fileWatcherSubscription = stream.listen((eventInfo) {
      // eventInfo is FileWatchEventInfo
      if (mounted) {
        setState(() {
          _showSyncButton = true;
          _changedFilePath = eventInfo
              .watchedPath; // Store the specific path that was being watched
          _changedEnvironmentName =
              eventInfo.environment.name; // Store environment name
        });
        ref.read(loggerProvider(_ProjectViewScreenState)).info(
            'File system event received: ${eventInfo.toString()}. Showing Sync button.');
      }
    }, onError: (error, stackTrace) {
      if (mounted) {
        ref.read(loggerProvider(_ProjectViewScreenState)).error(
            'Error from environmentFileWatcherProvider stream: $error',
            error,
            stackTrace);
      }
    }, onDone: () {
      if (mounted) {
        ref
            .read(loggerProvider(_ProjectViewScreenState))
            .info('Environment file watcher stream closed.');
      }
    });
  }

  void _showImportEnvironmentModal(BuildContext context, WidgetRef ref) {
    final project = ref
        .watch(projectsNotifierProvider.notifier)
        .projectFromId(widget.projectId);
    if (project != null) {
      ImportEnvironmentModal.show(context, ref, selectedProject: project);
    }
  }

  void _showNewEnvironmentModal() {
    final project = ref
        .watch(projectsNotifierProvider.notifier)
        .projectFromId(widget.projectId);
    if (project != null) {
      CreateEnvironmentModal.show(
        context,
        ref,
        project.id,
      );
    }
  }

  @override
  void dispose() {
    _fileWatcherSubscription?.cancel();
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(projectsNotifierProvider.select((state) =>
        state.projects.where((p) => p.id == widget.projectId).first));
    // Watch the current project and environments
    final project = ref.watch(projectsNotifierProvider).selectedProject;

    final environmentState = ref.watch(environmentsNotifierProvider);

    final List<Environment> environments = environmentState.environments;

    // --- COMMON VARIABLES SECTION ---
    // Compute variables common to all environments
    Map<String, String> commonVariables = {};
    if (environments.isNotEmpty) {
      Set<String> allKeys = {};
      for (var env in environments) {
        allKeys.addAll(env.values.keys);
      }
      for (final key in allKeys) {
        final value = environments.first.values[key];
        final allSame = environments.every((env) => env.values[key] == value);
        if (allSame && value != null) {
          commonVariables[key] = value;
        }
      }
    }

    // Create a pseudo-environment for common variables if any
    List<Environment> displayEnvironments = List.from(environments);
    final bool hasCommonVariables = commonVariables.isNotEmpty;

    if (hasCommonVariables) {
      displayEnvironments.insert(
        0,
        Environment(
          createdAt: DateTime.now(),
          name: 'Common',
          description: 'Variables shared across all environments',
          values: commonVariables,
          sensitiveKeys: {},
        ),
      );
    }

    // Update TabController if environments changed
    if (_tabController == null ||
        displayEnvironments.length != _tabController!.length) {
      final oldIndex = _tabController?.index ?? 0;
      _tabController?.dispose();
      _tabController = TabController(
        length: displayEnvironments.length,
        vsync: this,
      );
      _setupFileWatcher();
      //Select the environment based on the environmentName parameter
      if (widget.environmentName != null) {
        final index = displayEnvironments
            .indexWhere((env) => env.name == widget.environmentName);
        if (index != -1) {
          _tabController!.index = index;
        }
      }
      // Optionally select last tab if added
      else if (displayEnvironments.length > _environments.length) {
        _tabController!.index = displayEnvironments.length - 1;
      } else if (oldIndex < displayEnvironments.length) {
        _tabController!.index = oldIndex;
      }
      _environments = List<Environment>.from(displayEnvironments);
    }

    if (project == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(project.name),
        actions: environments.isEmpty
            ? null
            : [
                if (_showSyncButton)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TextButton(
                      onPressed: () {
                        if (_changedFilePath != null &&
                            _changedEnvironmentName != null) {
                          ref.read(loggerProvider(_ProjectViewScreenState)).info(
                              'Sync Changes button pressed for env: $_changedEnvironmentName file: $_changedFilePath');

                          // Call the new sync method from EnvironmentOperations
                          ref
                              .read(environmentOperationsProvider.notifier)
                              .syncEnvironmentFromFile(
                                environmentName: _changedEnvironmentName!,
                                filePath: _changedFilePath!,
                              );

                          // Hide button after initiating sync
                          setState(() {
                            _showSyncButton = false;
                            _changedFilePath = null;
                            _changedEnvironmentName = null;
                          });
                        } else {
                          ref.read(loggerProvider(_ProjectViewScreenState)).warn(
                              'Sync Changes button pressed, but changed file path or environment name is null.');
                        }
                      },
                      child: const Text('Sync Changes'),
                      // Style as needed
                      // style: TextButton.styleFrom(
                      //   foregroundColor: Theme.of(context).appBarTheme.actionsIconTheme?.color ?? Theme.of(context).colorScheme.onPrimary,
                      // ),
                    ),
                  ),
                ProjectNotificationButton(projectId: widget.projectId),
                IconButton(
                  icon: const Icon(Icons.file_upload),
                  onPressed: () => _showImportEnvironmentModal(context, ref),
                ),
                IconButton(
                  icon: const Icon(FontAwesomeIcons.plus),
                  onPressed: _showNewEnvironmentModal,
                  tooltip: 'New Environment',
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  tooltip: 'Project Settings',
                  onPressed: () {
                    ProjectSettingsModal.show(context, ref);
                  },
                ),
              ],
      ),
      body: environments.isEmpty
          ? ProjectViewEmptyState(
              onCreate: _showNewEnvironmentModal,
              onImport: () => _showImportEnvironmentModal(context, ref),
            )
          : Column(
              children: [
                TabBar(
                  isScrollable: true,
                  controller: _tabController,
                  tabs: displayEnvironments.map((env) {
                    // Add a different style for the Common tab
                    return Tab(
                      icon:
                          env.name == 'Common' ? const Icon(Icons.share) : null,
                      text: env.name == 'Common' ? null : env.name,
                    );
                  }).toList(),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: displayEnvironments.map((env) {
                      return EnvironmentDetailView(
                        environment: env,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
    );
  }
}
