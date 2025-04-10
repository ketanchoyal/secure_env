import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VariableListItem extends ConsumerStatefulWidget {
  final String variableKey;
  final String variableValue;
  final bool isSensitive;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  const VariableListItem({
    required this.variableKey,
    required this.variableValue,
    required this.isSensitive,
    required this.onEditPressed,
    required this.onDeletePressed,
    super.key,
  });

  @override
  ConsumerState<VariableListItem> createState() => _VariableListItemState();
}

class _VariableListItemState extends ConsumerState<VariableListItem> {
  bool _showSensitiveValue = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayValue = widget.isSensitive
        ? (_showSensitiveValue ? widget.variableValue : '********')
        : widget.variableValue;

    return ListTile(
      hoverColor: theme.colorScheme.primary.withOpacity(0.05), // Subtle hover effect
      // Dense layout for variable lists
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0), // Less padding
      leading: FaIcon(
        FontAwesomeIcons.key,
        size: 16,
        color: theme.colorScheme.primary, // Use primary color for key icon
      ),
      title: Text(
        widget.variableKey,
        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        displayValue,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontStyle: FontStyle.italic,
          color: widget.isSensitive && !_showSensitiveValue ? theme.disabledColor : null,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Toggle visibility for sensitive values
          if (widget.isSensitive)
            IconButton(
              icon: FaIcon(
                _showSensitiveValue ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                size: 18,
              ),
              tooltip: _showSensitiveValue ? 'Hide Value' : 'Show Value',
              onPressed: () {
                setState(() {
                  _showSensitiveValue = !_showSensitiveValue;
                });
              },
              splashRadius: 20, // Smaller splash for dense layout
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(), // Remove default padding
            ),
          if (widget.isSensitive) const SizedBox(width: 8),
          // Edit Button
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.penToSquare, size: 18),
            tooltip: 'Edit Variable',
            onPressed: widget.onEditPressed,
            splashRadius: 20,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          // Delete Button
          IconButton(
            icon: FaIcon(FontAwesomeIcons.trashCan, size: 18, color: theme.colorScheme.error),
            tooltip: 'Delete Variable',
            onPressed: widget.onDeletePressed,
            splashRadius: 20,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
