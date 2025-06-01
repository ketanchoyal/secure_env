import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secure_env_core/secure_env_core.dart';
import 'package:secure_env_gui/src/features/shared_widgets/modals/wolt_modal_scaffold.dart';
import 'package:secure_env_gui/src/providers/environment_operations_provider.dart';

class AddEditVariableModal extends ConsumerStatefulWidget {
  final String? initialKey;
  final String? initialValue;
  final bool initialIsSensitive;
  final Environment environment;

  const AddEditVariableModal({
    required this.environment,
    this.initialKey,
    this.initialValue,
    this.initialIsSensitive = false,
    super.key,
  });

  static void show(
    BuildContext context,
    WidgetRef ref, {
    required Environment environment,
    String? initialKey,
    String? initialValue,
    bool initialIsSensitive = false,
    List<Environment>? allEnvironments,
  }) {
    final modalKey = GlobalKey<AddEditVariableModalState>();
    final modalContent = AddEditVariableModal(
      key: modalKey,
      environment: environment,
      initialKey: initialKey,
      initialValue: initialValue,
      initialIsSensitive: initialIsSensitive,
    );

    final isComm = environment.name == 'Common';

    showAppModalSheet(
      context: context,
      ref: ref,
      subtitle: isComm
          ? 'This variable will affect all environments.'
          : 'This variable will only affect the selected environment.',
      title: initialKey == null ? 'Add New Variable' : 'Edit Variable',
      pageContent: modalContent,
      onPrimaryAction: () async {
        final state = modalKey.currentState;
        if (state == null || !state.formKey.currentState!.validate()) {
          return false;
        }
        state.saveVariable();
        return true;
      },
      primaryActionText: initialKey == null ? 'Add' : 'Save',
      pagePadding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 70,
      ),
    );
  }

  @override
  ConsumerState<AddEditVariableModal> createState() =>
      AddEditVariableModalState();
}

// Make state class public to allow access via GlobalKey
class AddEditVariableModalState extends ConsumerState<AddEditVariableModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _keyController;
  late TextEditingController _valueController;
  late bool _isSensitive;

  late final EnvironmentOperations environmentOperations;

  @override
  void initState() {
    super.initState();
    environmentOperations = ref.read(environmentOperationsProvider.notifier);
    _keyController = TextEditingController(text: widget.initialKey);
    _valueController = TextEditingController(text: widget.initialValue);
    _isSensitive = widget.initialIsSensitive;
  }

  @override
  void dispose() {
    _keyController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  // Save or update a variable in the selected environment(s)
  Future<void> saveVariable() async {
    final newKey = _keyController.text.trim();
    final newValue = _valueController.text;
    final isSensitive = _isSensitive;

    // If this is the Common environment, update all real environments
    if (widget.environment.name == 'Common') {
      await environmentOperations.addVariableToAllEnvironment(
        key: newKey,
        value: newValue,
      );
    } else {
      // Single environment update (default)
      final env = widget.environment;
      final updatedValues = Map<String, String>.from(env.values);
      final updatedSensitive = Map<String, bool>.from(env.sensitiveKeys);
      updatedValues[newKey] = newValue;
      updatedSensitive[newKey] = isSensitive;
      await environmentOperations.addVariable(
        name: env.name,
        key: newKey,
        value: newValue,
      );
    }
  }

  // Remove a variable from the selected environment
  Future<void> deleteVariable() async {
    final env = widget.environment;
    final key = _keyController.text.trim();
    await environmentOperations.removeEnvironmentValue(
      envName: env.name,
      key: key,
    );
  }

  // Public getter for the form key to allow validation from outside
  GlobalKey<FormState> get formKey => _formKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      // Add MediaQuery padding for keyboard overlap
      // padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 16.0, left: 16.0, right: 16.0, top: 16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min, // Important for modals
          children: <Widget>[
            TextFormField(
              controller: _keyController,
              decoration: const InputDecoration(
                labelText: 'Variable Name (Key)',
                hintText: 'e.g., API_KEY',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a variable name';
                }
                // Basic validation: Allow alphanumeric and underscore
                if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                  return 'Only letters, numbers, and underscores allowed';
                }
                // TODO: Add validation to check for duplicate keys in the current environment
                return null;
              },
              // Disable editing key if it's an existing variable
              enabled: widget.initialKey == null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _valueController,
              decoration: InputDecoration(
                labelText: 'Variable Value',
                hintText: 'Enter the value',
                border: OutlineInputBorder(),
                // Add visibility toggle only if sensitive
                suffixIcon: _isSensitive
                    ? IconButton(
                        icon: Icon(
                          // Show eye-slash if text is obscured (sensitive)
                          // This logic might need adjustment if we allow temporary viewing
                          _isSensitive
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          // This button *could* toggle temporary visibility,
                          // but for now, it does nothing as _isSensitive controls obscurity.
                          // setState(() { /* Add logic here if needed */ });
                        },
                      )
                    : null,
              ),
              obscureText: _isSensitive, // Obscure if sensitive
              maxLines: _isSensitive
                  ? 1
                  : 3, // Fix: Obscured fields cannot be multiline
              validator: (value) {
                // Value can be empty, but not null if needed by logic
                if (value == null) {
                  return 'Value cannot be null (though can be empty string)';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Sensitive Value'),
              subtitle: const Text(
                  'Hide value in UI after saving'), // TODO: Implement hiding
              value: _isSensitive,
              onChanged: (bool value) {
                setState(() {
                  _isSensitive = value;
                });
              },
              contentPadding: EdgeInsets.zero, // Align with text fields
            ),
          ],
        ),
      ),
    );
  }
}
