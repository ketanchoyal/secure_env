import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:secure_env_core/secure_env_core.dart';
import 'package:secure_env_gui/src/services/logging_service.dart';

part 'core_providers.g.dart';

/// Provider for the RegistryService
@riverpod
ProjectRegistryService registryService(Ref ref) {
  final logger = ref.watch(loggerProvider);
  return ProjectRegistryService(logger: logger);
}

/// Provider for the ProjectService
@riverpod
ProjectService projectService(Ref ref) {
  final logger = ref.watch(loggerProvider);
  final registryService = ref.watch(registryServiceProvider);
  return ProjectService(logger: logger, registryService: registryService);
}

/// Provider for the EnvironmentService
@riverpod
EnvironmentService environmentService(Ref ref, Project project) {
  final logger = ref.watch(loggerProvider);

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
EncryptionService encryptionService(EncryptionServiceRef ref) {
  return EncryptionService();
}

/// Provider for the XConfigService
@riverpod
XConfigService xConfigService(XConfigServiceRef ref) {
  return XConfigService();
}
