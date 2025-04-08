import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import '../../routing/app_router.dart'; // Removed unused import
import '../shared_widgets/modals/import_environment_modal.dart';
import '../shared_widgets/modals/new_project_modal.dart';
import '../shared_widgets/modals/wolt_modal_scaffold.dart'; // Import the scaffold helper
import 'widgets/project_list.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // appBar: AppBar( ... ) // Removed AppBar as navigation is handled by MainLayout
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
                        padding: EdgeInsets.all(8.0),
                        child: FaIcon(FontAwesomeIcons.magnifyingGlass),
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0), // Spacing
                // Import Environment Button
                ElevatedButton.icon(
                  icon: const FaIcon(FontAwesomeIcons.fileImport, size: 16),
                  label: const Text('Import Env'),
                  onPressed: () {
                    // Create an instance of the modal to access its state later
                    final importModalContent =
                        ImportEnvironmentModal(); // No key needed if using exposeState

                    showAppModalSheet(
                      context: context,
                      ref: ref,
                      title: 'Import Environment from File',
                      pageContent: importModalContent,
                      primaryActionText: 'Import',
                      // Define the primary action using the modal instance's exposeState method
                      onPrimaryAction: () async {
                        final stateContainer = importModalContent.exposeState();
                        bool success = false;
                        if (stateContainer != null) {
                          success =
                              await stateContainer
                                  .importCallback(); // Await the async call
                          // Modal closure is now handled by the helper based on return value
                        } else {
                          print(
                            "Error: Could not access ImportEnvironmentModal state via exposeState().",
                          );
                          if (context.mounted) {
                            // Check if context is valid
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Internal error: Could not initiate import.',
                                ),
                              ),
                            );
                          }
                        }
                        return success; // Return true to close modal on success, false otherwise
                      },
                      // Padding is handled inside ImportEnvironmentModal now
                      pagePadding: EdgeInsets.zero,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ), // Adjust padding
                  ),
                ),
                const SizedBox(width: 8.0), // Spacing between buttons
                // New Project Button
                ElevatedButton.icon(
                  icon: const FaIcon(
                    FontAwesomeIcons.plus,
                    size: 16,
                  ), // Smaller icon
                  label: const Text('New Project'),
                  onPressed: () {
                    // Key to access the modal's state
                    final GlobalKey<NewProjectModalState> newProjectModalKey =
                        GlobalKey<NewProjectModalState>();
                    // Create instance with key outside the builder
                    final newProjectModalContent = NewProjectModal(
                      key: newProjectModalKey,
                    );

                    showAppModalSheet(
                      context: context,
                      ref: ref, // Pass ref
                      title: 'Create New Project',
                      pageContent:
                          newProjectModalContent, // Pass the modal content widget
                      primaryActionText: 'Save',
                      // Define the primary action logic here
                      onPrimaryAction: () async {
                        final state = newProjectModalKey.currentState;
                        bool success = false;
                        // Validate and save using the modal's internal state and methods
                        if (state != null &&
                            state.formKey.currentState!.validate()) {
                          success =
                              await state.saveProject(); // Await the async call
                          // Modal closure is now handled by the helper based on return value
                          // ref.read(goRouterProvider).pop(); // No longer needed here
                        }
                        return success; // Return true to close modal on success
                      },
                      // Padding is handled inside NewProjectModal now
                      pagePadding: EdgeInsets.zero,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ), // Adjust padding
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Divider(), // Add divider
            const SizedBox(height: 16.0), // Add space after divider
            // Section Title
            Text('Projects', style: Theme.of(context).textTheme.headlineSmall),
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
            Text(
              'Recent Activity',
              style:
                  Theme.of(
                    context,
                  ).textTheme.headlineSmall, // Match Projects title style
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
}
