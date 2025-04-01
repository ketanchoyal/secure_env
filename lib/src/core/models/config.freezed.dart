// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Config _$ConfigFromJson(Map<String, dynamic> json) {
  return _Config.fromJson(json);
}

/// @nodoc
mixin _$Config {
  Map<String, String> get keyMapping => throw _privateConstructorUsedError;
  List<String> get ignoreKeys => throw _privateConstructorUsedError;
  String get format => throw _privateConstructorUsedError;
  String? get androidResPath => throw _privateConstructorUsedError;

  /// Serializes this Config to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Config
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConfigCopyWith<Config> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConfigCopyWith<$Res> {
  factory $ConfigCopyWith(Config value, $Res Function(Config) then) =
      _$ConfigCopyWithImpl<$Res, Config>;
  @useResult
  $Res call(
      {Map<String, String> keyMapping,
      List<String> ignoreKeys,
      String format,
      String? androidResPath});
}

/// @nodoc
class _$ConfigCopyWithImpl<$Res, $Val extends Config>
    implements $ConfigCopyWith<$Res> {
  _$ConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Config
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? keyMapping = null,
    Object? ignoreKeys = null,
    Object? format = null,
    Object? androidResPath = freezed,
  }) {
    return _then(_value.copyWith(
      keyMapping: null == keyMapping
          ? _value.keyMapping
          : keyMapping // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      ignoreKeys: null == ignoreKeys
          ? _value.ignoreKeys
          : ignoreKeys // ignore: cast_nullable_to_non_nullable
              as List<String>,
      format: null == format
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as String,
      androidResPath: freezed == androidResPath
          ? _value.androidResPath
          : androidResPath // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConfigImplCopyWith<$Res> implements $ConfigCopyWith<$Res> {
  factory _$$ConfigImplCopyWith(
          _$ConfigImpl value, $Res Function(_$ConfigImpl) then) =
      __$$ConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<String, String> keyMapping,
      List<String> ignoreKeys,
      String format,
      String? androidResPath});
}

/// @nodoc
class __$$ConfigImplCopyWithImpl<$Res>
    extends _$ConfigCopyWithImpl<$Res, _$ConfigImpl>
    implements _$$ConfigImplCopyWith<$Res> {
  __$$ConfigImplCopyWithImpl(
      _$ConfigImpl _value, $Res Function(_$ConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of Config
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? keyMapping = null,
    Object? ignoreKeys = null,
    Object? format = null,
    Object? androidResPath = freezed,
  }) {
    return _then(_$ConfigImpl(
      keyMapping: null == keyMapping
          ? _value._keyMapping
          : keyMapping // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      ignoreKeys: null == ignoreKeys
          ? _value._ignoreKeys
          : ignoreKeys // ignore: cast_nullable_to_non_nullable
              as List<String>,
      format: null == format
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as String,
      androidResPath: freezed == androidResPath
          ? _value.androidResPath
          : androidResPath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConfigImpl implements _Config {
  const _$ConfigImpl(
      {final Map<String, String> keyMapping = const {},
      final List<String> ignoreKeys = const [],
      this.format = 'both',
      this.androidResPath})
      : _keyMapping = keyMapping,
        _ignoreKeys = ignoreKeys;

  factory _$ConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConfigImplFromJson(json);

  final Map<String, String> _keyMapping;
  @override
  @JsonKey()
  Map<String, String> get keyMapping {
    if (_keyMapping is EqualUnmodifiableMapView) return _keyMapping;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_keyMapping);
  }

  final List<String> _ignoreKeys;
  @override
  @JsonKey()
  List<String> get ignoreKeys {
    if (_ignoreKeys is EqualUnmodifiableListView) return _ignoreKeys;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ignoreKeys);
  }

  @override
  @JsonKey()
  final String format;
  @override
  final String? androidResPath;

  @override
  String toString() {
    return 'Config(keyMapping: $keyMapping, ignoreKeys: $ignoreKeys, format: $format, androidResPath: $androidResPath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConfigImpl &&
            const DeepCollectionEquality()
                .equals(other._keyMapping, _keyMapping) &&
            const DeepCollectionEquality()
                .equals(other._ignoreKeys, _ignoreKeys) &&
            (identical(other.format, format) || other.format == format) &&
            (identical(other.androidResPath, androidResPath) ||
                other.androidResPath == androidResPath));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_keyMapping),
      const DeepCollectionEquality().hash(_ignoreKeys),
      format,
      androidResPath);

  /// Create a copy of Config
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConfigImplCopyWith<_$ConfigImpl> get copyWith =>
      __$$ConfigImplCopyWithImpl<_$ConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConfigImplToJson(
      this,
    );
  }
}

abstract class _Config implements Config {
  const factory _Config(
      {final Map<String, String> keyMapping,
      final List<String> ignoreKeys,
      final String format,
      final String? androidResPath}) = _$ConfigImpl;

  factory _Config.fromJson(Map<String, dynamic> json) = _$ConfigImpl.fromJson;

  @override
  Map<String, String> get keyMapping;
  @override
  List<String> get ignoreKeys;
  @override
  String get format;
  @override
  String? get androidResPath;

  /// Create a copy of Config
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConfigImplCopyWith<_$ConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
