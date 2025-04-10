
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'project_list_item.dart'; // Import the list item widget and Project model

class ProjectList extends ConsumerWidget {
  const ProjectList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Replace with actual project data from a provider
    final List<Project> projects = [
      Project(id: '1', name: 'Project Alpha', description: 'Main project for client X'),
      Project(id: '2', name: 'Internal Tool', description: 'Utility application for team tasks'),
      Project(id: '3', name: 'Side Project Beta', description: 'Experimental features and ideas, very long description to test overflow ellipsis feature.'),
      Project(id: '4', name: 'Archived Project Gamma', description: 'Old project kept for reference'),
    ];

    if (projects.isEmpty) {
      return const Center(
        child: Text('No projects yet. Create one using the + button!'),
      );
    }

    return ListView.builder(
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return ProjectListItem(project: project);
      },
    );
  }
}
