import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secure_env_gui/src/providers/app_state_providers.dart';

import 'project_list_item.dart'; // Import the list item widget and Project model

class ProjectList extends ConsumerWidget {
  const ProjectList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectState = ref.watch(projectsNotifierProvider);

    return switch (projectState.state) {
      NotifierState.initial || (NotifierState.loading) => const Center(
          child: CircularProgressIndicator(),
        ),
      NotifierState.loaded => projectState.projects.isEmpty
          ? const Center(
              child: Text('No projects yet. Create one using the + button!'),
            )
          : ListView.builder(
              itemCount: projectState.projects.length,
              itemBuilder: (context, index) {
                final project = projectState.projects[index];
                return ProjectListItem(project: project);
              },
            ),
      NotifierState.error => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error loading projects: ${projectState.errorMessage}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                textAlign: TextAlign.center,
              ),
              if (projectState.projects.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text('Showing cached projects:'),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: projectState.projects.length,
                    itemBuilder: (context, index) {
                      final project = projectState.projects[index];
                      return ProjectListItem(project: project);
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
    };
  }
}
