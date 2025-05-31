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
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    // lift menu up by 16px
    const lift = 25.0;
    final pos = position.translate(0, -lift);
    final dx = pos.dx.clamp(0.0, overlay.size.width);
    final dy = pos.dy.clamp(0.0, overlay.size.height);

    showMenu(
      context: context,
      popUpAnimationStyle: AnimationStyle(
        curve: Curves.easeInOut,
        reverseCurve: Curves.easeInOut,
        duration: const Duration(milliseconds: 300),
      ),
      position: RelativeRect.fromLTRB(
        dx,
        dy,
        overlay.size.width - dx,
        overlay.size.height - dy,
      ),
      items: [
        PopupMenuItem(
          value: 'open',
          child: ListTile(
            leading: const Icon(Icons.folder_open),
            title: const Text('Open Project'),
            onTap: () {
              router.pop(); // Close the menu
              _onTap(context, ref);
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

  void _onTap(BuildContext context, WidgetRef ref) async {
    final router = ref.read(goRouterProvider);
    ref.read(projectsNotifierProvider.notifier).selectProject(project.id);
    await router.push(AppRoutes.projectViewPath(project.id));
    ref.read(projectsNotifierProvider.notifier).selectProject(null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    ref.watch(environmentsNotifierProvider);

    return GestureDetector(
      onSecondaryTapDown: (details) =>
          _showContextMenu(context, ref, details.globalPosition),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          hoverColor: Theme.of(context).hoverColor,
          onTap: () {
            _onTap(context, ref);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 2.0,
                        ),
                        title: Text(
                          project.name,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        subtitle: Text(
                          project.description ?? 'No description',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        leading: const FaIcon(
                          FontAwesomeIcons.solidFolderClosed,
                          size: 28,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                        child: ListView.builder(
                          itemCount: project.environments.length,
                          // padding: const EdgeInsets.only(left: 8.0),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(4.0),
                                splashFactory: NoSplash.splashFactory,
                                onTap: () async {
                                  ref
                                      .read(projectsNotifierProvider.notifier)
                                      .selectProject(project.id);
                                  await router.push(AppRoutes.projectViewPath(
                                      project.id,
                                      environmentName:
                                          project.environments[index]));
                                  ref
                                      .read(projectsNotifierProvider.notifier)
                                      .selectProject(null);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4.0,
                                    horizontal: 12.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.grey[300]
                                        : Colors.grey[700],
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      project.environments[index],
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .textTheme
                                                .labelMedium
                                                ?.color,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8.0),
                    ],
                  ),
                ),
                const FaIcon(FontAwesomeIcons.chevronRight)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
