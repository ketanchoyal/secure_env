import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEditVariableModal extends ConsumerStatefulWidget {
  final String? initialKey;
  final String? initialValue;
  final bool initialIsSensitive;

  const AddEditVariableModal({
    this.initialKey,
    this.initialValue,
    this.initialIsSensitive = false,
    super.key,
  });

  @override
  ConsumerState<AddEditVariableModal> createState() => AddEditVariableModalState();
}

// Make state class public to allow access via GlobalKey
class AddEditVariableModalState extends ConsumerState<AddEditVariableModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _keyController;
  late TextEditingController _valueController;
  late bool _isSensitive;

  @override
  void initState() {
    super.initState();
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

  // Method to be called by the modal's save button
  void saveVariable() {
    // TODO: Implement actual saving logic (e.g., update provider state)
    print('Saving Variable:');
    print('  Key: ${_keyController.text}');
    print('  Value: ${_valueController.text}');
    print('  Sensitive: $_isSensitive');
    // Usually you'd call a provider method here:
    // ref.read(variablesProvider(widget.projectName, widget.environmentName).notifier).addOrUpdateVariable(...);
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
              obscureText: _isSensitive, // Obscure if sensitive
              decoration: InputDecoration(
                labelText: 'Variable Value',
                hintText: 'Enter the value',
                border: const OutlineInputBorder(),
                // Add visibility toggle only if sensitive
                suffixIcon: _isSensitive
                    ? IconButton(
                        icon: Icon(
                          // Show eye-slash if text is obscured (sensitive)
                          // This logic might need adjustment if we allow temporary viewing
                          _isSensitive ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          // This button *could* toggle temporary visibility,
                          // but for now, it does nothing as _isSensitive controls obscurity.
                          // setState(() { /* Add logic here if needed */ });
                        },
                      )
                    : null,
              ),
              validator: (value) {
                // Value can be empty, but not null if needed by logic
                if (value == null) {
                  return 'Value cannot be null (though can be empty string)';
                }
                return null;
              },
              maxLines: 3, // Allow multi-line values
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Sensitive Value'),
              subtitle: const Text('Hide value in UI after saving'), // TODO: Implement hiding
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
