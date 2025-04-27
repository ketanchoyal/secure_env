import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import FontAwesome
import 'package:secure_env_core/secure_env_core.dart';
import 'package:secure_env_gui/src/providers/app_state_providers.dart';
import 'package:secure_env_gui/src/providers/project_provider.dart';

import '../../../routing/app_router.dart'; // For goRouterProvider and AppRoutes

class ProjectListItem extends ConsumerWidget {
  final Project project;

  const ProjectListItem({
    required this.project,
    super.key,
  });

  void _showContextMenu(BuildContext context, WidgetRef ref, Offset position) {
    final router = ref.read(goRouterProvider);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx + 1,
        position.dy + 1,
      ),
      items: [
        PopupMenuItem(
          value: 'open',
          child: ListTile(
            leading: const Icon(Icons.folder_open),
            title: const Text('Open Project'),
            onTap: () {
              router.pop(); // Close the menu
              router.go(AppRoutes.projectViewPath(project.name));
            },
          ),
        ),
        PopupMenuItem(
          value: 'rename',
          child: ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Rename Project'),
            onTap: () {
              router.pop();
              _showRenameDialog(context, ref);
            },
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text(
              'Delete Project',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              router.pop();
              _showDeleteDialog(context, ref);
            },
          ),
        ),
      ],
    );
  }

  Future<void> _showRenameDialog(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController(text: project.name);
    final router = ref.read(goRouterProvider);

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Project'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Project Name',
            hintText: 'Enter new project name',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final newName = controller.text.trim();
              if (newName.isNotEmpty && newName != project.name) {
                await ref
                    .read(projectOperationsProvider.notifier)
                    .renameProject(
                      project.id,
                      newName,
                    );
                router.pop(); // Close the dialog
              }
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, WidgetRef ref) async {
    final router = ref.read(goRouterProvider);
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Project'),
        content: Text(
            'Are you sure you want to delete "${project.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              await ref.read(projectOperationsProvider.notifier).deleteProject(
                    project.path,
                  );
              router.pop(); // Close the dialog
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    ref.watch(environmentsNotifierProvider);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        hoverColor: Theme.of(context).hoverColor,
        onTap: () {
          ref.read(projectsNotifierProvider.notifier).selectProject(project.id);
          router.go(AppRoutes.projectViewPath(project.id));
        },
        onSecondaryTapDown: (details) =>
            _showContextMenu(context, ref, details.globalPosition),
        child: ListTile(
          title: Text(
            project.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          subtitle: Text(
            project.description ?? 'No description',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          leading: const FaIcon(FontAwesomeIcons.folder),
          trailing: const FaIcon(FontAwesomeIcons.chevronRight),
        ),
      ),
    );
  }
}
