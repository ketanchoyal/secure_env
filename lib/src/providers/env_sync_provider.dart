import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:secure_env_core/secure_env_core.dart';
import 'package:secure_env_gui/src/providers/app_state_providers.dart';
import 'package:secure_env_gui/src/providers/core_providers.dart';
import 'package:secure_env_gui/src/services/logging_service.dart';
import 'dart:async';

part 'env_sync_provider.g.dart';

// This provider runs in background and if autoSync for a project is on then it syncs any changes we make in the environment, it watches all the environment in selected project

@riverpod
Future<void> envSync(Ref ref) async {
  final logger = ref.read(loggerProvider(null, 'EnvSync'));
  // First, we handle debouncing.
  //Currently, debounce is not currectly working, so we are not using it
  // var didDispose = false;

  // ref.onDispose(() => didDispose = true);
  // final interval =
  //     ref.watch(settingsNotifierProvider.select((s) => s.autoSaveInterval));
  // await Future<void>.delayed(interval);
  // if (didDispose) {
  //   logger.info('EnvSync disposed before running');
  //   return;
  // }
  await _performSync(ref, logger);
}

/// Performs the actual environment sync, respecting autoSync setting
Future<void> _performSync(Ref ref, Logger logger) async {
  final project = ref.read(projectsNotifierProvider).selectedProject;
  if (project == null) {
    logger.info('No project selected');
    return;
  }
  if (!project.config.autoSync) {
    logger.info('Auto sync is disabled for project ${project.name}');
    logger.info('Manual sync required');
    return;
  }

  final service = ref.read(environmentServiceProvider(project));
  final environments = await service.listEnvironments();
  for (final env in environments) {
    try {
      await ref.read(environmentExportServiceProvider(env)).syncEnvironment();
    } on ExportConflictException catch (e) {
      if (e is ExportConflictExceptionMultiple) {
        for (final exception in e.exceptions) {
          ref.read(envSyncNotificationsProvider(project.id).notifier).add(
                Notification.fromException(exception),
              );
        }
      } else {
        ref
            .read(envSyncNotificationsProvider(project.id).notifier)
            .add(Notification.fromException(e));
      }
    }
  }
  logger.info('Synced all environments');
}

class Notification {
  final String message;
  final String? details;
  final DateTime timestamp;

  Notification({
    required this.message,
    this.details,
  }) : timestamp = DateTime.now();

  Notification.fromException(ExportConflictException e)
      : message = e.message,
        details = e.details,
        timestamp = DateTime.now();
}

// Provider to store Notification for EnvSync exceptions and store them locally in shared preferences,
// This provider is used to show notifications in project page
@Riverpod(keepAlive: true)
class EnvSyncNotifications extends _$EnvSyncNotifications {
  @override
  List<Notification> build(String projectId) {
    return [];
  }

  void add(Notification notification) {
    state = [...state, notification];
  }

  void clear() {
    state = [];
  }
}
