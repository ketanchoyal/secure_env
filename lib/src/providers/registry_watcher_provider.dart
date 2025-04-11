import 'dart:async';
import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:secure_env_gui/src/providers/core_providers.dart';
import 'package:secure_env_gui/src/services/logging_service.dart';
import 'package:path/path.dart' as path;

part 'registry_watcher_provider.g.dart';

@Riverpod(keepAlive: true)
class RegistryWatcher extends _$RegistryWatcher {
  Timer? _timer;
  static const _checkInterval = Duration(seconds: 5);

  @override
  bool build() {
    // Start watching when the provider is initialized
    _startWatching();
    // Return a future that never completes to keep the provider alive
    return false;
  }

  void _startWatching() {
    _timer?.cancel();
    _timer = Timer.periodic(_checkInterval, (_) => _checkRegistry());
  }

  Future<void> _checkRegistry() async {
    state = false;
    try {
      final registry = ref.read(registryServiceProvider);
      final projects = await registry.listProjects();

      for (final project in projects) {
        try {
          //Check if directory exists
          final directory =
              Directory('${project.basePath}${path.separator}.secure_env');
          if (!await directory.exists()) {
            ref.read(loggerProvider).warn(
                  'Found invalid project "${project.name}" at "${project.basePath}". Attempting to clean up...',
                );
            await registry.unregisterProject(project.id);
            ref.read(loggerProvider).info(
                  'Successfully cleaned up invalid project "${project.name}"',
                );
            state = true;
          }
        } catch (deleteError) {
          ref.read(loggerProvider).error(
                'Failed to clean up invalid project "${project.name}": $deleteError',
              );
        }
      }
    } catch (e) {
      ref.read(loggerProvider).error('Error checking registry: $e');
    }
  }

  // @override
  // void dispose() {
  //   _timer?.cancel();
  // }
}
