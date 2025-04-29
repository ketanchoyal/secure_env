// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logging_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$loggerHash() => r'cf02274e729d371b0bce4dc21c3f45d5d8f61ee9';

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

/// Provider for the logging service
///
/// Copied from [logger].
@ProviderFor(logger)
const loggerProvider = LoggerFamily();

/// Provider for the logging service
///
/// Copied from [logger].
class LoggerFamily extends Family<core.Logger> {
  /// Provider for the logging service
  ///
  /// Copied from [logger].
  const LoggerFamily();

  /// Provider for the logging service
  ///
  /// Copied from [logger].
  LoggerProvider call([
    Type? type,
    String? prefix,
  ]) {
    return LoggerProvider(
      type,
      prefix,
    );
  }

  @override
  LoggerProvider getProviderOverride(
    covariant LoggerProvider provider,
  ) {
    return call(
      provider.type,
      provider.prefix,
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
  String? get name => r'loggerProvider';
}

/// Provider for the logging service
///
/// Copied from [logger].
class LoggerProvider extends AutoDisposeProvider<core.Logger> {
  /// Provider for the logging service
  ///
  /// Copied from [logger].
  LoggerProvider([
    Type? type,
    String? prefix,
  ]) : this._internal(
          (ref) => logger(
            ref as LoggerRef,
            type,
            prefix,
          ),
          from: loggerProvider,
          name: r'loggerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$loggerHash,
          dependencies: LoggerFamily._dependencies,
          allTransitiveDependencies: LoggerFamily._allTransitiveDependencies,
          type: type,
          prefix: prefix,
        );

  LoggerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
    required this.prefix,
  }) : super.internal();

  final Type? type;
  final String? prefix;

  @override
  Override overrideWith(
    core.Logger Function(LoggerRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LoggerProvider._internal(
        (ref) => create(ref as LoggerRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
        prefix: prefix,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<core.Logger> createElement() {
    return _LoggerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LoggerProvider &&
        other.type == type &&
        other.prefix == prefix;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);
    hash = _SystemHash.combine(hash, prefix.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LoggerRef on AutoDisposeProviderRef<core.Logger> {
  /// The parameter `type` of this provider.
  Type? get type;

  /// The parameter `prefix` of this provider.
  String? get prefix;
}

class _LoggerProviderElement extends AutoDisposeProviderElement<core.Logger>
    with LoggerRef {
  _LoggerProviderElement(super.provider);

  @override
  Type? get type => (origin as LoggerProvider).type;
  @override
  String? get prefix => (origin as LoggerProvider).prefix;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
