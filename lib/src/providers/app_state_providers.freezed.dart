// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_state_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProjectState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ProjectState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ProjectState()';
  }
}

/// @nodoc
class $ProjectStateCopyWith<$Res> {
  $ProjectStateCopyWith(ProjectState _, $Res Function(ProjectState) __);
}

/// @nodoc

class _Initial implements ProjectState {
  const _Initial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Initial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ProjectState.initial()';
  }
}

/// @nodoc

class _Loading implements ProjectState {
  const _Loading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Loading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ProjectState.loading()';
  }
}

/// @nodoc

class _Loaded implements ProjectState {
  const _Loaded(
      {required final List<Project> projects,
      this.selectedProjectName,
      this.selectedProject})
      : _projects = projects;

  final List<Project> _projects;
  List<Project> get projects {
    if (_projects is EqualUnmodifiableListView) return _projects;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_projects);
  }

  final String? selectedProjectName;
  final Project? selectedProject;

  /// Create a copy of ProjectState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LoadedCopyWith<_Loaded> get copyWith =>
      __$LoadedCopyWithImpl<_Loaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Loaded &&
            const DeepCollectionEquality().equals(other._projects, _projects) &&
            (identical(other.selectedProjectName, selectedProjectName) ||
                other.selectedProjectName == selectedProjectName) &&
            (identical(other.selectedProject, selectedProject) ||
                other.selectedProject == selectedProject));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_projects),
      selectedProjectName,
      selectedProject);

  @override
  String toString() {
    return 'ProjectState.loaded(projects: $projects, selectedProjectName: $selectedProjectName, selectedProject: $selectedProject)';
  }
}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res>
    implements $ProjectStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) =
      __$LoadedCopyWithImpl;
  @useResult
  $Res call(
      {List<Project> projects,
      String? selectedProjectName,
      Project? selectedProject});

  $ProjectCopyWith<$Res>? get selectedProject;
}

/// @nodoc
class __$LoadedCopyWithImpl<$Res> implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

  /// Create a copy of ProjectState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? projects = null,
    Object? selectedProjectName = freezed,
    Object? selectedProject = freezed,
  }) {
    return _then(_Loaded(
      projects: null == projects
          ? _self._projects
          : projects // ignore: cast_nullable_to_non_nullable
              as List<Project>,
      selectedProjectName: freezed == selectedProjectName
          ? _self.selectedProjectName
          : selectedProjectName // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedProject: freezed == selectedProject
          ? _self.selectedProject
          : selectedProject // ignore: cast_nullable_to_non_nullable
              as Project?,
    ));
  }

  /// Create a copy of ProjectState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProjectCopyWith<$Res>? get selectedProject {
    if (_self.selectedProject == null) {
      return null;
    }

    return $ProjectCopyWith<$Res>(_self.selectedProject!, (value) {
      return _then(_self.copyWith(selectedProject: value));
    });
  }
}

/// @nodoc

class _Error implements ProjectState {
  const _Error(
      {required this.message,
      final List<Project>? projects,
      this.selectedProjectName,
      this.selectedProject})
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

  final String? selectedProjectName;
  final Project? selectedProject;

  /// Create a copy of ProjectState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ErrorCopyWith<_Error> get copyWith =>
      __$ErrorCopyWithImpl<_Error>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Error &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other._projects, _projects) &&
            (identical(other.selectedProjectName, selectedProjectName) ||
                other.selectedProjectName == selectedProjectName) &&
            (identical(other.selectedProject, selectedProject) ||
                other.selectedProject == selectedProject));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      message,
      const DeepCollectionEquality().hash(_projects),
      selectedProjectName,
      selectedProject);

  @override
  String toString() {
    return 'ProjectState.error(message: $message, projects: $projects, selectedProjectName: $selectedProjectName, selectedProject: $selectedProject)';
  }
}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res>
    implements $ProjectStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) =
      __$ErrorCopyWithImpl;
  @useResult
  $Res call(
      {String message,
      List<Project>? projects,
      String? selectedProjectName,
      Project? selectedProject});

  $ProjectCopyWith<$Res>? get selectedProject;
}

/// @nodoc
class __$ErrorCopyWithImpl<$Res> implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

  /// Create a copy of ProjectState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
    Object? projects = freezed,
    Object? selectedProjectName = freezed,
    Object? selectedProject = freezed,
  }) {
    return _then(_Error(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      projects: freezed == projects
          ? _self._projects
          : projects // ignore: cast_nullable_to_non_nullable
              as List<Project>?,
      selectedProjectName: freezed == selectedProjectName
          ? _self.selectedProjectName
          : selectedProjectName // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedProject: freezed == selectedProject
          ? _self.selectedProject
          : selectedProject // ignore: cast_nullable_to_non_nullable
              as Project?,
    ));
  }

  /// Create a copy of ProjectState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProjectCopyWith<$Res>? get selectedProject {
    if (_self.selectedProject == null) {
      return null;
    }

    return $ProjectCopyWith<$Res>(_self.selectedProject!, (value) {
      return _then(_self.copyWith(selectedProject: value));
    });
  }
}

/// @nodoc
mixin _$EnvironmentState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is EnvironmentState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'EnvironmentState()';
  }
}

/// @nodoc
class $EnvironmentStateCopyWith<$Res> {
  $EnvironmentStateCopyWith(
      EnvironmentState _, $Res Function(EnvironmentState) __);
}

/// @nodoc

class _EnvInitial implements EnvironmentState {
  const _EnvInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _EnvInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'EnvironmentState.initial()';
  }
}

/// @nodoc

class _EnvLoading implements EnvironmentState {
  const _EnvLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _EnvLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'EnvironmentState.loading()';
  }
}

/// @nodoc

class _EnvLoaded implements EnvironmentState {
  const _EnvLoaded(
      {required final List<Environment> environments,
      this.selectedEnvironmentName,
      this.selectedEnvironment,
      final Map<String, String> environmentValues = const {},
      this.isEditing = false})
      : _environments = environments,
        _environmentValues = environmentValues;

  final List<Environment> _environments;
  List<Environment> get environments {
    if (_environments is EqualUnmodifiableListView) return _environments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_environments);
  }

  final String? selectedEnvironmentName;
  final Environment? selectedEnvironment;
  final Map<String, String> _environmentValues;
  @JsonKey()
  Map<String, String> get environmentValues {
    if (_environmentValues is EqualUnmodifiableMapView)
      return _environmentValues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_environmentValues);
  }

  @JsonKey()
  final bool isEditing;

  /// Create a copy of EnvironmentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$EnvLoadedCopyWith<_EnvLoaded> get copyWith =>
      __$EnvLoadedCopyWithImpl<_EnvLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _EnvLoaded &&
            const DeepCollectionEquality()
                .equals(other._environments, _environments) &&
            (identical(
                    other.selectedEnvironmentName, selectedEnvironmentName) ||
                other.selectedEnvironmentName == selectedEnvironmentName) &&
            (identical(other.selectedEnvironment, selectedEnvironment) ||
                other.selectedEnvironment == selectedEnvironment) &&
            const DeepCollectionEquality()
                .equals(other._environmentValues, _environmentValues) &&
            (identical(other.isEditing, isEditing) ||
                other.isEditing == isEditing));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_environments),
      selectedEnvironmentName,
      selectedEnvironment,
      const DeepCollectionEquality().hash(_environmentValues),
      isEditing);

  @override
  String toString() {
    return 'EnvironmentState.loaded(environments: $environments, selectedEnvironmentName: $selectedEnvironmentName, selectedEnvironment: $selectedEnvironment, environmentValues: $environmentValues, isEditing: $isEditing)';
  }
}

/// @nodoc
abstract mixin class _$EnvLoadedCopyWith<$Res>
    implements $EnvironmentStateCopyWith<$Res> {
  factory _$EnvLoadedCopyWith(
          _EnvLoaded value, $Res Function(_EnvLoaded) _then) =
      __$EnvLoadedCopyWithImpl;
  @useResult
  $Res call(
      {List<Environment> environments,
      String? selectedEnvironmentName,
      Environment? selectedEnvironment,
      Map<String, String> environmentValues,
      bool isEditing});

  $EnvironmentCopyWith<$Res>? get selectedEnvironment;
}

/// @nodoc
class __$EnvLoadedCopyWithImpl<$Res> implements _$EnvLoadedCopyWith<$Res> {
  __$EnvLoadedCopyWithImpl(this._self, this._then);

  final _EnvLoaded _self;
  final $Res Function(_EnvLoaded) _then;

  /// Create a copy of EnvironmentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? environments = null,
    Object? selectedEnvironmentName = freezed,
    Object? selectedEnvironment = freezed,
    Object? environmentValues = null,
    Object? isEditing = null,
  }) {
    return _then(_EnvLoaded(
      environments: null == environments
          ? _self._environments
          : environments // ignore: cast_nullable_to_non_nullable
              as List<Environment>,
      selectedEnvironmentName: freezed == selectedEnvironmentName
          ? _self.selectedEnvironmentName
          : selectedEnvironmentName // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedEnvironment: freezed == selectedEnvironment
          ? _self.selectedEnvironment
          : selectedEnvironment // ignore: cast_nullable_to_non_nullable
              as Environment?,
      environmentValues: null == environmentValues
          ? _self._environmentValues
          : environmentValues // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      isEditing: null == isEditing
          ? _self.isEditing
          : isEditing // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of EnvironmentState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EnvironmentCopyWith<$Res>? get selectedEnvironment {
    if (_self.selectedEnvironment == null) {
      return null;
    }

    return $EnvironmentCopyWith<$Res>(_self.selectedEnvironment!, (value) {
      return _then(_self.copyWith(selectedEnvironment: value));
    });
  }
}

/// @nodoc

class _EnvError implements EnvironmentState {
  const _EnvError(
      {required this.message,
      final List<Environment>? environments,
      this.selectedEnvironmentName,
      this.selectedEnvironment,
      final Map<String, String>? environmentValues,
      this.isEditing})
      : _environments = environments,
        _environmentValues = environmentValues;

  final String message;
  final List<Environment>? _environments;
  List<Environment>? get environments {
    final value = _environments;
    if (value == null) return null;
    if (_environments is EqualUnmodifiableListView) return _environments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final String? selectedEnvironmentName;
  final Environment? selectedEnvironment;
  final Map<String, String>? _environmentValues;
  Map<String, String>? get environmentValues {
    final value = _environmentValues;
    if (value == null) return null;
    if (_environmentValues is EqualUnmodifiableMapView)
      return _environmentValues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final bool? isEditing;

  /// Create a copy of EnvironmentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$EnvErrorCopyWith<_EnvError> get copyWith =>
      __$EnvErrorCopyWithImpl<_EnvError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _EnvError &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality()
                .equals(other._environments, _environments) &&
            (identical(
                    other.selectedEnvironmentName, selectedEnvironmentName) ||
                other.selectedEnvironmentName == selectedEnvironmentName) &&
            (identical(other.selectedEnvironment, selectedEnvironment) ||
                other.selectedEnvironment == selectedEnvironment) &&
            const DeepCollectionEquality()
                .equals(other._environmentValues, _environmentValues) &&
            (identical(other.isEditing, isEditing) ||
                other.isEditing == isEditing));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      message,
      const DeepCollectionEquality().hash(_environments),
      selectedEnvironmentName,
      selectedEnvironment,
      const DeepCollectionEquality().hash(_environmentValues),
      isEditing);

  @override
  String toString() {
    return 'EnvironmentState.error(message: $message, environments: $environments, selectedEnvironmentName: $selectedEnvironmentName, selectedEnvironment: $selectedEnvironment, environmentValues: $environmentValues, isEditing: $isEditing)';
  }
}

/// @nodoc
abstract mixin class _$EnvErrorCopyWith<$Res>
    implements $EnvironmentStateCopyWith<$Res> {
  factory _$EnvErrorCopyWith(_EnvError value, $Res Function(_EnvError) _then) =
      __$EnvErrorCopyWithImpl;
  @useResult
  $Res call(
      {String message,
      List<Environment>? environments,
      String? selectedEnvironmentName,
      Environment? selectedEnvironment,
      Map<String, String>? environmentValues,
      bool? isEditing});

  $EnvironmentCopyWith<$Res>? get selectedEnvironment;
}

/// @nodoc
class __$EnvErrorCopyWithImpl<$Res> implements _$EnvErrorCopyWith<$Res> {
  __$EnvErrorCopyWithImpl(this._self, this._then);

  final _EnvError _self;
  final $Res Function(_EnvError) _then;

  /// Create a copy of EnvironmentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
    Object? environments = freezed,
    Object? selectedEnvironmentName = freezed,
    Object? selectedEnvironment = freezed,
    Object? environmentValues = freezed,
    Object? isEditing = freezed,
  }) {
    return _then(_EnvError(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      environments: freezed == environments
          ? _self._environments
          : environments // ignore: cast_nullable_to_non_nullable
              as List<Environment>?,
      selectedEnvironmentName: freezed == selectedEnvironmentName
          ? _self.selectedEnvironmentName
          : selectedEnvironmentName // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedEnvironment: freezed == selectedEnvironment
          ? _self.selectedEnvironment
          : selectedEnvironment // ignore: cast_nullable_to_non_nullable
              as Environment?,
      environmentValues: freezed == environmentValues
          ? _self._environmentValues
          : environmentValues // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      isEditing: freezed == isEditing
          ? _self.isEditing
          : isEditing // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }

  /// Create a copy of EnvironmentState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EnvironmentCopyWith<$Res>? get selectedEnvironment {
    if (_self.selectedEnvironment == null) {
      return null;
    }

    return $EnvironmentCopyWith<$Res>(_self.selectedEnvironment!, (value) {
      return _then(_self.copyWith(selectedEnvironment: value));
    });
  }
}

// dart format on
