import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import for icons
import 'package:secure_env_gui/src/providers/project_provider.dart';

// Placeholder state for the modal - allows access from stickyActionBar
class ImportEnvironmentModalStateContainer {
  final GlobalKey<FormState> formKey;
  final Future<bool> Function()
      importCallback; // Function to trigger the import logic

  ImportEnvironmentModalStateContainer({
    required this.formKey,
    required this.importCallback,
  });
}

class ImportEnvironmentModal extends ConsumerStatefulWidget {
  const ImportEnvironmentModal({super.key});

  // Method to provide access to the state for external use (like buttons)
  // This is a common pattern when the modal content needs to interact
  // with buttons defined outside its direct build method (e.g., in WoltModalSheetPage)
  ImportEnvironmentModalStateContainer? exposeState() {
    // Find the state object associated with this widget instance
    final state = _ImportEnvironmentModalState._currentStateMap[this];
    return state?.getStateContainer();
  }

  @override
  ConsumerState<ImportEnvironmentModal> createState() =>
      _ImportEnvironmentModalState();
}

class _ImportEnvironmentModalState
    extends ConsumerState<ImportEnvironmentModal> {
  final _formKey = GlobalKey<FormState>();
  final _envNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedFilePath;
  String? _selectedProjectName; // TODO: Populate and manage this state

  // Map to hold the current state instance for access via exposeState
  static final Map<ImportEnvironmentModal, _ImportEnvironmentModalState>
      _currentStateMap = {};

  @override
  void initState() {
    super.initState();
    // Store this state instance in the map when the widget is initialized
    _currentStateMap[widget] = this;
    // TODO: Load initial project list or set default selected project
    _selectedProjectName = 'dummy-project'; // Placeholder
  }

  @override
  void dispose() {
    // Clean up the map when the widget is disposed
    _currentStateMap.remove(widget);
    _envNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    // TODO: Implement actual file picking using a package like 'file_picker'.
    // Add file_picker to pubspec.yaml first.
    // Example (requires file_picker package):
    /*
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['env', 'properties', 'xcconfig'],
      );
      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedFilePath = result.files.single.path;
        });
      } else {
        // User canceled the picker
      }
    } catch (e) {
      // Handle exceptions (e.g. platform permissions)
      print("Error picking file: $e");
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Error picking file: ${e.toString()}')),
       );
    }
    */
    print('File picker logic needs implementation.');
    // Simulate selecting a file for now:
    setState(() {
      _selectedFilePath = '/simulated/path/to/your/project.env';
    });
  }

  // Handles validation and calls the core import logic
  Future<bool> _triggerImport() async {
    if (_selectedProjectName == null) {
      if (context.mounted) {
        // Check mount status
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a target project.')),
        );
      }
      return false; // Indicate failure
    }
    if (_selectedFilePath == null) {
      if (context.mounted) {
        // Check mount status
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a file to import.')),
        );
      }
      return false; // Indicate failure
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Ensure onSaved callbacks are triggered

      final envName = _envNameController.text.trim();
      final description = _descriptionController.text.trim();

      print('Form is valid. Preparing to import...');
      print('Target Project: $_selectedProjectName');
      print('New Env Name: $envName');
      print('Description: $description');
      print('File Path: $_selectedFilePath');

      try {
        // --- Core Logic Integration (Placeholder) ---
        // TODO: 1. Get EnvironmentService instance from Riverpod provider.
        // final envService = ref.read(environmentServiceProvider); // Make sure ref is available in state
        // TODO: 2. Call the core service method.
        // await envService.importEnvironment(
        //   projectName: _selectedProjectName!,
        //   envName: envName,
        //   filePath: _selectedFilePath!,
        //   description: description.isNotEmpty ? description : null,
        // );

        // Simulation for now:
        await Future.delayed(
          const Duration(milliseconds: 500),
        ); // Simulate async work
        print('Import successful (simulated).');

        // TODO: 3. Show success feedback (e.g., SnackBar).
        if (context.mounted) {
          // Check mount status
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Environment imported successfully (simulation)!'),
            ),
          );
        }

        return true; // Indicate success to close modal
      } catch (e) {
        // TODO: 5. Handle potential errors from the service (show error message).
        print("Error importing environment: $e");
        if (context.mounted) {
          // Check mount status
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error importing: ${e.toString()}')),
          );
        }
        return false; // Indicate failure, keep modal open
      }
      // --- End Core Logic Integration ---
    } else {
      if (context.mounted) {
        // Check mount status
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fix the errors in the form.')),
        );
      }
      return false; // Indicate failure (form invalid), keep modal open
    }
  }

  // Method accessible via exposeState() to provide state to external callers
  ImportEnvironmentModalStateContainer getStateContainer() {
    return ImportEnvironmentModalStateContainer(
      formKey: _formKey,
      importCallback: _triggerImport,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Replace placeholder project list with actual data from a provider
    // final projectsAsync = ref.watch(projectListProvider); // Example

    return Padding(
      // Add padding to match the expected WoltModalSheetPage content padding
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        16,
      ), // Adjust bottom padding if needed
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min, // Fit content vertically
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Project Selector ---
            // TODO: Replace with actual project data fetched from a provider
            Consumer(
              builder: (context, ref, child) {
                final projectListState = ref.watch(projectProvider);
                switch (projectListState) {
                  case ProjectListStateInitial():
                    return const Center(child: CircularProgressIndicator());
                  case ProjectListStateLoading():
                    return const Center(child: CircularProgressIndicator());
                  case ProjectListStateError(:final message, :final projects):
                    //Show Error SnackBar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message)),
                    );
                    return const Center(child: CircularProgressIndicator());
                  case ProjectListStateLoaded(:final projects):
                    return DropdownButtonFormField<String>(
                      value: _selectedProjectName,
                      items: projects
                          .map(
                            (project) => DropdownMenuItem(
                              value: project.name,
                              child: Text(project.name),
                            ),
                          )
                          .toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedProjectName = newValue;
                        });
                        print('Selected project: $newValue');
                      },
                      decoration: const InputDecoration(
                        labelText: 'Target Project*',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please select a target project'
                          : null,
                    );
                }

                // return projectsAsync.when(
                //   data: (projects) {
                //     // If current selection is not in the list, reset it
                //     if (_selectedProjectName != null &&
                //         !projects.any((p) => p.name == _selectedProjectName)) {
                //       _selectedProjectName = null;
                //     }

                //     return DropdownButtonFormField<String>(
                //       value: _selectedProjectName,
                //       items: projects
                //           .map(
                //             (project) => DropdownMenuItem(
                //               value: project.name,
                //               child: Text(project.name),
                //             ),
                //           )
                //           .toList(),
                //       onChanged: (String? newValue) {
                //         setState(() {
                //           _selectedProjectName = newValue;
                //         });
                //         print('Selected project: $newValue');
                //       },
                //       decoration: const InputDecoration(
                //         labelText: 'Target Project*',
                //         border: OutlineInputBorder(),
                //       ),
                //       validator: (value) => value == null || value.isEmpty
                //           ? 'Please select a target project'
                //           : null,
                //     );
                //   },
                //   loading: () =>
                //       const Center(child: CircularProgressIndicator()),
                //   error: (err, stack) => Text(
                //     'Error loading projects: $err',
                //     style: TextStyle(
                //       color: Theme.of(context).colorScheme.error,
                //     ),
                //   ),
                // );
              },
            ),
            const SizedBox(height: 16),

            // --- Environment Name ---
            TextFormField(
              controller: _envNameController,
              decoration: const InputDecoration(
                labelText: 'New Environment Name*',
                hintText: 'e.g., staging, production-readonly',
                border: OutlineInputBorder(), // Add border
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Environment name cannot be empty';
                }
                // Basic validation: check for invalid characters if needed
                if (value.contains(RegExp(r'[/\\]'))) {
                  return 'Name cannot contain slashes';
                }
                // TODO: Add validation against existing environment names for the _selectedProjectName
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 16),

            // --- Description ---
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                hintText: 'Describe the purpose of this imported environment',
                border: OutlineInputBorder(), // Add border
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),

            // --- File Picker ---
            OutlinedButton.icon(
              icon: const FaIcon(FontAwesomeIcons.folderOpen, size: 16),
              label: const Text('Select File (.env, .properties, .xcconfig)'),
              onPressed: _pickFile,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                ), // Adjust padding
              ),
            ),
            const SizedBox(height: 8),
            // Display selected file path
            Text(
              'Selected: ${_selectedFilePath ?? 'No file selected'}',
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 24),
            // Note: Import/Cancel buttons are typically defined in the
            // WoltModalSheetPage's stickyActionBar property. They will call
            // the _triggerImport method via the exposeState().
          ],
        ),
      ),
    );
  }
}
