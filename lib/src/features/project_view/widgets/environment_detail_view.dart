import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:secure_env_core/secure_env_core.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart'; // Import WoltModalSheet

import '../../../routing/app_router.dart'; // Import for GoRouter
import 'modals/add_edit_variable_modal.dart'; // Import the modal widget
import 'modals/export_config_modal.dart'; // Import ExportConfigModal
import 'package:secure_env_gui/src/providers/environment_provider.dart'; // Import environmentOperationsProvider
import 'package:secure_env_gui/src/features/settings/settings_screen.dart'; // Import SettingsScreen

// TODO: Import VariableListItem widget once created

class EnvironmentDetailView extends ConsumerWidget {
  final Environment environment;

  const EnvironmentDetailView({
    required this.environment,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final variables = environment.values;
    final sensitiveKeys = environment.sensitiveKeys;
    final theme = Theme.of(context);
    final isCommon = environment.name == 'Common';

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 950),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                border: Border.all(color: theme.dividerColor.withOpacity(0.10)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          environment.name,
                          style: theme.textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        if (environment.description != null &&
                            environment.description!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              environment.description!,
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            const Icon(Icons.code,
                                size: 18, color: Colors.blueAccent),
                            const SizedBox(width: 8),
                            Text(
                              'Environment Variables',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.blueAccent,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (isCommon)
                    ElevatedButton.icon(
                      icon: const FaIcon(FontAwesomeIcons.plus, size: 16),
                      label: const Text('Add Variable'),
                      style: ElevatedButton.styleFrom(
                        // fixedSize: const Size(180, 40),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 14),
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () {
                        AddEditVariableModal.show(context, ref,
                            environment: environment);
                      },
                    ),
                  if (!isCommon)
                    Flexible(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final isNarrow = constraints.maxWidth < 400;
                          if (isNarrow) {
                            // Stack vertically on narrow screens
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                ElevatedButton.icon(
                                  icon: const FaIcon(FontAwesomeIcons.plus,
                                      size: 16),
                                  label: const Text('Add Variable'),
                                  style: ElevatedButton.styleFrom(
                                    // fixedSize: const Size(180, 40),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 14),
                                    textStyle: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  onPressed: () {
                                    AddEditVariableModal.show(context, ref,
                                        environment: environment);
                                  },
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.upload_file),
                                      label: const Text('Export'),
                                      style: ElevatedButton.styleFrom(
                                        // fixedSize: const Size(180, 40),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18, vertical: 14),
                                        textStyle: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      onPressed: () async {
                                        final config = environment.exportConfig;
                                        if (!(config.exportXcconfig ||
                                            config.exportEnv ||
                                            config.exportProperties)) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'No export configuration set')),
                                          );
                                          return;
                                        }
                                        await ref
                                            .read(environmentOperationsProvider
                                                .notifier)
                                            .exportEnvironment(
                                              name: environment.name,
                                            );
                                      },
                                    ),
                                    // const SizedBox(height: 8),
                                    IconButton(
                                      icon: const Icon(Icons.settings),
                                      tooltip: 'Export Settingsss',
                                      onPressed: () => ExportConfigModal.show(
                                        context,
                                        ref,
                                        envName: environment.name,
                                        initialConfig: environment.exportConfig,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          } else {
                            // Place side by side on wide screens
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton.icon(
                                  icon: const FaIcon(FontAwesomeIcons.plus,
                                      size: 16),
                                  label: const Text('Variable'),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 14),
                                    textStyle: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  onPressed: () {
                                    AddEditVariableModal.show(
                                      context,
                                      ref,
                                      environment: environment,
                                    );
                                  },
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.upload_file),
                                  label: const Text('Export'),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 14),
                                    textStyle: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  onPressed: () async {
                                    final config = environment.exportConfig;
                                    if (!(config.exportXcconfig ||
                                        config.exportEnv ||
                                        config.exportProperties)) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'No export configuration set')),
                                      );
                                      return;
                                    }
                                    await ref
                                        .read(environmentOperationsProvider
                                            .notifier)
                                        .exportEnvironment(
                                          name: environment.name,
                                        );
                                  },
                                ),
                                const SizedBox(width: 12),
                                IconButton(
                                  icon: const Icon(Icons.settings),
                                  tooltip: 'Export Settings',
                                  onPressed: () => ExportConfigModal.show(
                                    context,
                                    ref,
                                    envName: environment.name,
                                    initialConfig: environment.exportConfig,
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                ],
              ),
            ),
            // Variable List Panel
            Expanded(
              child: Card(
                margin: EdgeInsets.zero,
                elevation: 2,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(16)),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: variables.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.inbox_rounded,
                                  size: 48, color: Colors.grey[400]),
                              const SizedBox(height: 12),
                              Text('No variables found.',
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 16)),
                              const SizedBox(height: 4),
                              Text(
                                  'Click "Add Variable" to create your first one!',
                                  style: TextStyle(
                                      color: Colors.grey[500], fontSize: 14)),
                            ],
                          ),
                        )
                      : ListView.separated(
                          itemCount: variables.length,
                          separatorBuilder: (context, i) => Divider(
                              height: 1,
                              color: theme.dividerColor.withOpacity(0.08)),
                          itemBuilder: (context, i) {
                            final key = variables.keys.elementAt(i);
                            final value = variables[key] ?? '';
                            final isSensitive = sensitiveKeys[key] ?? false;
                            return _DesktopVariableRow(
                                env: environment,
                                keyName: key,
                                value: value,
                                isSensitive: isSensitive,
                                ref: ref);
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Modern desktop-style variable row
class _DesktopVariableRow extends StatefulWidget {
  final Environment env;
  final String keyName;
  final String value;
  final bool isSensitive;
  final WidgetRef ref;

  const _DesktopVariableRow({
    required this.env,
    required this.keyName,
    required this.value,
    required this.isSensitive,
    required this.ref,
  });

  @override
  State<_DesktopVariableRow> createState() => _DesktopVariableRowState();
}

class _DesktopVariableRowState extends State<_DesktopVariableRow> {
  bool _obscure = true;
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: _hover ? theme.colorScheme.primary.withOpacity(0.04) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            // Key
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              constraints: const BoxConstraints(minWidth: 220, maxWidth: 340),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                widget.keyName,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: theme.colorScheme.onSurface,
                  letterSpacing: 0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
            ),
            // Value
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.isSensitive
                          ? (_obscure ? '••••••••••••••••' : widget.value)
                          : widget.value,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  //IconButton to copy value with key
                  IconButton(
                    icon: const Icon(Icons.copy, size: 18),
                    onPressed: () {
                      final valueWithKey = '${widget.keyName}=${widget.value}';
                      Clipboard.setData(ClipboardData(text: valueWithKey));
                    },
                    tooltip: 'Copy Value with Key',
                  ),
                  if (widget.isSensitive)
                    IconButton(
                      icon: Icon(
                          _obscure ? Icons.visibility : Icons.visibility_off,
                          size: 18,
                          color: Colors.grey[600]),
                      onPressed: () => setState(() => _obscure = !_obscure),
                      tooltip: _obscure ? 'Show Value' : 'Hide Value',
                    ),
                ],
              ),
            ),
            // Sensitive Icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: widget.isSensitive
                  ? const Icon(Icons.lock_rounded,
                      color: Colors.amber, size: 18)
                  : const Icon(Icons.check_circle_rounded,
                      color: Colors.green, size: 16),
            ),
            // Actions
            IconButton(
              icon: const Icon(Icons.edit_rounded, color: Colors.blueAccent),
              tooltip: 'Edit',
              onPressed: () {
                final modalKey = GlobalKey<AddEditVariableModalState>();
                WoltModalSheet.show<void>(
                  context: context,
                  pageListBuilder: (modalSheetContext) {
                    final editVariableModal = AddEditVariableModal(
                      key: modalKey,
                      environment: widget.env,
                      initialKey: widget.keyName,
                      initialValue: widget.value,
                      initialIsSensitive: widget.isSensitive,
                    );
                    return [
                      WoltModalSheetPage(
                        hasSabGradient: false,
                        isTopBarLayerAlwaysVisible: true,
                        topBarTitle: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text('Edit Variable',
                              style: theme.textTheme.titleLarge),
                        ),
                        stickyActionBar: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: Navigator.of(context).pop,
                                  child: const Text('Cancel'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    final state = modalKey.currentState;
                                    if (state != null &&
                                        state.formKey.currentState!
                                            .validate()) {
                                      state.saveVariable();
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: const Text('Save'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                          child:
                              SingleChildScrollView(child: editVariableModal),
                        ),
                      ),
                    ];
                  },
                  modalTypeBuilder: (context) {
                    final size = MediaQuery.of(context).size.width;
                    if (size < 768) {
                      return WoltModalType.bottomSheet();
                    } else {
                      return WoltModalType.dialog();
                    }
                  },
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded,
                  color: Colors.redAccent),
              tooltip: 'Delete',
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete Variable'),
                    content: Text(
                        'Are you sure you want to delete "${widget.keyName}"?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: const Text('Delete',
                            style: TextStyle(color: Colors.redAccent)),
                      ),
                    ],
                  ),
                );
                if (confirmed == true) {
                  await widget.ref
                      .read(environmentOperationsProvider.notifier)
                      .removeEnvironmentValue(
                        envName: widget.env.name,
                        key: widget.keyName,
                      );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
