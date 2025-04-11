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

class ProjectStateInitial implements ProjectState {
  const ProjectStateInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ProjectStateInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ProjectState.initial()';
  }
}

/// @nodoc

class ProjectStateLoading implements ProjectState {
  const ProjectStateLoading(
      {final List<Project> projects = const [], this.selectedProject})
      : _projects = projects;

  final List<Project> _projects;
  @JsonKey()
  List<Project> get projects {
    if (_projects is EqualUnmodifiableListView) return _projects;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_projects);
  }

  final Project? selectedProject;

  /// Create a copy of ProjectState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProjectStateLoadingCopyWith<ProjectStateLoading> get copyWith =>
      _$ProjectStateLoadingCopyWithImpl<ProjectStateLoading>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProjectStateLoading &&
            const DeepCollectionEquality().equals(other._projects, _projects) &&
            (identical(other.selectedProject, selectedProject) ||
                other.selectedProject == selectedProject));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_projects), selectedProject);

  @override
  String toString() {
    return 'ProjectState.loading(projects: $projects, selectedProject: $selectedProject)';
  }
}

/// @nodoc
abstract mixin class $ProjectStateLoadingCopyWith<$Res>
    implements $ProjectStateCopyWith<$Res> {
  factory $ProjectStateLoadingCopyWith(
          ProjectStateLoading value, $Res Function(ProjectStateLoading) _then) =
      _$ProjectStateLoadingCopyWithImpl;
  @useResult
  $Res call({List<Project> projects, Project? selectedProject});

  $ProjectCopyWith<$Res>? get selectedProject;
}

/// @nodoc
class _$ProjectStateLoadingCopyWithImpl<$Res>
    implements $ProjectStateLoadingCopyWith<$Res> {
  _$ProjectStateLoadingCopyWithImpl(this._self, this._then);

  final ProjectStateLoading _self;
  final $Res Function(ProjectStateLoading) _then;

  /// Create a copy of ProjectState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? projects = null,
    Object? selectedProject = freezed,
  }) {
    return _then(ProjectStateLoading(
      projects: null == projects
          ? _self._projects
          : projects // ignore: cast_nullable_to_non_nullable
              as List<Project>,
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

class ProjectStateLoaded implements ProjectState {
  const ProjectStateLoaded(
      {required final List<Project> projects, this.selectedProject})
      : _projects = projects;

  final List<Project> _projects;
  List<Project> get projects {
    if (_projects is EqualUnmodifiableListView) return _projects;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_projects);
  }

  final Project? selectedProject;

  /// Create a copy of ProjectState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProjectStateLoadedCopyWith<ProjectStateLoaded> get copyWith =>
      _$ProjectStateLoadedCopyWithImpl<ProjectStateLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProjectStateLoaded &&
            const DeepCollectionEquality().equals(other._projects, _projects) &&
            (identical(other.selectedProject, selectedProject) ||
                other.selectedProject == selectedProject));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_projects), selectedProject);

  @override
  String toString() {
    return 'ProjectState.loaded(projects: $projects, selectedProject: $selectedProject)';
  }
}

/// @nodoc
abstract mixin class $ProjectStateLoadedCopyWith<$Res>
    implements $ProjectStateCopyWith<$Res> {
  factory $ProjectStateLoadedCopyWith(
          ProjectStateLoaded value, $Res Function(ProjectStateLoaded) _then) =
      _$ProjectStateLoadedCopyWithImpl;
  @useResult
  $Res call({List<Project> projects, Project? selectedProject});

  $ProjectCopyWith<$Res>? get selectedProject;
}

/// @nodoc
class _$ProjectStateLoadedCopyWithImpl<$Res>
    implements $ProjectStateLoadedCopyWith<$Res> {
  _$ProjectStateLoadedCopyWithImpl(this._self, this._then);

  final ProjectStateLoaded _self;
  final $Res Function(ProjectStateLoaded) _then;

  /// Create a copy of ProjectState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? projects = null,
    Object? selectedProject = freezed,
  }) {
    return _then(ProjectStateLoaded(
      projects: null == projects
          ? _self._projects
          : projects // ignore: cast_nullable_to_non_nullable
              as List<Project>,
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

class ProjectStateError implements ProjectState {
  const ProjectStateError(
      {required this.message,
      final List<Project>? projects,
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

  final Project? selectedProject;

  /// Create a copy of ProjectState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProjectStateErrorCopyWith<ProjectStateError> get copyWith =>
      _$ProjectStateErrorCopyWithImpl<ProjectStateError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProjectStateError &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other._projects, _projects) &&
            (identical(other.selectedProject, selectedProject) ||
                other.selectedProject == selectedProject));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message,
      const DeepCollectionEquality().hash(_projects), selectedProject);

  @override
  String toString() {
    return 'ProjectState.error(message: $message, projects: $projects, selectedProject: $selectedProject)';
  }
}

/// @nodoc
abstract mixin class $ProjectStateErrorCopyWith<$Res>
    implements $ProjectStateCopyWith<$Res> {
  factory $ProjectStateErrorCopyWith(
          ProjectStateError value, $Res Function(ProjectStateError) _then) =
      _$ProjectStateErrorCopyWithImpl;
  @useResult
  $Res call(
      {String message, List<Project>? projects, Project? selectedProject});

  $ProjectCopyWith<$Res>? get selectedProject;
}

/// @nodoc
class _$ProjectStateErrorCopyWithImpl<$Res>
    implements $ProjectStateErrorCopyWith<$Res> {
  _$ProjectStateErrorCopyWithImpl(this._self, this._then);

  final ProjectStateError _self;
  final $Res Function(ProjectStateError) _then;

  /// Create a copy of ProjectState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
    Object? projects = freezed,
    Object? selectedProject = freezed,
  }) {
    return _then(ProjectStateError(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      projects: freezed == projects
          ? _self._projects
          : projects // ignore: cast_nullable_to_non_nullable
              as List<Project>?,
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

class EnvironmentStateInitial implements EnvironmentState {
  const EnvironmentStateInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is EnvironmentStateInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'EnvironmentState.initial()';
  }
}

/// @nodoc

class EnvironmentStateLoading implements EnvironmentState {
  const EnvironmentStateLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is EnvironmentStateLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'EnvironmentState.loading()';
  }
}

/// @nodoc

class EnvironmentStateLoaded implements EnvironmentState {
  const EnvironmentStateLoaded(
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
  $EnvironmentStateLoadedCopyWith<EnvironmentStateLoaded> get copyWith =>
      _$EnvironmentStateLoadedCopyWithImpl<EnvironmentStateLoaded>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EnvironmentStateLoaded &&
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
abstract mixin class $EnvironmentStateLoadedCopyWith<$Res>
    implements $EnvironmentStateCopyWith<$Res> {
  factory $EnvironmentStateLoadedCopyWith(EnvironmentStateLoaded value,
          $Res Function(EnvironmentStateLoaded) _then) =
      _$EnvironmentStateLoadedCopyWithImpl;
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
class _$EnvironmentStateLoadedCopyWithImpl<$Res>
    implements $EnvironmentStateLoadedCopyWith<$Res> {
  _$EnvironmentStateLoadedCopyWithImpl(this._self, this._then);

  final EnvironmentStateLoaded _self;
  final $Res Function(EnvironmentStateLoaded) _then;

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
    return _then(EnvironmentStateLoaded(
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

class EnvironmentStateError implements EnvironmentState {
  const EnvironmentStateError(
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
  $EnvironmentStateErrorCopyWith<EnvironmentStateError> get copyWith =>
      _$EnvironmentStateErrorCopyWithImpl<EnvironmentStateError>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EnvironmentStateError &&
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
abstract mixin class $EnvironmentStateErrorCopyWith<$Res>
    implements $EnvironmentStateCopyWith<$Res> {
  factory $EnvironmentStateErrorCopyWith(EnvironmentStateError value,
          $Res Function(EnvironmentStateError) _then) =
      _$EnvironmentStateErrorCopyWithImpl;
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
class _$EnvironmentStateErrorCopyWithImpl<$Res>
    implements $EnvironmentStateErrorCopyWith<$Res> {
  _$EnvironmentStateErrorCopyWithImpl(this._self, this._then);

  final EnvironmentStateError _self;
  final $Res Function(EnvironmentStateError) _then;

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
    return _then(EnvironmentStateError(
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
