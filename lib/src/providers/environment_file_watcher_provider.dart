import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:secure_env_core/secure_env_core.dart';
import 'package:secure_env_gui/src/providers/app_state_providers.dart';
import 'package:secure_env_gui/src/services/logging_service.dart'; // For logger
// import 'package:secure_env_gui/src/providers/core_providers.dart'; // For loggerProvider

import 'package:async/async.dart'; // Required for StreamGroup

part 'environment_file_watcher_provider.g.dart';

// Custom class to hold event and associated environment info
class FileWatchEventInfo {
  final FileSystemEvent event;
  final Environment environment;
  final String
      watchedPath; // The specific path from ExportConfig that triggered this

  FileWatchEventInfo(this.event, this.environment, this.watchedPath);

  @override
  String toString() {
    return 'FileWatchEventInfo(path: ${event.path}, type: ${event.type}, env: ${environment.name}, watchedPath: $watchedPath)';
  }
}

@riverpod
Raw<Stream<FileWatchEventInfo>> environmentFileWatcher(
    Ref ref, String projectId) {
  final logger = ref.watch(loggerProvider(null, "environmentFileWatcher"));

  final projectState = ref.watch(projectsNotifierProvider);

  final selectedProject = projectState.projectFromId(projectId);

  if (selectedProject == null) {
    logger
        .info('No project selected, returning empty stream for file watcher.');
    return Stream.empty();
  }

  final environmentsState = ref.watch(environmentsNotifierProvider);
  final List<Environment> environments = environmentsState.environments;

  if (environments.isEmpty) {
    logger.info(
        'No environments loaded for project ${selectedProject.name}, returning empty stream.');
    return Stream.empty();
  }

  final List<Stream<FileWatchEventInfo>> watchStreams = [];

  // Helper function to add a watch stream if path is valid
  void addWatchStream(String? path, String fileType, Environment envContext) {
    if (path != null && path.isNotEmpty) {
      final file = File(path);
      final String currentPath = path; // Capture path for use in map
      try {
        logger.info('Adding watcher for $fileType file at path: $currentPath');
        watchStreams.add(file.watch().map(
            (fsEvent) => FileWatchEventInfo(fsEvent, envContext, currentPath)));
      } catch (e, stackTrace) {
        logger.error(
            'Error setting up $fileType file watcher for path "$currentPath": $e',
            e,
            stackTrace);
      }
    } else {
      logger.info(
          '$fileType path is not configured or empty for environment "${envContext.name}", skipping watcher.');
    }
  }

  void createStreamForEnvironment(Environment env) {
    logger.info('Targeting environment "${env.name}" for file watching.');
    final ExportConfig config = env.exportConfig;

    if (config.exportXcconfig) {
      addWatchStream(config.xcconfigFilePath, 'Xcodegen', env);
    }
    if (config.exportEnv) {
      addWatchStream(config.envFilePath, '.env', env);
    }
    if (config.exportProperties) {
      addWatchStream(config.propertiesFilePath, '.properties', env);
    }
  }

  // Create watch streams for all environments
  for (final env in environments) {
    createStreamForEnvironment(env);
  }
  // If no valid paths were found, return an empty stream
  if (watchStreams.isEmpty) {
    logger.info(
        'No valid export paths configured for watching in Project "${selectedProject.name}".');
    return Stream.empty();
  }

  final streamGroup = StreamGroup<FileWatchEventInfo>();
  for (final stream in watchStreams) {
    streamGroup.add(stream);
  }

  ref.onDispose(() {
    logger.info(
        'Disposing file watcher provider for Project "${selectedProject.name}".');
    streamGroup.close();
  });

  logger.info(
      'File watcher provider set up to monitor ${watchStreams.length} path(s) for Project "${selectedProject.name}".');
  return streamGroup.stream;
}
