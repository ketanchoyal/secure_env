// lib/src/features/shared_widgets/modals/new_project_modal.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:secure_env_gui/src/providers/core_providers.dart';
import 'package:secure_env_gui/src/providers/project_provider.dart';

class NewProjectModal extends ConsumerStatefulWidget {
  const NewProjectModal({super.key});

  @override
  ConsumerState<NewProjectModal> createState() => NewProjectModalState();
}

class NewProjectModalState extends ConsumerState<NewProjectModal> {
  // Make key accessible to trigger save from outside
  final formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _pathController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _pathController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _pathController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDirectory() async {
    try {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Select Project Directory',
      );

      if (selectedDirectory != null) {
        setState(() {
          _pathController.text = selectedDirectory;
        });
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error selecting directory: ${e.toString()}')),
        );
      }
    }
  }

  // Public method to be called from the modal action button
  Future<bool> saveProject() async {
    if (formKey.currentState!.validate()) {
      // Form is valid, proceed with saving
      final name = _nameController.text.trim();
      final path = _pathController.text.trim();
      final description = _descriptionController.text.trim();
      print(
        'Attempting to save project: Name=$name, Path=$path, Desc=$description',
      );

      try {
        await ref.read(projectOperationsProvider.notifier).createProject(
              name: name,
              path: path,
              description: description.isNotEmpty ? description : null,
            );

        print('Project save successful.');
        // Show success feedback
        if (context.mounted) {
          // Always check mount status before using context async
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Project "$name" created successfully.')),
          );
        }
        return true; // Indicate success to close modal
      } catch (e) {
        print('Error saving project: $e');
        // Show error feedback
        if (context.mounted) {
          // Always check mount status
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error creating project: ${e.toString()}')),
          );
        }
        return false; // Indicate failure, keep modal open
      }
    } else {
      print('Form validation failed.');
      return false; // Form invalid, keep modal open
    }
  }

  @override
  Widget build(BuildContext context) {
    // This widget provides the content *inside* the modal sheet page
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 80,
        ), // Space for potential stickyActionBar
        child: ListView(
          // Use ListView for potential scrolling
          padding: const EdgeInsets.all(16.0),
          shrinkWrap: true,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Project Name*'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Project name is required';
                }
                // Allow letters, numbers, spaces, underscores, and hyphens
                if (!RegExp(r'^[a-zA-Z0-9\s_-]+$').hasMatch(value)) {
                  return 'Project name can only contain letters, numbers, spaces, underscores, and hyphens';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _pathController,
              decoration: InputDecoration(
                labelText: 'Project Path*',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.folder_open),
                  onPressed: _pickDirectory,
                  tooltip: 'Browse for directory',
                ),
              ),
              readOnly:
                  true, // Make the field read-only since we're using a file picker
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Project path is required';
                }
                // TODO: Add validation for valid path?
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
              ),
              maxLines: 3,
            ),
            // Note: Buttons are typically placed in the stickyActionBar of WoltModalSheetPage
          ],
        ),
      ),
    );
  }
}
