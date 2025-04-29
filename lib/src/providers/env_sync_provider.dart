import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:secure_env_gui/src/providers/app_state_providers.dart';
import 'package:secure_env_gui/src/providers/core_providers.dart';
import 'package:secure_env_gui/src/providers/settings_providers.dart';
import 'package:secure_env_gui/src/services/logging_service.dart';
import 'dart:async';

part 'env_sync_provider.g.dart';

// This provider runs in background and if autoSync for a project is on then it syncs any changes we make in the environment, it watches all the environment in selected project

class _EnvSyncDebouncer {
  Duration delay;
  _EnvSyncDebouncer({required this.delay});
  Timer? _timer;
  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }
}

final _envSyncDebouncer =
    _EnvSyncDebouncer(delay: const Duration(milliseconds: 500));

@riverpod
void envSync(Ref ref) {
  final interval =
      ref.watch(settingsNotifierProvider.select((s) => s.autoSaveInterval));
  _envSyncDebouncer.delay = interval;
  ref.onDispose(() => _envSyncDebouncer._timer?.cancel());
  _envSyncDebouncer.run(() => _performSync(ref));
}

/// Performs the actual environment sync, respecting autoSync setting
Future<void> _performSync(Ref ref) async {
  final logger = ref.read(loggerProvider(null, 'EnvSync'));
  final project = ref.read(environmentsNotifierProvider.notifier).project;
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
    ref.read(environmentExportServiceProvider(env)).syncEnvironment();
  }
  logger.info('Synced all environments');
}
