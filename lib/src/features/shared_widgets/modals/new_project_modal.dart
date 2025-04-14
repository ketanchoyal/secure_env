// lib/src/features/shared_widgets/modals/new_project_modal.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:secure_env_gui/src/providers/project_provider.dart';
import 'package:secure_env_gui/src/features/shared_widgets/modals/wolt_modal_scaffold.dart';

class NewProjectModal extends ConsumerStatefulWidget {
  const NewProjectModal({super.key});

  static void show(BuildContext context, WidgetRef ref) {
    final modalKey = GlobalKey<NewProjectModalState>();
    final newProjectModalContent = NewProjectModal(key: modalKey);

    showAppModalSheet(
      context: context,
      ref: ref,
      title: 'Create New Project',
      pageContent: newProjectModalContent,
      onPrimaryAction: () async {
        final state = modalKey.currentState;
        if (state == null || !state.formKey.currentState!.validate()) {
          return false;
        }
        return await state.saveProject();
      },
      primaryActionText: 'Save',
      pagePadding: const EdgeInsets.only(
        left: 8,
        right: 8,
        bottom: 45,
      ),
    );
  }

  @override
  ConsumerState<NewProjectModal> createState() => NewProjectModalState();
}

class NewProjectModalState extends ConsumerState<NewProjectModal> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _pathController;
  late final TextEditingController _descriptionController;
  bool _isCreating = false;

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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting directory: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<bool> saveProject() async {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    setState(() => _isCreating = true);

    try {
      final name = _nameController.text.trim();
      final path = _pathController.text.trim();
      final description = _descriptionController.text.trim();

      await ref.read(projectOperationsProvider.notifier).createProject(
            name: name,
            path: path,
            description: description.isNotEmpty ? description : null,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Project "$name" created successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
      return true;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating project: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
      return false;
    } finally {
      if (mounted) {
        setState(() => _isCreating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Project Name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Project Name',
                hintText: 'e.g., my-awesome-project',
                prefixIcon: Icon(Icons.folder),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Project name is required';
                }
                if (!RegExp(r'^[a-zA-Z0-9\s_-]+$').hasMatch(value)) {
                  return 'Project name can only contain letters, numbers, spaces, underscores, and hyphens';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 16),

            // Project Path
            TextFormField(
              controller: _pathController,
              decoration: InputDecoration(
                labelText: 'Project Path',
                hintText: 'Select a directory for your project',
                prefixIcon: const Icon(Icons.folder_open),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.folder_open),
                  onPressed: _isCreating ? null : _pickDirectory,
                  tooltip: 'Browse for directory',
                ),
              ),
              readOnly: true,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Project path is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Describe your project',
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Selected Path Display
            if (_pathController.text.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.folder, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _pathController.text,
                        style: Theme.of(context).textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),

            // Create Progress
            if (_isCreating)
              const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Creating project...'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
