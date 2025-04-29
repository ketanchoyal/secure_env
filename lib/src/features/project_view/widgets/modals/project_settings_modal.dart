import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secure_env_core/secure_env_core.dart';
import 'package:secure_env_gui/src/features/shared_widgets/modals/wolt_modal_scaffold.dart';
import 'package:secure_env_gui/src/providers/app_state_providers.dart';
import 'package:secure_env_gui/src/providers/project_provider.dart';

/// Modal widget for configuring project-level settings.
class ProjectSettingsModal extends ConsumerStatefulWidget {
  final ProjectConfig initialConfig;

  const ProjectSettingsModal({super.key, required this.initialConfig});

  /// Shows the project settings modal and handles saving the config.
  static void show(BuildContext context, WidgetRef ref) {
    final modalKey = GlobalKey<ProjectSettingsModalState>();
    final project = ref.read(projectsNotifierProvider.notifier).selectedProject;
    if (project == null) return;
    final modalContent = ProjectSettingsModal(
      key: modalKey,
      initialConfig: project.config,
    );
    showAppModalSheet(
      context: context,
      ref: ref,
      title: 'Project Settings',
      pageContent: modalContent,
      onPrimaryAction: () async {
        final state = modalKey.currentState;
        if (state == null) return false;
        final newConfig = ProjectConfig(
          autoSync: state.autoSync,
          conflictPolicy: state.conflictPolicy,
        );
        return await ref
            .read(projectOperationsProvider.notifier)
            .updateProjectConfig(newConfig);
      },
      primaryActionText: 'Save',
    );
  }

  @override
  ProjectSettingsModalState createState() => ProjectSettingsModalState();
}

class ProjectSettingsModalState extends ConsumerState<ProjectSettingsModal> {
  late bool autoSync;
  late ConflictPolicy conflictPolicy;

  @override
  void initState() {
    super.initState();
    autoSync = widget.initialConfig.autoSync;
    conflictPolicy = widget.initialConfig.conflictPolicy;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SwitchListTile(
          title: Text('Auto-sync environments'),
          value: autoSync,
          onChanged: (value) => setState(() => autoSync = value),
        ),
        const SizedBox(height: 16),
        Text('Conflict Policy', style: theme.textTheme.titleMedium),
        RadioListTile<ConflictPolicy>(
          title: const Text('Warn and skip'),
          value: ConflictPolicy.warnAndSkip,
          groupValue: conflictPolicy,
          onChanged: (value) => setState(() => conflictPolicy = value!),
        ),
        RadioListTile<ConflictPolicy>(
          title: const Text('Force overwrite'),
          value: ConflictPolicy.forceOverwrite,
          groupValue: conflictPolicy,
          onChanged: (value) => setState(() => conflictPolicy = value!),
        ),
      ],
    );
  }
}
