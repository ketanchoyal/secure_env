// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'environment_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EnvironmentOperationState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EnvironmentOperationState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'EnvironmentOperationState()';
  }
}

/// @nodoc
class $EnvironmentOperationStateCopyWith<$Res> {
  $EnvironmentOperationStateCopyWith(
      EnvironmentOperationState _, $Res Function(EnvironmentOperationState) __);
}

/// @nodoc

class EnvironmentOperationIdle implements EnvironmentOperationState {
  const EnvironmentOperationIdle();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is EnvironmentOperationIdle);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'EnvironmentOperationState.idle()';
  }
}

/// @nodoc

class EnvironmentOperationInProgress implements EnvironmentOperationState {
  const EnvironmentOperationInProgress();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EnvironmentOperationInProgress);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'EnvironmentOperationState.inProgress()';
  }
}

/// @nodoc

class EnvironmentOperationSuccess implements EnvironmentOperationState {
  const EnvironmentOperationSuccess();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EnvironmentOperationSuccess);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'EnvironmentOperationState.success()';
  }
}

/// @nodoc

class EnvironmentOperationError implements EnvironmentOperationState {
  const EnvironmentOperationError(this.message);

  final String message;

  /// Create a copy of EnvironmentOperationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EnvironmentOperationErrorCopyWith<EnvironmentOperationError> get copyWith =>
      _$EnvironmentOperationErrorCopyWithImpl<EnvironmentOperationError>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EnvironmentOperationError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'EnvironmentOperationState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $EnvironmentOperationErrorCopyWith<$Res>
    implements $EnvironmentOperationStateCopyWith<$Res> {
  factory $EnvironmentOperationErrorCopyWith(EnvironmentOperationError value,
          $Res Function(EnvironmentOperationError) _then) =
      _$EnvironmentOperationErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$EnvironmentOperationErrorCopyWithImpl<$Res>
    implements $EnvironmentOperationErrorCopyWith<$Res> {
  _$EnvironmentOperationErrorCopyWithImpl(this._self, this._then);

  final EnvironmentOperationError _self;
  final $Res Function(EnvironmentOperationError) _then;

  /// Create a copy of EnvironmentOperationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(EnvironmentOperationError(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
