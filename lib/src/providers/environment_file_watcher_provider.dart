import 'dart:async';
import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:secure_env_core/secure_env_core.dart';
import 'package:secure_env_gui/src/providers/app_state_providers.dart';
import 'package:secure_env_gui/src/services/logging_service.dart'; // For logger
import 'package:secure_env_gui/src/providers/core_providers.dart'; // For loggerProvider

import 'package:async/async.dart'; // Required for StreamGroup

part 'environment_file_watcher_provider.g.dart';

// Custom class to hold event and associated environment info
class FileWatchEventInfo {
  final FileSystemEvent event;
  final Environment environment;
  final String watchedPath; // The specific path from ExportConfig that triggered this

  FileWatchEventInfo(this.event, this.environment, this.watchedPath);

  @override
  String toString() {
    return 'FileWatchEventInfo(path: ${event.path}, type: ${event.type}, env: ${environment.name}, watchedPath: $watchedPath)';
  }
}

@riverpod
Stream<FileWatchEventInfo> environmentFileWatcher(
    EnvironmentFileWatcherRef ref) {
  final logger = ref.watch(loggerProvider(environmentFileWatcher));

  final selectedProject =
      ref.watch(projectsNotifierProvider.select((state) => state.selectedProject));

  if (selectedProject == null) {
    logger.info('No project selected, returning empty stream for file watcher.');
    return Stream.empty();
  }

  final environmentsState = ref.watch(environmentsNotifierProvider);
  final List<Environment> environments = environmentsState.environments;

  if (environments.isEmpty) {
    logger.info(
        'No environments loaded for project ${selectedProject.name}, returning empty stream.');
    return Stream.empty();
  }

  // --- Assumption: Using the first environment as the "active" one ---
  // This is a placeholder. A real application would likely have a more explicit
  // way to determine the "active" or "selected" environment whose files to watch
  // (e.g., a dedicated `selectedEnvironmentProvider` or a family parameter).
  final Environment targetEnvironment = environments.first;
  logger.info(
      'Targeting environment "${targetEnvironment.name}" (first in list) for file watching.');
  // --- End Assumption ---

  final ExportConfig config = targetEnvironment.exportConfig;
  final List<Stream<FileWatchEventInfo>> watchStreams = [];

  // Helper function to add a watch stream if path is valid
  void addWatchStream(String? path, String fileType, Environment envContext) {
    if (path != null && path.isNotEmpty) {
      final file = File(path);
      final String currentPath = path; // Capture path for use in map
      try {
        logger.info('Adding watcher for $fileType file at path: $currentPath');
        watchStreams.add(file
            .watch()
            .map((fsEvent) => FileWatchEventInfo(fsEvent, envContext, currentPath)));
      } catch (e, stackTrace) {
        logger.error(
            'Error setting up $fileType file watcher for path "$currentPath": $e', e, stackTrace);
      }
    } else {
      logger.info('$fileType path is not configured or empty for environment "${envContext.name}", skipping watcher.');
    }
  }

  if (config.exportXcconfig) {
    addWatchStream(config.xcconfigPath, 'Xcodegen', targetEnvironment);
  }
  if (config.exportEnv) {
    addWatchStream(config.envPath, '.env', targetEnvironment);
  }
  if (config.exportProperties) {
    addWatchStream(config.propertiesPath, '.properties', targetEnvironment);
  }

  if (watchStreams.isEmpty) {
    logger.info(
        'No valid export paths configured for watching in environment "${targetEnvironment.name}".');
    return Stream.empty();
  }

  final streamGroup = StreamGroup<FileWatchEventInfo>();
  for (final stream in watchStreams) {
    streamGroup.add(stream);
  }

  logger.info(
      'File watcher provider set up to monitor ${watchStreams.length} path(s) for env "${targetEnvironment.name}".');
  return streamGroup.stream;
}
