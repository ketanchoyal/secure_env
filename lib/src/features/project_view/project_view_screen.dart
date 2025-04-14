import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:secure_env_core/secure_env_core.dart';
import 'package:secure_env_gui/src/features/shared_widgets/modals/create_environment_modal.dart';
import 'package:secure_env_gui/src/providers/app_state_providers.dart';
import 'package:secure_env_gui/src/providers/environment_provider.dart';
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
    // Listen for environment operation state changes to show snackbars
    ref.listen<EnvironmentOperationState>(
      environmentOperationsProvider,
      (previous, next) {
        if (next is EnvironmentOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Environment operation successful')),
          );
        } else if (next is EnvironmentOperationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.message)),
          );
        }
      },
    );

    // Watch the current project and environments
    final project =
        ref.watch(projectsNotifierProvider.notifier).selectedProject;

    final environmentState = ref.watch(environmentsNotifierProvider);

    final List<Environment> environments = switch (environmentState) {
      EnvironmentStateInitial() => [],
      EnvironmentStateLoaded(:final environments) => environments,
      EnvironmentStateLoading(:final environments) => environments,
      EnvironmentStateError(:final environments) => environments ?? [],
    };

    // Update TabController if environments changed
    if (_tabController == null ||
        environments.length != _tabController!.length) {
      final oldIndex = _tabController?.index ?? 0;
      _tabController?.dispose();
      _tabController = TabController(
        length: environments.length,
        vsync: this,
      );
      // Optionally select last tab if added
      if (environments.length > _environments.length) {
        _tabController!.index = environments.length - 1;
      } else if (oldIndex < environments.length) {
        _tabController!.index = oldIndex;
      }
      _environments = List<Environment>.from(environments);
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
                  tabs: environments.map((env) => Tab(text: env.name)).toList(),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: environments.map((env) {
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
