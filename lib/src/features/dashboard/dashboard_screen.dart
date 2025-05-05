import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:secure_env_gui/src/providers/app_state_providers.dart';

// import '../../routing/app_router.dart'; // Removed unused import
import '../shared_widgets/modals/import_environment_modal.dart';
import '../shared_widgets/modals/new_project_modal.dart';
import 'widgets/project_list.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Search Bar
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search Projects...',
                      prefixIcon: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 14.0,
                        ),
                        child: FaIcon(
                          FontAwesomeIcons.magnifyingGlass,
                          size: 20,
                        ),
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0), // Spacing
                // Import Environment Button
                FloatingActionButton.extended(
                  label: const Text('Import Environment'),
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  icon: const Icon(Icons.file_upload),
                  onPressed: () => _showImportEnvironmentModal(context, ref),
                ),
                const SizedBox(width: 8.0), // Spacing between buttons
                // New Project Button
                FloatingActionButton.extended(
                  heroTag: '1',
                  label: const Text('New Project'),
                  onPressed: () => _showNewProjectModal(context, ref),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            const Divider(), // Add divider
            const SizedBox(height: 16.0), // Add space after divider
            // Section Title
            Row(
              children: [
                const SizedBox(width: 10.0),
                const FaIcon(
                  FontAwesomeIcons.folderTree,
                  size: 25,
                ),
                const SizedBox(
                  width: 10.0,
                ), // Updated spacing between icon and text
                Text('Projects',
                    style: Theme.of(context).textTheme.headlineSmall),
              ],
            ),
            const SizedBox(height: 8.0),
            // Use Expanded to make the list fill available space
            const Expanded(
              flex: 3, // Give Projects list more space
              child: ProjectList(), // Add the project list widget here
            ),
            const SizedBox(height: 16.0),
            const Divider(),
            const SizedBox(height: 16.0),
            // --- NEW: Recent Activity Section ---
            Row(
              children: [
                const SizedBox(width: 10.0),
                const FaIcon(
                  FontAwesomeIcons.clockRotateLeft,
                  size: 25,
                ),
                const SizedBox(
                  width: 10.0,
                ), // Updated spacing between icon and text
                Text(
                  'Recent Activity',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall, // Match Projects title style
                ),
              ],
            ),

            const SizedBox(height: 8.0),
            // Placeholder for Activity List
            Expanded(
              flex: 2, // Give Activity list reasonable space
              child: ListView(
                shrinkWrap:
                    true, // Important if inside another scrolling view or Expanded
                children: const [
                  // TODO: Replace with actual activity data (fetch from state/service)
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.folderPlus, size: 16),
                    title: Text('Project "My App" created'),
                    subtitle: Text('Today, 9:52 AM'),
                    dense: true,
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.penToSquare, size: 16),
                    title: Text('Environment "staging" updated'),
                    subtitle: Text('Yesterday, 3:15 PM'),
                    dense: true,
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.key, size: 16),
                    title: Text('Variable API_KEY added to staging'),
                    subtitle: Text('Yesterday, 3:20 PM'),
                    dense: true,
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.trashCan, size: 16),
                    title: Text('Environment "temp-test" deleted'),
                    subtitle: Text('2 days ago'),
                    dense: true,
                  ),
                ],
              ),
            ),
            // --- END: Recent Activity Section ---
          ],
        ),
      ),
    );
  }

  void _showImportEnvironmentModal(BuildContext context, WidgetRef ref) {
    ImportEnvironmentModal.show(context, ref);
  }

  void _showNewProjectModal(BuildContext context, WidgetRef ref) {
    NewProjectModal.show(context, ref);
  }
}
