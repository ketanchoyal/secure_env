// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProjectOperationState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ProjectOperationState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ProjectOperationState()';
  }
}

/// @nodoc
class $ProjectOperationStateCopyWith<$Res> {
  $ProjectOperationStateCopyWith(
      ProjectOperationState _, $Res Function(ProjectOperationState) __);
}

/// @nodoc

class ProjectOperationIdle implements ProjectOperationState {
  const ProjectOperationIdle();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ProjectOperationIdle);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ProjectOperationState.idle()';
  }
}

/// @nodoc

class ProjectOperationInProgress implements ProjectOperationState {
  const ProjectOperationInProgress([this.message]);

  final String? message;

  /// Create a copy of ProjectOperationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProjectOperationInProgressCopyWith<ProjectOperationInProgress>
      get copyWith =>
          _$ProjectOperationInProgressCopyWithImpl<ProjectOperationInProgress>(
              this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProjectOperationInProgress &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'ProjectOperationState.inProgress(message: $message)';
  }
}

/// @nodoc
abstract mixin class $ProjectOperationInProgressCopyWith<$Res>
    implements $ProjectOperationStateCopyWith<$Res> {
  factory $ProjectOperationInProgressCopyWith(ProjectOperationInProgress value,
          $Res Function(ProjectOperationInProgress) _then) =
      _$ProjectOperationInProgressCopyWithImpl;
  @useResult
  $Res call({String? message});
}

/// @nodoc
class _$ProjectOperationInProgressCopyWithImpl<$Res>
    implements $ProjectOperationInProgressCopyWith<$Res> {
  _$ProjectOperationInProgressCopyWithImpl(this._self, this._then);

  final ProjectOperationInProgress _self;
  final $Res Function(ProjectOperationInProgress) _then;

  /// Create a copy of ProjectOperationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = freezed,
  }) {
    return _then(ProjectOperationInProgress(
      freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class ProjectOperationSuccess implements ProjectOperationState {
  const ProjectOperationSuccess(this.message);

  final String message;

  /// Create a copy of ProjectOperationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProjectOperationSuccessCopyWith<ProjectOperationSuccess> get copyWith =>
      _$ProjectOperationSuccessCopyWithImpl<ProjectOperationSuccess>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProjectOperationSuccess &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'ProjectOperationState.success(message: $message)';
  }
}

/// @nodoc
abstract mixin class $ProjectOperationSuccessCopyWith<$Res>
    implements $ProjectOperationStateCopyWith<$Res> {
  factory $ProjectOperationSuccessCopyWith(ProjectOperationSuccess value,
          $Res Function(ProjectOperationSuccess) _then) =
      _$ProjectOperationSuccessCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$ProjectOperationSuccessCopyWithImpl<$Res>
    implements $ProjectOperationSuccessCopyWith<$Res> {
  _$ProjectOperationSuccessCopyWithImpl(this._self, this._then);

  final ProjectOperationSuccess _self;
  final $Res Function(ProjectOperationSuccess) _then;

  /// Create a copy of ProjectOperationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(ProjectOperationSuccess(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class ProjectOperationError implements ProjectOperationState {
  const ProjectOperationError(this.message);

  final String message;

  /// Create a copy of ProjectOperationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProjectOperationErrorCopyWith<ProjectOperationError> get copyWith =>
      _$ProjectOperationErrorCopyWithImpl<ProjectOperationError>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProjectOperationError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'ProjectOperationState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $ProjectOperationErrorCopyWith<$Res>
    implements $ProjectOperationStateCopyWith<$Res> {
  factory $ProjectOperationErrorCopyWith(ProjectOperationError value,
          $Res Function(ProjectOperationError) _then) =
      _$ProjectOperationErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$ProjectOperationErrorCopyWithImpl<$Res>
    implements $ProjectOperationErrorCopyWith<$Res> {
  _$ProjectOperationErrorCopyWithImpl(this._self, this._then);

  final ProjectOperationError _self;
  final $Res Function(ProjectOperationError) _then;

  /// Create a copy of ProjectOperationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(ProjectOperationError(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
