// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env_sync_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$envSyncHash() => r'21dee5f6b722d61eb7d9f07e501e1ab34412fc9b';

/// See also [envSync].
@ProviderFor(envSync)
final envSyncProvider = AutoDisposeFutureProvider<void>.internal(
  envSync,
  name: r'envSyncProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$envSyncHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EnvSyncRef = AutoDisposeFutureProviderRef<void>;
String _$envSyncNotificationsHash() =>
    r'dc295576cd83715751eceddb47e1b3e2b161899c';

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

abstract class _$EnvSyncNotifications
    extends BuildlessNotifier<List<Notification>> {
  late final String projectId;

  List<Notification> build(
    String projectId,
  );
}

/// See also [EnvSyncNotifications].
@ProviderFor(EnvSyncNotifications)
const envSyncNotificationsProvider = EnvSyncNotificationsFamily();

/// See also [EnvSyncNotifications].
class EnvSyncNotificationsFamily extends Family<List<Notification>> {
  /// See also [EnvSyncNotifications].
  const EnvSyncNotificationsFamily();

  /// See also [EnvSyncNotifications].
  EnvSyncNotificationsProvider call(
    String projectId,
  ) {
    return EnvSyncNotificationsProvider(
      projectId,
    );
  }

  @override
  EnvSyncNotificationsProvider getProviderOverride(
    covariant EnvSyncNotificationsProvider provider,
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
  String? get name => r'envSyncNotificationsProvider';
}

/// See also [EnvSyncNotifications].
class EnvSyncNotificationsProvider
    extends NotifierProviderImpl<EnvSyncNotifications, List<Notification>> {
  /// See also [EnvSyncNotifications].
  EnvSyncNotificationsProvider(
    String projectId,
  ) : this._internal(
          () => EnvSyncNotifications()..projectId = projectId,
          from: envSyncNotificationsProvider,
          name: r'envSyncNotificationsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$envSyncNotificationsHash,
          dependencies: EnvSyncNotificationsFamily._dependencies,
          allTransitiveDependencies:
              EnvSyncNotificationsFamily._allTransitiveDependencies,
          projectId: projectId,
        );

  EnvSyncNotificationsProvider._internal(
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
  List<Notification> runNotifierBuild(
    covariant EnvSyncNotifications notifier,
  ) {
    return notifier.build(
      projectId,
    );
  }

  @override
  Override overrideWith(EnvSyncNotifications Function() create) {
    return ProviderOverride(
      origin: this,
      override: EnvSyncNotificationsProvider._internal(
        () => create()..projectId = projectId,
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
  NotifierProviderElement<EnvSyncNotifications, List<Notification>>
      createElement() {
    return _EnvSyncNotificationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EnvSyncNotificationsProvider &&
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
mixin EnvSyncNotificationsRef on NotifierProviderRef<List<Notification>> {
  /// The parameter `projectId` of this provider.
  String get projectId;
}

class _EnvSyncNotificationsProviderElement
    extends NotifierProviderElement<EnvSyncNotifications, List<Notification>>
    with EnvSyncNotificationsRef {
  _EnvSyncNotificationsProviderElement(super.provider);

  @override
  String get projectId => (origin as EnvSyncNotificationsProvider).projectId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
