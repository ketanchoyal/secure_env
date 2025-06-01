import 'package:flutter/material.dart';
import 'package:secure_env_core/secure_env_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secure_env_gui/src/features/shared_widgets/modals/wolt_modal_scaffold.dart';
import 'package:secure_env_gui/src/providers/environment_operations_provider.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;

/// Modal widget for configuring export options.
class ExportConfigModal extends StatefulWidget {
  final ExportConfig initialConfig;

  /// Shows the export settings modal and handles saving the config.
  static void show(BuildContext context, WidgetRef ref,
      {required String envName, required ExportConfig initialConfig}) {
    final modalKey = GlobalKey<ExportConfigModalState>();
    final modalContent =
        ExportConfigModal(key: modalKey, initialConfig: initialConfig);
    showAppModalSheet(
      context: context,
      ref: ref,
      title: 'Export Settings',
      pageContent: modalContent,
      onPrimaryAction: () async {
        final state = modalKey.currentState;
        if (state == null) return false;
        if (state.exportXcconfig &&
            state.xcconfigFileNameController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Please enter a filename for .xcconfig')));
          return false;
        }
        if (state.exportEnv &&
            state.envFileNameController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Please enter a filename for .env')));
          return false;
        }
        if (state.exportProperties &&
            state.propertiesFileNameController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Please enter a filename for .properties')));
          return false;
        }
        final config = ExportConfig(
          exportXcconfig: state.exportXcconfig,
          xcconfigPath: state.xcconfigPathController.text,
          xcconfigFileName: state.xcconfigFileNameController.text,
          exportEnv: state.exportEnv,
          envPath: state.envPathController.text,
          envFileName: state.envFileNameController.text,
          exportProperties: state.exportProperties,
          propertiesPath: state.propertiesPathController.text,
          propertiesFileName: state.propertiesFileNameController.text,
        );
        await ref
            .read(environmentOperationsProvider.notifier)
            .updateExportConfig(
              name: envName,
              exportConfig: config,
            );
        return true;
      },
      pagePadding:
          const EdgeInsets.only(top: 16, bottom: 100, left: 16, right: 16),
      primaryActionText: 'Save',
    );
  }

  const ExportConfigModal({
    super.key,
    required this.initialConfig,
  });

  @override
  ExportConfigModalState createState() => ExportConfigModalState();
}

class ExportConfigModalState extends State<ExportConfigModal> {
  late bool exportXcconfig;
  late TextEditingController xcconfigPathController;
  late TextEditingController xcconfigFileNameController;

  late bool exportEnv;
  late TextEditingController envPathController;
  late TextEditingController envFileNameController;

  late bool exportProperties;
  late TextEditingController propertiesPathController;
  late TextEditingController propertiesFileNameController;

  @override
  void initState() {
    super.initState();
    exportXcconfig = widget.initialConfig.exportXcconfig;
    xcconfigPathController = TextEditingController(
      text: exportXcconfig && widget.initialConfig.xcconfigPath.isNotEmpty
          ? p.dirname(widget.initialConfig.xcconfigPath)
          : widget.initialConfig.xcconfigPath,
    );
    xcconfigFileNameController =
        TextEditingController(text: widget.initialConfig.xcconfigFileName);

    exportEnv = widget.initialConfig.exportEnv;
    envPathController = TextEditingController(
      text: exportEnv && widget.initialConfig.envPath.isNotEmpty
          ? p.dirname(widget.initialConfig.envPath)
          : widget.initialConfig.envPath,
    );
    envFileNameController =
        TextEditingController(text: widget.initialConfig.envFileName);

    exportProperties = widget.initialConfig.exportProperties;
    propertiesPathController = TextEditingController(
      text: exportProperties && widget.initialConfig.propertiesPath.isNotEmpty
          ? p.dirname(widget.initialConfig.propertiesPath)
          : widget.initialConfig.propertiesPath,
    );
    propertiesFileNameController =
        TextEditingController(text: widget.initialConfig.propertiesFileName);
  }

  @override
  void dispose() {
    xcconfigPathController.dispose();
    xcconfigFileNameController.dispose();
    envPathController.dispose();
    envFileNameController.dispose();
    propertiesPathController.dispose();
    propertiesFileNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Select formats to export', style: theme.textTheme.titleMedium),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: const Text('.xcconfig'),
          value: exportXcconfig,
          onChanged: (v) => setState(() => exportXcconfig = v ?? false),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          child: Container(
            height: exportXcconfig ? null : 0,
            padding:
                const EdgeInsets.only(left: 15, bottom: 16, top: 10, right: 15),
            child: Column(
              children: [
                TextFormField(
                  controller: xcconfigPathController,
                  decoration: InputDecoration(
                    labelText: 'Path to save',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.folder_open),
                      onPressed: () async {
                        final paths =
                            await FilePicker.platform.pickFileAndDirectoryPaths(
                          type: FileType.custom,
                          allowedExtensions: ['xcconfig'],
                        );
                        if (paths != null && paths.isNotEmpty) {
                          final path = paths.first;
                          if (Directory(path).existsSync()) {
                            setState(() {
                              xcconfigPathController.text = path;
                            });
                          } else {
                            final fn = p.basenameWithoutExtension(path);
                            setState(() {
                              xcconfigPathController.text = p.dirname(path);
                              xcconfigFileNameController.text = fn;
                            });
                          }
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: xcconfigFileNameController,
                  decoration: const InputDecoration(
                      labelText: 'Filename (no extension)'),
                ),
              ],
            ),
          ),
        ),
        CheckboxListTile(
          title: const Text('.env'),
          value: exportEnv,
          onChanged: (v) => setState(() => exportEnv = v ?? false),
        ),
        // if (exportEnv)
        AnimatedSize(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          child: Container(
            height: exportEnv ? null : 0,
            padding:
                const EdgeInsets.only(left: 15, bottom: 16, top: 10, right: 15),
            child: Column(
              children: [
                TextFormField(
                  controller: envPathController,
                  decoration: InputDecoration(
                    labelText: 'Path to save',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.folder_open),
                      onPressed: () async {
                        final paths =
                            await FilePicker.platform.pickFileAndDirectoryPaths(
                          type: FileType.custom,
                          allowedExtensions: ['env'],
                        );
                        if (paths != null && paths.isNotEmpty) {
                          final path = paths.first;
                          if (Directory(path).existsSync()) {
                            setState(() {
                              envPathController.text = path;
                            });
                          } else {
                            final fn = p.basenameWithoutExtension(path);
                            setState(() {
                              envPathController.text = p.dirname(path);
                              envFileNameController.text = fn;
                            });
                          }
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: envFileNameController,
                  decoration: const InputDecoration(
                      labelText: 'Filename (no extension)'),
                ),
              ],
            ),
          ),
        ),
        CheckboxListTile(
          title: const Text('.properties'),
          value: exportProperties,
          onChanged: (v) => setState(() => exportProperties = v ?? false),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          child: Container(
            height: exportProperties ? null : 0,
            padding:
                const EdgeInsets.only(left: 15, bottom: 16, top: 10, right: 15),
            child: Column(
              children: [
                TextFormField(
                  controller: propertiesPathController,
                  decoration: InputDecoration(
                    labelText: 'Path to save',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.folder_open),
                      onPressed: () async {
                        final paths =
                            await FilePicker.platform.pickFileAndDirectoryPaths(
                          type: FileType.custom,
                          allowedExtensions: ['properties'],
                        );
                        if (paths != null && paths.isNotEmpty) {
                          final path = paths.first;
                          if (Directory(path).existsSync()) {
                            setState(() {
                              propertiesPathController.text = path;
                            });
                          } else {
                            final fn = p.basenameWithoutExtension(path);
                            setState(() {
                              propertiesPathController.text = p.dirname(path);
                              propertiesFileNameController.text = fn;
                            });
                          }
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: propertiesFileNameController,
                  decoration: const InputDecoration(
                      labelText: 'Filename (no extension)'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
