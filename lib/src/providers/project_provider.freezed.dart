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
mixin _$ProjectListState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ProjectListState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ProjectListState()';
  }
}

/// @nodoc
class $ProjectListStateCopyWith<$Res> {
  $ProjectListStateCopyWith(
      ProjectListState _, $Res Function(ProjectListState) __);
}

/// @nodoc

class ProjectListStateInitial implements ProjectListState {
  const ProjectListStateInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ProjectListStateInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ProjectListState.initial()';
  }
}

/// @nodoc

class ProjectListStateLoading implements ProjectListState {
  const ProjectListStateLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ProjectListStateLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ProjectListState.loading()';
  }
}

/// @nodoc

class ProjectListStateLoaded implements ProjectListState {
  const ProjectListStateLoaded({required final List<Project> projects})
      : _projects = projects;

  final List<Project> _projects;
  List<Project> get projects {
    if (_projects is EqualUnmodifiableListView) return _projects;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_projects);
  }

  /// Create a copy of ProjectListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProjectListStateLoadedCopyWith<ProjectListStateLoaded> get copyWith =>
      _$ProjectListStateLoadedCopyWithImpl<ProjectListStateLoaded>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProjectListStateLoaded &&
            const DeepCollectionEquality().equals(other._projects, _projects));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_projects));

  @override
  String toString() {
    return 'ProjectListState.loaded(projects: $projects)';
  }
}

/// @nodoc
abstract mixin class $ProjectListStateLoadedCopyWith<$Res>
    implements $ProjectListStateCopyWith<$Res> {
  factory $ProjectListStateLoadedCopyWith(ProjectListStateLoaded value,
          $Res Function(ProjectListStateLoaded) _then) =
      _$ProjectListStateLoadedCopyWithImpl;
  @useResult
  $Res call({List<Project> projects});
}

/// @nodoc
class _$ProjectListStateLoadedCopyWithImpl<$Res>
    implements $ProjectListStateLoadedCopyWith<$Res> {
  _$ProjectListStateLoadedCopyWithImpl(this._self, this._then);

  final ProjectListStateLoaded _self;
  final $Res Function(ProjectListStateLoaded) _then;

  /// Create a copy of ProjectListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? projects = null,
  }) {
    return _then(ProjectListStateLoaded(
      projects: null == projects
          ? _self._projects
          : projects // ignore: cast_nullable_to_non_nullable
              as List<Project>,
    ));
  }
}

/// @nodoc

class ProjectListStateError implements ProjectListState {
  const ProjectListStateError(
      {required this.message, final List<Project>? projects})
      : _projects = projects;

  final String message;
  final List<Project>? _projects;
  List<Project>? get projects {
    final value = _projects;
    if (value == null) return null;
    if (_projects is EqualUnmodifiableListView) return _projects;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of ProjectListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProjectListStateErrorCopyWith<ProjectListStateError> get copyWith =>
      _$ProjectListStateErrorCopyWithImpl<ProjectListStateError>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProjectListStateError &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other._projects, _projects));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, message, const DeepCollectionEquality().hash(_projects));

  @override
  String toString() {
    return 'ProjectListState.error(message: $message, projects: $projects)';
  }
}

/// @nodoc
abstract mixin class $ProjectListStateErrorCopyWith<$Res>
    implements $ProjectListStateCopyWith<$Res> {
  factory $ProjectListStateErrorCopyWith(ProjectListStateError value,
          $Res Function(ProjectListStateError) _then) =
      _$ProjectListStateErrorCopyWithImpl;
  @useResult
  $Res call({String message, List<Project>? projects});
}

/// @nodoc
class _$ProjectListStateErrorCopyWithImpl<$Res>
    implements $ProjectListStateErrorCopyWith<$Res> {
  _$ProjectListStateErrorCopyWithImpl(this._self, this._then);

  final ProjectListStateError _self;
  final $Res Function(ProjectListStateError) _then;

  /// Create a copy of ProjectListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
    Object? projects = freezed,
  }) {
    return _then(ProjectListStateError(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      projects: freezed == projects
          ? _self._projects
          : projects // ignore: cast_nullable_to_non_nullable
              as List<Project>?,
    ));
  }
}

// dart format on
