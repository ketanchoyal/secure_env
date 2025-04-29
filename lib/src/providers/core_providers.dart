import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:secure_env_core/secure_env_core.dart';
import 'package:secure_env_gui/src/providers/app_state_providers.dart';
import 'package:secure_env_gui/src/services/logging_service.dart';

part 'core_providers.g.dart';

/// Provider for the RegistryService
@riverpod
ProjectRegistryService registryService(Ref ref) {
  final logger = ref.watch(loggerProvider(ProjectRegistryService));
  return ProjectRegistryService(logger: logger);
}

/// Provider for the ProjectService
@riverpod
ProjectService projectService(Ref ref) {
  final logger = ref.watch(loggerProvider(ProjectService));
  final registryService = ref.watch(registryServiceProvider);
  return ProjectService(logger: logger, registryService: registryService);
}

/// Provider for the EnvironmentService
@riverpod
EnvironmentService environmentService(Ref ref, Project project) {
  final logger = ref.watch(loggerProvider(EnvironmentService));

  final projectService = ref.watch(projectServiceProvider);
  return EnvironmentService.forProject(
    project: project,
    projectService: projectService,
    logger: logger,
    encryptionService: ref.watch(encryptionServiceProvider),
  );
}

/// Provider for the SecureStorageService
// @riverpod
// core.SecureStorageService secureStorageService(SecureStorageServiceRef ref) {
//   final logger = ref.watch(loggerProvider);
//   final encryptionService = ref.watch(encryptionServiceProvider);
//   final storageDirectory = path.join(
//     core.getApplicationSupportDirectory(),
//     'secure_storage',
//   );
//   return core.SecureStorageService(
//     logger: logger,
//     encryptionService: encryptionService,
//     storageDirectory: storageDirectory,
//   );
// }

/// Provider for the EncryptionService
@riverpod
EncryptionService encryptionService(Ref ref) {
  return EncryptionService();
}

@Riverpod(dependencies: [environmentService])
EnvironmentExportService environmentExportService(Ref ref, Environment env) {
  final logger = ref.read(loggerProvider(EnvironmentExportService));
  final project = ref.read(environmentsNotifierProvider.notifier).project;

  if (project == null) {
    throw StateError('No project selected');
  }

  final environmentService = ref.read(environmentServiceProvider(project));
  return EnvironmentExportService(
    env,
    logger: logger,
    environmentService: environmentService,
  );
}
