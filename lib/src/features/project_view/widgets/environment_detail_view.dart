import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart'; // Import WoltModalSheet

import '../../../routing/app_router.dart'; // Import for GoRouter
import 'modals/add_edit_variable_modal.dart'; // Import the modal widget

// TODO: Import VariableListItem widget once created

class EnvironmentDetailView extends ConsumerWidget {
  final String projectName;
  final String environmentName;

  const EnvironmentDetailView({
    required this.projectName,
    required this.environmentName,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Fetch environment details and variables using a provider
    // final environment = ref.watch(environmentProvider(projectName, environmentName));
    // final variables = environment.variables; // Example

    // Dummy variables for now
    final variables = {
      'API_KEY': 'dummy_key_12345',
      'DATABASE_URL': 'dummy_url_to_db',
      'SECRET_TOKEN': 'sensitive_dummy_token',
    };

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Variables for "$environmentName" Environment',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              ElevatedButton.icon(
                icon: const FaIcon(FontAwesomeIcons.plus, size: 16),
                label: const Text('Add Variable'),
                onPressed: () {
                  // Key to access the modal's state
                  final GlobalKey<AddEditVariableModalState> modalKey =
                      GlobalKey<
                        AddEditVariableModalState
                      >(); // Use State type here

                  WoltModalSheet.show<void>(
                    context: context,
                    pageListBuilder: (modalSheetContext) {
                      final addVariableModal = AddEditVariableModal(
                        key: modalKey,
                      );
                      return [
                        WoltModalSheetPage(
                          hasSabGradient: false, // Avoid gradient overlap
                          isTopBarLayerAlwaysVisible: true,
                          topBarTitle: Padding(
                            padding: const EdgeInsets.all(16.0),
                            // Use theme's titleLarge for consistency
                            child: Text(
                              'Add New Variable',
                              style:
                                  Theme.of(
                                    modalSheetContext,
                                  ).textTheme.titleLarge,
                            ),
                          ),
                          // NEW: Sticky action bar with Cancel/Save
                          stickyActionBar: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: ref.read(goRouterProvider).pop,
                                    child: const Text('Cancel'),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Access state via key.currentState
                                      final state = modalKey.currentState;
                                      if (state != null &&
                                          state.formKey.currentState!
                                              .validate()) {
                                        state.saveVariable();
                                        ref
                                            .read(goRouterProvider)
                                            .pop(); // Close modal
                                      }
                                    },
                                    child: const Text(
                                      'Add',
                                    ), // Changed from 'Save'
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Adjust child padding to avoid sticky bar
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                            child: SingleChildScrollView(
                              child: addVariableModal,
                            ),
                          ),
                        ),
                      ];
                    },
                    // Optional: customize modal appearance
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
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 24), // Increased spacing
          // Section Header for Variables
          Text(
            'Environment Variables',
            style:
                Theme.of(
                  context,
                ).textTheme.titleMedium, // Use appropriate style
          ),
          const SizedBox(height: 12), // Spacing below header
          // Use DataTable for a more desktop-friendly layout
          Expanded(
            child:
                variables.isEmpty
                    ? const Center(
                      child: Text('No variables defined for this environment.'),
                    )
                    // Use SingleChildScrollView to ensure DataTable is scrollable if needed
                    : SingleChildScrollView(
                      child: DataTable(
                        // Style the heading row
                        headingTextStyle: Theme.of(context).textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                        // Add a border for visual structure
                        border: TableBorder.all(
                          color: Theme.of(context).dividerColor,
                          width: 1,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        columns: const [
                          DataColumn(label: Text('Key')),
                          DataColumn(label: Text('Value')),
                          DataColumn(label: Text('Sensitive')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows:
                            variables.entries.map((entry) {
                              final key = entry.key;
                              final value = entry.value;
                              // TODO: Get sensitivity flag from real data
                              final isSensitive = key == 'SECRET_TOKEN';

                              // We still need state for the visibility toggle per row.
                              // Using a StatefulWidget/StateProvider per row is overkill here.
                              // A simple approach is to manage visibility state locally within the build,
                              // but this means state resets on rebuild. For now, we'll use a
                              // simple bool, acknowledging this limitation until real state management.
                              // For a DataTable, a better approach might involve a separate state management
                              // mechanism outside the build method if persistent toggle state is crucial.

                              // This is a placeholder - need a stateful way to handle this toggle per row.
                              // A Map<String, bool> in the parent widget or a Riverpod provider could work.
                              bool showSensitive = false; // TEMPORARY STATE

                              return DataRow(
                                // Add hover effect
                                color: WidgetStateProperty.resolveWith<Color?>((
                                  Set<WidgetState> states,
                                ) {
                                  if (states.contains(WidgetState.hovered)) {
                                    return Theme.of(
                                      context,
                                    ).colorScheme.primary.withOpacity(0.08);
                                  }
                                  return null; // Use default value for other states
                                }),
                                cells: [
                                  // Key Cell
                                  DataCell(Text(key)),
                                  // Value Cell (with visibility toggle if sensitive)
                                  DataCell(
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            isSensitive
                                                ? (showSensitive
                                                    ? value
                                                    : '********')
                                                : value,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (isSensitive)
                                          IconButton(
                                            icon: Icon(
                                              showSensitive
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              size: 18,
                                            ),
                                            tooltip:
                                                showSensitive ? 'Hide' : 'Show',
                                            // TODO: Implement stateful toggle for showSensitive
                                            onPressed: () {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Row-specific visibility toggle needs stateful implementation (TODO)',
                                                  ),
                                                ),
                                              );
                                              // setState(() => showSensitive = !showSensitive); // Won't work here
                                            },
                                            splashRadius: 18,
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                          ),
                                      ],
                                    ),
                                  ),
                                  // Sensitive Cell (displaying status)
                                  DataCell(
                                    Center(
                                      child: Icon(
                                        isSensitive
                                            ? Icons.check_circle
                                            : Icons.cancel,
                                        color:
                                            isSensitive
                                                ? Theme.of(
                                                  context,
                                                ).colorScheme.primary
                                                : Theme.of(
                                                  context,
                                                ).disabledColor,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                  // Actions Cell (Edit/Delete buttons)
                                  DataCell(
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            size: 18,
                                          ),
                                          tooltip: 'Edit Variable',
                                          onPressed: () {
                                            // --- EDIT MODAL LOGIC (Copied from VariableListItem) ---
                                            final GlobalKey<
                                              AddEditVariableModalState
                                            >
                                            modalKey =
                                                GlobalKey<
                                                  AddEditVariableModalState
                                                >();
                                            WoltModalSheet.show<void>(
                                              context: context,
                                              pageListBuilder: (
                                                modalSheetContext,
                                              ) {
                                                final editVariableModal =
                                                    AddEditVariableModal(
                                                      key: modalKey,
                                                      initialKey: key,
                                                      initialValue: value,
                                                      initialIsSensitive:
                                                          isSensitive,
                                                    );
                                                return [
                                                  WoltModalSheetPage(
                                                    hasSabGradient: false,
                                                    // Use theme's titleLarge for consistency
                                                    topBarTitle: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            16.0,
                                                          ),
                                                      child: Text(
                                                        'Edit Variable: $key',
                                                        style:
                                                            Theme.of(
                                                              modalSheetContext,
                                                            ).textTheme.titleLarge,
                                                      ),
                                                    ),
                                                    isTopBarLayerAlwaysVisible:
                                                        true,
                                                    // Remove trailingNavBarWidget (Close button)
                                                    // Replace stickyActionBar with full-width Cancel/Save
                                                    stickyActionBar: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            16.0,
                                                          ),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: OutlinedButton(
                                                              onPressed:
                                                                  () =>
                                                                      ref
                                                                          .read(
                                                                            goRouterProvider,
                                                                          )
                                                                          .pop(), // Close modal
                                                              child: const Text(
                                                                'Cancel',
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 16,
                                                          ),
                                                          Expanded(
                                                            child: ElevatedButton(
                                                              onPressed: () {
                                                                final state =
                                                                    modalKey
                                                                        .currentState;
                                                                if (state !=
                                                                        null &&
                                                                    state
                                                                        .formKey
                                                                        .currentState!
                                                                        .validate()) {
                                                                  state
                                                                      .saveVariable();
                                                                  ref
                                                                      .read(
                                                                        goRouterProvider,
                                                                      )
                                                                      .pop();
                                                                }
                                                              },
                                                              child: const Text(
                                                                'Save Changes',
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // Adjust child padding structure
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.fromLTRB(
                                                            16,
                                                            16,
                                                            16,
                                                            96,
                                                          ),
                                                      child:
                                                          SingleChildScrollView(
                                                            child:
                                                                editVariableModal,
                                                          ),
                                                    ),
                                                  ),
                                                ];
                                              },
                                              modalTypeBuilder: (context) {
                                                final size =
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width;
                                                if (size < 768) {
                                                  return WoltModalType.bottomSheet();
                                                } else {
                                                  return WoltModalType.dialog();
                                                }
                                              },
                                            );
                                            // --- END EDIT MODAL LOGIC ---
                                          },
                                          splashRadius: 18,
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            size: 18,
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.error,
                                          ),
                                          tooltip: 'Delete Variable',
                                          onPressed: () async {
                                            // --- DELETE DIALOG LOGIC (Copied from VariableListItem) ---
                                            final confirmDelete = await showDialog<
                                              bool
                                            >(
                                              context: context,
                                              builder: (
                                                BuildContext dialogContext,
                                              ) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    'Confirm Deletion',
                                                  ),
                                                  content: Text(
                                                    'Are you sure you want to delete the variable "$key"?',
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: const Text(
                                                        'Cancel',
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(
                                                          dialogContext,
                                                        ).pop(false);
                                                      },
                                                    ),
                                                    TextButton(
                                                      style: TextButton.styleFrom(
                                                        foregroundColor:
                                                            Theme.of(
                                                              dialogContext,
                                                            ).colorScheme.error,
                                                      ),
                                                      child: const Text(
                                                        'Delete',
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(
                                                          dialogContext,
                                                        ).pop(true);
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                            if (confirmDelete == true) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Variable "$key" deleted (TODO)',
                                                  ),
                                                  backgroundColor:
                                                      Theme.of(
                                                        context,
                                                      ).colorScheme.error,
                                                ),
                                              );
                                            }
                                            // --- END DELETE DIALOG LOGIC ---
                                          },
                                          splashRadius: 18,
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }).toList(), // Convert map entries to a list of DataRows
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
