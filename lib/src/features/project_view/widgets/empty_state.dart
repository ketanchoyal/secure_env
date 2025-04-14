import 'package:flutter/material.dart';

class ProjectViewEmptyState extends StatelessWidget {
  final VoidCallback onCreate;
  final VoidCallback onImport;

  const ProjectViewEmptyState({
    super.key,
    required this.onCreate,
    required this.onImport,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.layers_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              'No environments found',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey[700],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Get started by creating a new environment or importing an existing one.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: SizedBox(
                    height: 50,
                    child: Center(child: const Text('Create Environment')),
                  ),
                  onPressed: onCreate,
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  icon: const Icon(Icons.file_upload),
                  label: SizedBox(
                    height: 50,
                    child: Center(child: const Text('Import Environment')),
                  ),
                  onPressed: onImport,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
