import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import for icons
import 'package:file_picker/file_picker.dart';
import 'package:secure_env_core/secure_env_core.dart';
import 'package:secure_env_gui/src/providers/app_state_providers.dart';
import 'package:secure_env_gui/src/providers/environment_provider.dart';
import 'package:secure_env_gui/src/features/shared_widgets/modals/wolt_modal_scaffold.dart';

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
  const ImportEnvironmentModal({super.key, this.selectedProject});
  final Project? selectedProject;

  static void show(BuildContext context, WidgetRef ref,
      {Project? selectedProject}) {
    final importModalContent =
        ImportEnvironmentModal(selectedProject: selectedProject);
    showAppModalSheet(
      context: context,
      ref: ref,
      title: 'Import Environment',
      pageContent: importModalContent,
      onPrimaryAction: () async {
        final stateContainer = importModalContent.exposeState();
        if (stateContainer == null) return false;
        return await stateContainer.importCallback();
      },
      primaryActionText: 'Import',
      pagePadding: const EdgeInsets.only(
        left: 8,
        right: 8,
        bottom: 60,
      ),
    );
  }

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

final _dropdownSelectedProject =
    StateProvider.autoDispose<Project?>((ref) => null);

class _ImportEnvironmentModalState
    extends ConsumerState<ImportEnvironmentModal> {
  final _formKey = GlobalKey<FormState>();
  final _envNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedFilePath;
  bool _isImporting = false;
  String? _errorMessage;

  // Map to hold the current state instance for access via exposeState
  static final Map<ImportEnvironmentModal, _ImportEnvironmentModalState>
      _currentStateMap = {};

  @override
  void initState() {
    super.initState();
    // Store this state instance in the map when the widget is initialized
    _currentStateMap[widget] = this;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.selectedProject != null) {
        ref.read(_dropdownSelectedProject.notifier).state =
            widget.selectedProject;
      }
    });
  }

  void selectProject(Project? project) {
    ref.read(_dropdownSelectedProject.notifier).state = project;
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
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['env', 'properties', 'xcconfig'],
        dialogTitle: 'Select Environment File',
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedFilePath = result.files.single.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting file: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  // Handles validation and calls the core import logic
  Future<bool> _triggerImport() async {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _errorMessage = null;
      });
      return false;
    }

    if (ref.read(_dropdownSelectedProject) == null) {
      setState(() {
        _errorMessage = 'Please select a target project';
      });
      return false;
    }

    if (_selectedFilePath == null) {
      setState(() {
        _errorMessage = 'Please select a file to import';
      });
      return false;
    }

    setState(() => _isImporting = true);

    try {
      await ref.read(environmentOperationsProvider.notifier).importEnvironment(
            projectId: ref.read(_dropdownSelectedProject)!.id,
            filePath: _selectedFilePath!,
            name: _envNameController.text.trim(),
            description: _descriptionController.text.trim().isNotEmpty
                ? _descriptionController.text.trim()
                : null,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Environment imported successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }

      return true;
    } catch (e) {
      setState(() {
        _errorMessage = 'Error importing environment: ${e.toString()}';
      });
      return false;
    } finally {
      if (mounted) {
        setState(() => _isImporting = false);
      }
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
    return Padding(
      // Add padding to match the expected WoltModalSheetPage content padding
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            // --- Project Selector ---
            // TODO: Replace with actual project data fetched from a provider
            Flexible(
              child: Consumer(
                builder: (context, ref, child) {
                  final projectState = ref.watch(projectsNotifierProvider);
                  return switch (projectState.state) {
                    NotifierState.initial => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    NotifierState.loading => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    NotifierState.error => Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              projectState.errorMessage ??
                                  'Error loading projects',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    NotifierState.loaded => projectState.projects.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.folder_off,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No projects available',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Create a project first to import environments',
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : AbsorbPointer(
                            absorbing: widget.selectedProject != null,
                            child: DropdownButtonFormField<Project>(
                              value: ref.watch(_dropdownSelectedProject),
                              itemHeight: 60,
                              isDense: false,
                              items: widget.selectedProject == null
                                  ? projectState.projects.map((project) {
                                      return DropdownMenuItem(
                                        value: project,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.folder, size: 20),
                                            const SizedBox(width: 8),
                                            Flexible(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(project.name),
                                                  if (project.description !=
                                                      null)
                                                    Text(
                                                      project.description!,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList()
                                  : [
                                      DropdownMenuItem(
                                        value: widget.selectedProject,
                                        child:
                                            Text(widget.selectedProject!.name),
                                      ),
                                    ],
                              onChanged: selectProject,
                              isExpanded: true,
                              decoration: const InputDecoration(
                                labelText: 'Target Project*',
                                border: OutlineInputBorder(),
                                // prefixIcon: Icon(Icons.folder),
                              ),
                            ),
                          ),
                  };
                },
              ),
            ),
            const SizedBox(height: 16),

            // --- Environment Name ---
            TextFormField(
              controller: _envNameController,
              decoration: const InputDecoration(
                labelText: 'New Environment Name*',
                hintText: 'e.g., staging, production-readonly',
                border: OutlineInputBorder(), // Add border
                prefixIcon: Icon(Icons.label),
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
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),

            // --- File Picker ---
            Row(
              children: [
                Flexible(
                  child: OutlinedButton.icon(
                    icon: const FaIcon(FontAwesomeIcons.folderOpen, size: 16),
                    label: const Text(
                        'Select File (.env, .properties, .xcconfig)'),
                    onPressed: _isImporting ? null : _pickFile,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                      ), // Adjust padding
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Display selected file path
            if (_selectedFilePath != null)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.file_present, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _selectedFilePath!,
                        style: Theme.of(context).textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),

            // Import Progress
            if (_isImporting)
              const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Importing environment...'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
