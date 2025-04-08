import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import FontAwesome

import '../../routing/app_router.dart'; // Import for GoRouter access
import 'widgets/environment_detail_view.dart'; // Import the new widget

// TODO: Import environment widgets once created

class ProjectViewScreen extends ConsumerStatefulWidget {
  // TODO: Pass actual project identifier (e.g., projectName)
  final String projectName;

  const ProjectViewScreen({super.key, required this.projectName});

  @override
  ConsumerState<ProjectViewScreen> createState() => _ProjectViewScreenState();
}

class _ProjectViewScreenState extends ConsumerState<ProjectViewScreen> with SingleTickerProviderStateMixin {
  // TODO: Fetch actual environments for the project
  final List<String> _environments = ['Development', 'Staging', 'Production'];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _environments.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project: ${widget.projectName}'), // Display project name
        leading: BackButton(
          // Use contextless back navigation
          onPressed: () => ref.read(goRouterProvider).pop(),
        ),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.plus, size: 20), // Add Environment Icon
            tooltip: 'Add Environment',
            onPressed: () {
              // TODO: Implement Add Environment action
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add Environment (TODO)')),
              );
            },
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.penToSquare, size: 20), // Edit Project Icon
            tooltip: 'Edit Project Settings',
            onPressed: () {
              // TODO: Implement Edit Project Settings action
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit Project (TODO)')),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true, // Allow scrolling if many environments
          tabs: _environments.map((env) => Tab(text: env)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _environments.map((env) {
          // Use the EnvironmentDetailView for each tab
          return EnvironmentDetailView(
            projectName: widget.projectName,
            environmentName: env,
          );
        }).toList(),
      ),
      // TODO: Consider adding a FloatingActionButton for quick actions
    );
  }
}
