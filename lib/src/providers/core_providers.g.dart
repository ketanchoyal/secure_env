// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'core_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$registryServiceHash() => r'423bbdf1e8736c3b9f915db8dacf04035a5cae28';

/// Provider for the RegistryService
///
/// Copied from [registryService].
@ProviderFor(registryService)
final registryServiceProvider =
    AutoDisposeProvider<ProjectRegistryService>.internal(
  registryService,
  name: r'registryServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$registryServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RegistryServiceRef = AutoDisposeProviderRef<ProjectRegistryService>;
String _$projectServiceHash() => r'7396adad416f7d1fba67ccae03f5d5b5194f8ac3';

/// Provider for the ProjectService
///
/// Copied from [projectService].
@ProviderFor(projectService)
final projectServiceProvider = AutoDisposeProvider<ProjectService>.internal(
  projectService,
  name: r'projectServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$projectServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProjectServiceRef = AutoDisposeProviderRef<ProjectService>;
String _$environmentServiceHash() =>
    r'7541f8c326825dc8bc211a65886b7e6d8d8fc5a2';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provider for the EnvironmentService
///
/// Copied from [environmentService].
@ProviderFor(environmentService)
const environmentServiceProvider = EnvironmentServiceFamily();

/// Provider for the EnvironmentService
///
/// Copied from [environmentService].
class EnvironmentServiceFamily extends Family<EnvironmentService> {
  /// Provider for the EnvironmentService
  ///
  /// Copied from [environmentService].
  const EnvironmentServiceFamily();

  /// Provider for the EnvironmentService
  ///
  /// Copied from [environmentService].
  EnvironmentServiceProvider call(
    Project project,
  ) {
    return EnvironmentServiceProvider(
      project,
    );
  }

  @override
  EnvironmentServiceProvider getProviderOverride(
    covariant EnvironmentServiceProvider provider,
  ) {
    return call(
      provider.project,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'environmentServiceProvider';
}

/// Provider for the EnvironmentService
///
/// Copied from [environmentService].
class EnvironmentServiceProvider
    extends AutoDisposeProvider<EnvironmentService> {
  /// Provider for the EnvironmentService
  ///
  /// Copied from [environmentService].
  EnvironmentServiceProvider(
    Project project,
  ) : this._internal(
          (ref) => environmentService(
            ref as EnvironmentServiceRef,
            project,
          ),
          from: environmentServiceProvider,
          name: r'environmentServiceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$environmentServiceHash,
          dependencies: EnvironmentServiceFamily._dependencies,
          allTransitiveDependencies:
              EnvironmentServiceFamily._allTransitiveDependencies,
          project: project,
        );

  EnvironmentServiceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.project,
  }) : super.internal();

  final Project project;

  @override
  Override overrideWith(
    EnvironmentService Function(EnvironmentServiceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EnvironmentServiceProvider._internal(
        (ref) => create(ref as EnvironmentServiceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        project: project,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<EnvironmentService> createElement() {
    return _EnvironmentServiceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EnvironmentServiceProvider && other.project == project;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, project.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin EnvironmentServiceRef on AutoDisposeProviderRef<EnvironmentService> {
  /// The parameter `project` of this provider.
  Project get project;
}

class _EnvironmentServiceProviderElement
    extends AutoDisposeProviderElement<EnvironmentService>
    with EnvironmentServiceRef {
  _EnvironmentServiceProviderElement(super.provider);

  @override
  Project get project => (origin as EnvironmentServiceProvider).project;
}

String _$encryptionServiceHash() => r'35a23d4e9239075898a43f54cbe8d62e02f503d5';

/// Provider for the SecureStorageService
/// Provider for the EncryptionService
///
/// Copied from [encryptionService].
@ProviderFor(encryptionService)
final encryptionServiceProvider =
    AutoDisposeProvider<EncryptionService>.internal(
  encryptionService,
  name: r'encryptionServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$encryptionServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EncryptionServiceRef = AutoDisposeProviderRef<EncryptionService>;
String _$xConfigServiceHash() => r'20eefb8c6bfb1b3cccae070800f6490095fff501';

/// Provider for the XConfigService
///
/// Copied from [xConfigService].
@ProviderFor(xConfigService)
final xConfigServiceProvider = AutoDisposeProvider<XConfigService>.internal(
  xConfigService,
  name: r'xConfigServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$xConfigServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef XConfigServiceRef = AutoDisposeProviderRef<XConfigService>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
