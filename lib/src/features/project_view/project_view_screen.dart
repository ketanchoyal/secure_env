import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:secure_env_core/secure_env_core.dart';
import 'package:secure_env_gui/src/features/shared_widgets/modals/create_environment_modal.dart';
import 'package:secure_env_gui/src/providers/app_state_providers.dart';
import 'package:secure_env_gui/src/features/shared_widgets/modals/import_environment_modal.dart';

import 'widgets/environment_detail_view.dart';
import 'widgets/empty_state.dart';

class ProjectViewScreen extends ConsumerStatefulWidget {
  final String projectId;

  const ProjectViewScreen({super.key, required this.projectId});

  @override
  ConsumerState<ProjectViewScreen> createState() => _ProjectViewScreenState();
}

class _ProjectViewScreenState extends ConsumerState<ProjectViewScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  List<Environment> _environments = [];

  @override
  void initState() {
    super.initState();
    // Removed ref.listen from initState. Use it in build instead, as per Riverpod docs.
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
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the current project and environments
    final project =
        ref.watch(projectsNotifierProvider.notifier).selectedProject;

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
      // Optionally select last tab if added
      if (displayEnvironments.length > _environments.length) {
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
                IconButton(
                  icon: const Icon(Icons.file_upload),
                  onPressed: () => _showImportEnvironmentModal(context, ref),
                ),
                IconButton(
                  icon: const Icon(FontAwesomeIcons.plus),
                  onPressed: _showNewEnvironmentModal,
                  tooltip: 'New Environment',
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
                  controller: _tabController,
                  tabs: displayEnvironments.map((env) {
                    // Add a different style for the Common tab
                    return Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (env.name == 'Common')
                            Padding(
                              padding: const EdgeInsets.only(right: 6.0),
                              child: Icon(
                                Icons.share,
                                size: 16,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          Text(
                            env.name,
                            style: env.name == 'Common'
                                ? TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  )
                                : null,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: displayEnvironments.map((env) {
                      // Pass all real environments (excluding Common) to the detail view
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
