// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'environment_file_watcher_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$environmentFileWatcherHash() =>
    r'e4d06da8134edd52a0af262f0386ccd8eb76f512';

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

/// See also [environmentFileWatcher].
@ProviderFor(environmentFileWatcher)
const environmentFileWatcherProvider = EnvironmentFileWatcherFamily();

/// See also [environmentFileWatcher].
class EnvironmentFileWatcherFamily
    extends Family<Raw<Stream<FileWatchEventInfo>>> {
  /// See also [environmentFileWatcher].
  const EnvironmentFileWatcherFamily();

  /// See also [environmentFileWatcher].
  EnvironmentFileWatcherProvider call(
    String projectId,
  ) {
    return EnvironmentFileWatcherProvider(
      projectId,
    );
  }

  @override
  EnvironmentFileWatcherProvider getProviderOverride(
    covariant EnvironmentFileWatcherProvider provider,
  ) {
    return call(
      provider.projectId,
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
  String? get name => r'environmentFileWatcherProvider';
}

/// See also [environmentFileWatcher].
class EnvironmentFileWatcherProvider
    extends AutoDisposeProvider<Raw<Stream<FileWatchEventInfo>>> {
  /// See also [environmentFileWatcher].
  EnvironmentFileWatcherProvider(
    String projectId,
  ) : this._internal(
          (ref) => environmentFileWatcher(
            ref as EnvironmentFileWatcherRef,
            projectId,
          ),
          from: environmentFileWatcherProvider,
          name: r'environmentFileWatcherProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$environmentFileWatcherHash,
          dependencies: EnvironmentFileWatcherFamily._dependencies,
          allTransitiveDependencies:
              EnvironmentFileWatcherFamily._allTransitiveDependencies,
          projectId: projectId,
        );

  EnvironmentFileWatcherProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.projectId,
  }) : super.internal();

  final String projectId;

  @override
  Override overrideWith(
    Raw<Stream<FileWatchEventInfo>> Function(EnvironmentFileWatcherRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EnvironmentFileWatcherProvider._internal(
        (ref) => create(ref as EnvironmentFileWatcherRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        projectId: projectId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Raw<Stream<FileWatchEventInfo>>> createElement() {
    return _EnvironmentFileWatcherProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EnvironmentFileWatcherProvider &&
        other.projectId == projectId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin EnvironmentFileWatcherRef
    on AutoDisposeProviderRef<Raw<Stream<FileWatchEventInfo>>> {
  /// The parameter `projectId` of this provider.
  String get projectId;
}

class _EnvironmentFileWatcherProviderElement
    extends AutoDisposeProviderElement<Raw<Stream<FileWatchEventInfo>>>
    with EnvironmentFileWatcherRef {
  _EnvironmentFileWatcherProviderElement(super.provider);

  @override
  String get projectId => (origin as EnvironmentFileWatcherProvider).projectId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
