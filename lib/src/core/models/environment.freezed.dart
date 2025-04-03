// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'environment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Environment _$EnvironmentFromJson(Map<String, dynamic> json) {
  return _Environment.fromJson(json);
}

/// @nodoc
mixin _$Environment {
  String get name => throw _privateConstructorUsedError;
  String get projectName => throw _privateConstructorUsedError;
  Map<String, String> get values => throw _privateConstructorUsedError;
  Map<String, bool> get sensitiveKeys => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  DateTime? get lastModified => throw _privateConstructorUsedError;

  /// Serializes this Environment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Environment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EnvironmentCopyWith<Environment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EnvironmentCopyWith<$Res> {
  factory $EnvironmentCopyWith(
          Environment value, $Res Function(Environment) then) =
      _$EnvironmentCopyWithImpl<$Res, Environment>;
  @useResult
  $Res call(
      {String name,
      String projectName,
      Map<String, String> values,
      Map<String, bool> sensitiveKeys,
      String? description,
      DateTime? lastModified});
}

/// @nodoc
class _$EnvironmentCopyWithImpl<$Res, $Val extends Environment>
    implements $EnvironmentCopyWith<$Res> {
  _$EnvironmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Environment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? projectName = null,
    Object? values = null,
    Object? sensitiveKeys = null,
    Object? description = freezed,
    Object? lastModified = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      projectName: null == projectName
          ? _value.projectName
          : projectName // ignore: cast_nullable_to_non_nullable
              as String,
      values: null == values
          ? _value.values
          : values // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      sensitiveKeys: null == sensitiveKeys
          ? _value.sensitiveKeys
          : sensitiveKeys // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      lastModified: freezed == lastModified
          ? _value.lastModified
          : lastModified // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EnvironmentImplCopyWith<$Res>
    implements $EnvironmentCopyWith<$Res> {
  factory _$$EnvironmentImplCopyWith(
          _$EnvironmentImpl value, $Res Function(_$EnvironmentImpl) then) =
      __$$EnvironmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String projectName,
      Map<String, String> values,
      Map<String, bool> sensitiveKeys,
      String? description,
      DateTime? lastModified});
}

/// @nodoc
class __$$EnvironmentImplCopyWithImpl<$Res>
    extends _$EnvironmentCopyWithImpl<$Res, _$EnvironmentImpl>
    implements _$$EnvironmentImplCopyWith<$Res> {
  __$$EnvironmentImplCopyWithImpl(
      _$EnvironmentImpl _value, $Res Function(_$EnvironmentImpl) _then)
      : super(_value, _then);

  /// Create a copy of Environment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? projectName = null,
    Object? values = null,
    Object? sensitiveKeys = null,
    Object? description = freezed,
    Object? lastModified = freezed,
  }) {
    return _then(_$EnvironmentImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      projectName: null == projectName
          ? _value.projectName
          : projectName // ignore: cast_nullable_to_non_nullable
              as String,
      values: null == values
          ? _value._values
          : values // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      sensitiveKeys: null == sensitiveKeys
          ? _value._sensitiveKeys
          : sensitiveKeys // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      lastModified: freezed == lastModified
          ? _value.lastModified
          : lastModified // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EnvironmentImpl implements _Environment {
  const _$EnvironmentImpl(
      {required this.name,
      required this.projectName,
      required final Map<String, String> values,
      final Map<String, bool> sensitiveKeys = const {},
      this.description,
      this.lastModified})
      : _values = values,
        _sensitiveKeys = sensitiveKeys;

  factory _$EnvironmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$EnvironmentImplFromJson(json);

  @override
  final String name;
  @override
  final String projectName;
  final Map<String, String> _values;
  @override
  Map<String, String> get values {
    if (_values is EqualUnmodifiableMapView) return _values;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_values);
  }

  final Map<String, bool> _sensitiveKeys;
  @override
  @JsonKey()
  Map<String, bool> get sensitiveKeys {
    if (_sensitiveKeys is EqualUnmodifiableMapView) return _sensitiveKeys;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_sensitiveKeys);
  }

  @override
  final String? description;
  @override
  final DateTime? lastModified;

  @override
  String toString() {
    return 'Environment(name: $name, projectName: $projectName, values: $values, sensitiveKeys: $sensitiveKeys, description: $description, lastModified: $lastModified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EnvironmentImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.projectName, projectName) ||
                other.projectName == projectName) &&
            const DeepCollectionEquality().equals(other._values, _values) &&
            const DeepCollectionEquality()
                .equals(other._sensitiveKeys, _sensitiveKeys) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.lastModified, lastModified) ||
                other.lastModified == lastModified));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      projectName,
      const DeepCollectionEquality().hash(_values),
      const DeepCollectionEquality().hash(_sensitiveKeys),
      description,
      lastModified);

  /// Create a copy of Environment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EnvironmentImplCopyWith<_$EnvironmentImpl> get copyWith =>
      __$$EnvironmentImplCopyWithImpl<_$EnvironmentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EnvironmentImplToJson(
      this,
    );
  }
}

abstract class _Environment implements Environment {
  const factory _Environment(
      {required final String name,
      required final String projectName,
      required final Map<String, String> values,
      final Map<String, bool> sensitiveKeys,
      final String? description,
      final DateTime? lastModified}) = _$EnvironmentImpl;

  factory _Environment.fromJson(Map<String, dynamic> json) =
      _$EnvironmentImpl.fromJson;

  @override
  String get name;
  @override
  String get projectName;
  @override
  Map<String, String> get values;
  @override
  Map<String, bool> get sensitiveKeys;
  @override
  String? get description;
  @override
  DateTime? get lastModified;

  /// Create a copy of Environment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EnvironmentImplCopyWith<_$EnvironmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
