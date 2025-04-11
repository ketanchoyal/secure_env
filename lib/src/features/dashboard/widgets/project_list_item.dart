import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import FontAwesome
import 'package:secure_env_core/secure_env_core.dart';

import '../../../routing/app_router.dart'; // For goRouterProvider and AppRoutes

class ProjectListItem extends ConsumerWidget {
  final Project project;

  const ProjectListItem({
    required this.project,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider); // Get router instance

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      clipBehavior:
          Clip.antiAlias, // Ensure InkWell splash respects card boundaries
      child: InkWell(
        hoverColor: Theme.of(context).hoverColor, // Use theme hover color
        onTap: () {
          // Navigate to project view screen using contextless navigation
          router.go(AppRoutes.projectViewPath(project.name));
        },
        child: ListTile(
          title: Text(
            project.name,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold), // Bold title
          ),
          subtitle: Text(project.description ?? 'No description',
              maxLines: 1, overflow: TextOverflow.ellipsis),
          leading:
              const FaIcon(FontAwesomeIcons.folder), // Use FontAwesome icon
          trailing: const FaIcon(
              FontAwesomeIcons.chevronRight), // Use FontAwesome icon
          // Removed onTap: () { ... } from here
        ), // End ListTile
      ), // End InkWell
    ); // End Card
  }
}
