import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secure_env_core/secure_env_core.dart';
import 'package:secure_env_gui/src/providers/app_state_providers.dart';
import 'package:secure_env_gui/src/providers/environment_provider.dart';
import 'package:secure_env_gui/src/features/shared_widgets/modals/wolt_modal_scaffold.dart';

class CreateEnvironmentModal extends ConsumerStatefulWidget {
  final String projectId;

  const CreateEnvironmentModal({
    super.key,
    required this.projectId,
  });

  static void show(BuildContext context, WidgetRef ref, String projectId) {
    final key = GlobalKey<_CreateEnvironmentModalState>();
    showAppModalSheet(
      context: context,
      ref: ref,
      barrierDismissible: false,
      title: 'Create Environment',
      pageContent: CreateEnvironmentModal(key: key, projectId: projectId),
      onPrimaryAction: () async {
        final state = key.currentState;
        if (state == null) return false;
        return await state._createEnvironment();
      },
      primaryActionText: 'Create',
      pagePadding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 100,
      ),
    );
  }

  @override
  ConsumerState<CreateEnvironmentModal> createState() =>
      _CreateEnvironmentModalState();
}

class _CreateEnvironmentModalState
    extends ConsumerState<CreateEnvironmentModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<_KeyValuePair> _keyValuePairs = [];
  bool _isCreating = false;
  Environment? _selectedTemplate;

  @override
  void initState() {
    super.initState();
    // Optionally preload environments if not loaded
    Future.microtask(() {
      ref.read(environmentsNotifierProvider.notifier).loadEnvironments();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    for (final pair in _keyValuePairs) {
      pair.keyController.dispose();
      pair.valueController.dispose();
    }
    super.dispose();
  }

  void _addKeyValuePair() {
    setState(() {
      _keyValuePairs.add(_KeyValuePair());
    });
  }

  void _removeKeyValuePair(int index) {
    setState(() {
      final pair = _keyValuePairs.removeAt(index);
      pair.keyController.dispose();
      pair.valueController.dispose();
    });
  }

  Future<bool> _createEnvironment() async {
    if (!_formKey.currentState!.validate()) {
      return false;
    }

    setState(() => _isCreating = true);

    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();

    // Create maps for values and sensitive keys
    final values = <String, String>{};
    final sensitiveKeys = <String, bool>{};

    for (final pair in _keyValuePairs) {
      final key = pair.keyController.text.trim();
      final value = pair.valueController.text.trim();
      if (key.isNotEmpty && value.isNotEmpty) {
        values[key] = value;
        sensitiveKeys[key] = pair.isSensitive;
      }
    }

    await ref.read(environmentOperationsProvider.notifier).createEnvironment(
          name: name,
          description: description.isNotEmpty ? description : null,
          values: values.isNotEmpty ? values : null,
          sensitiveKeys: sensitiveKeys.isNotEmpty ? sensitiveKeys : null,
        );

    if (mounted) {
      setState(() => _isCreating = false);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final environmentState = ref.watch(environmentsNotifierProvider);
    final environments = environmentState.environments;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Environment Name
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Environment Name*',
              hintText: 'e.g., staging, production-readonly',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.label),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Environment name cannot be empty';
              }
              if (value.contains(RegExp(r'[/\\]'))) {
                return 'Name cannot contain slashes';
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          const SizedBox(height: 16),
          // Template Picker
          DropdownButtonFormField<Environment>(
            value: _selectedTemplate,
            decoration: const InputDecoration(
              labelText: 'Template (optional)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.copy_all),
            ),
            items: [
              DropdownMenuItem<Environment>(
                value: null,
                child: Text('None'),
              ),
              ...environments.map((env) => DropdownMenuItem(
                    value: env,
                    child: Text(env.name),
                  )),
            ],
            onChanged: (env) {
              setState(() {
                _selectedTemplate = env;
                // Optionally prefill key/values from template
                if (env != null) {
                  _keyValuePairs.clear();
                  env.values.forEach((k, v) {
                    _keyValuePairs.add(_KeyValuePair(
                      keyController: TextEditingController(text: k),
                      valueController: TextEditingController(text: v),
                      isSensitive: env.sensitiveKeys[k] ?? false,
                    ));
                  });
                }
              });
            },
          ),
          const SizedBox(height: 16),
          // Description
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description (Optional)',
              hintText: 'Describe the purpose of this environment',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.description),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 24),

          // Key-Value Pairs Section
          Text(
            'Environment Variables',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ...List.generate(_keyValuePairs.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _KeyValuePairWidget(
                pair: _keyValuePairs[index],
                onRemove: () => _removeKeyValuePair(index),
              ),
            );
          }),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _addKeyValuePair,
            style: OutlinedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Add Variable'),
          ),
          if (_isCreating) ...[
            const SizedBox(height: 16),
            const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 8),
                  Text('Creating environment...'),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _KeyValuePair {
  final TextEditingController keyController;
  final TextEditingController valueController;
  bool isSensitive;

  _KeyValuePair({
    TextEditingController? keyController,
    TextEditingController? valueController,
    this.isSensitive = false,
  })  : keyController = keyController ?? TextEditingController(),
        valueController = valueController ?? TextEditingController();
}

class _KeyValuePairWidget extends StatelessWidget {
  final _KeyValuePair pair;
  final VoidCallback onRemove;

  const _KeyValuePairWidget({
    required this.pair,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Key field
        Expanded(
          flex: 2,
          child: TextFormField(
            controller: pair.keyController,
            decoration: const InputDecoration(
              labelText: 'Key',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.key),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Required';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 8),
        // Value field
        Expanded(
          flex: 3,
          child: TextFormField(
            controller: pair.valueController,
            decoration: InputDecoration(
              labelText: 'Value',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.text_fields),
              suffixIcon: IconButton(
                icon: Icon(
                  pair.isSensitive ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  // Toggle sensitive state
                  pair.isSensitive = !pair.isSensitive;
                },
                tooltip: pair.isSensitive
                    ? 'Mark as non-sensitive'
                    : 'Mark as sensitive',
              ),
            ),
            obscureText: pair.isSensitive,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Required';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 8),
        // Remove button
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: onRemove,
          tooltip: 'Remove variable',
        ),
      ],
    );
  }
}
