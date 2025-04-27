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
  NotifierState get state;
  List<Project> get projects;
  Project? get selectedProject;
  bool get isEditing;
  String? get errorMessage;

  /// Create a copy of ProjectState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProjectStateCopyWith<ProjectState> get copyWith =>
      _$ProjectStateCopyWithImpl<ProjectState>(
          this as ProjectState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProjectState &&
            (identical(other.state, state) || other.state == state) &&
            const DeepCollectionEquality().equals(other.projects, projects) &&
            (identical(other.selectedProject, selectedProject) ||
                other.selectedProject == selectedProject) &&
            (identical(other.isEditing, isEditing) ||
                other.isEditing == isEditing) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      state,
      const DeepCollectionEquality().hash(projects),
      selectedProject,
      isEditing,
      errorMessage);

  @override
  String toString() {
    return 'ProjectState(state: $state, projects: $projects, selectedProject: $selectedProject, isEditing: $isEditing, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class $ProjectStateCopyWith<$Res> {
  factory $ProjectStateCopyWith(
          ProjectState value, $Res Function(ProjectState) _then) =
      _$ProjectStateCopyWithImpl;
  @useResult
  $Res call(
      {NotifierState state,
      List<Project> projects,
      Project? selectedProject,
      bool isEditing,
      String? errorMessage});

  $ProjectCopyWith<$Res>? get selectedProject;
}

/// @nodoc
class _$ProjectStateCopyWithImpl<$Res> implements $ProjectStateCopyWith<$Res> {
  _$ProjectStateCopyWithImpl(this._self, this._then);

  final ProjectState _self;
  final $Res Function(ProjectState) _then;

  /// Create a copy of ProjectState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? projects = null,
    Object? selectedProject = freezed,
    Object? isEditing = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_self.copyWith(
      state: null == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as NotifierState,
      projects: null == projects
          ? _self.projects
          : projects // ignore: cast_nullable_to_non_nullable
              as List<Project>,
      selectedProject: freezed == selectedProject
          ? _self.selectedProject
          : selectedProject // ignore: cast_nullable_to_non_nullable
              as Project?,
      isEditing: null == isEditing
          ? _self.isEditing
          : isEditing // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
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

class _ProjectState extends ProjectState {
  const _ProjectState(
      {this.state = NotifierState.initial,
      final List<Project> projects = const [],
      this.selectedProject,
      this.isEditing = false,
      this.errorMessage})
      : _projects = projects,
        super._();

  @override
  @JsonKey()
  final NotifierState state;
  final List<Project> _projects;
  @override
  @JsonKey()
  List<Project> get projects {
    if (_projects is EqualUnmodifiableListView) return _projects;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_projects);
  }

  @override
  final Project? selectedProject;
  @override
  @JsonKey()
  final bool isEditing;
  @override
  final String? errorMessage;

  /// Create a copy of ProjectState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProjectStateCopyWith<_ProjectState> get copyWith =>
      __$ProjectStateCopyWithImpl<_ProjectState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProjectState &&
            (identical(other.state, state) || other.state == state) &&
            const DeepCollectionEquality().equals(other._projects, _projects) &&
            (identical(other.selectedProject, selectedProject) ||
                other.selectedProject == selectedProject) &&
            (identical(other.isEditing, isEditing) ||
                other.isEditing == isEditing) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      state,
      const DeepCollectionEquality().hash(_projects),
      selectedProject,
      isEditing,
      errorMessage);

  @override
  String toString() {
    return 'ProjectState(state: $state, projects: $projects, selectedProject: $selectedProject, isEditing: $isEditing, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class _$ProjectStateCopyWith<$Res>
    implements $ProjectStateCopyWith<$Res> {
  factory _$ProjectStateCopyWith(
          _ProjectState value, $Res Function(_ProjectState) _then) =
      __$ProjectStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {NotifierState state,
      List<Project> projects,
      Project? selectedProject,
      bool isEditing,
      String? errorMessage});

  @override
  $ProjectCopyWith<$Res>? get selectedProject;
}

/// @nodoc
class __$ProjectStateCopyWithImpl<$Res>
    implements _$ProjectStateCopyWith<$Res> {
  __$ProjectStateCopyWithImpl(this._self, this._then);

  final _ProjectState _self;
  final $Res Function(_ProjectState) _then;

  /// Create a copy of ProjectState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? state = null,
    Object? projects = null,
    Object? selectedProject = freezed,
    Object? isEditing = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_ProjectState(
      state: null == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as NotifierState,
      projects: null == projects
          ? _self._projects
          : projects // ignore: cast_nullable_to_non_nullable
              as List<Project>,
      selectedProject: freezed == selectedProject
          ? _self.selectedProject
          : selectedProject // ignore: cast_nullable_to_non_nullable
              as Project?,
      isEditing: null == isEditing
          ? _self.isEditing
          : isEditing // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
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
  NotifierState get state;
  List<Environment> get environments;
  Map<String, String> get environmentValues;
  String? get errorMessage;

  /// Create a copy of EnvironmentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EnvironmentStateCopyWith<EnvironmentState> get copyWith =>
      _$EnvironmentStateCopyWithImpl<EnvironmentState>(
          this as EnvironmentState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EnvironmentState &&
            (identical(other.state, state) || other.state == state) &&
            const DeepCollectionEquality()
                .equals(other.environments, environments) &&
            const DeepCollectionEquality()
                .equals(other.environmentValues, environmentValues) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      state,
      const DeepCollectionEquality().hash(environments),
      const DeepCollectionEquality().hash(environmentValues),
      errorMessage);

  @override
  String toString() {
    return 'EnvironmentState(state: $state, environments: $environments, environmentValues: $environmentValues, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class $EnvironmentStateCopyWith<$Res> {
  factory $EnvironmentStateCopyWith(
          EnvironmentState value, $Res Function(EnvironmentState) _then) =
      _$EnvironmentStateCopyWithImpl;
  @useResult
  $Res call(
      {NotifierState state,
      List<Environment> environments,
      Map<String, String> environmentValues,
      String? errorMessage});
}

/// @nodoc
class _$EnvironmentStateCopyWithImpl<$Res>
    implements $EnvironmentStateCopyWith<$Res> {
  _$EnvironmentStateCopyWithImpl(this._self, this._then);

  final EnvironmentState _self;
  final $Res Function(EnvironmentState) _then;

  /// Create a copy of EnvironmentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? environments = null,
    Object? environmentValues = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_self.copyWith(
      state: null == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as NotifierState,
      environments: null == environments
          ? _self.environments
          : environments // ignore: cast_nullable_to_non_nullable
              as List<Environment>,
      environmentValues: null == environmentValues
          ? _self.environmentValues
          : environmentValues // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _EnvironmentState extends EnvironmentState {
  const _EnvironmentState(
      {this.state = NotifierState.initial,
      final List<Environment> environments = const [],
      final Map<String, String> environmentValues = const {},
      this.errorMessage})
      : _environments = environments,
        _environmentValues = environmentValues,
        super._();

  @override
  @JsonKey()
  final NotifierState state;
  final List<Environment> _environments;
  @override
  @JsonKey()
  List<Environment> get environments {
    if (_environments is EqualUnmodifiableListView) return _environments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_environments);
  }

  final Map<String, String> _environmentValues;
  @override
  @JsonKey()
  Map<String, String> get environmentValues {
    if (_environmentValues is EqualUnmodifiableMapView)
      return _environmentValues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_environmentValues);
  }

  @override
  final String? errorMessage;

  /// Create a copy of EnvironmentState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$EnvironmentStateCopyWith<_EnvironmentState> get copyWith =>
      __$EnvironmentStateCopyWithImpl<_EnvironmentState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _EnvironmentState &&
            (identical(other.state, state) || other.state == state) &&
            const DeepCollectionEquality()
                .equals(other._environments, _environments) &&
            const DeepCollectionEquality()
                .equals(other._environmentValues, _environmentValues) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      state,
      const DeepCollectionEquality().hash(_environments),
      const DeepCollectionEquality().hash(_environmentValues),
      errorMessage);

  @override
  String toString() {
    return 'EnvironmentState(state: $state, environments: $environments, environmentValues: $environmentValues, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class _$EnvironmentStateCopyWith<$Res>
    implements $EnvironmentStateCopyWith<$Res> {
  factory _$EnvironmentStateCopyWith(
          _EnvironmentState value, $Res Function(_EnvironmentState) _then) =
      __$EnvironmentStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {NotifierState state,
      List<Environment> environments,
      Map<String, String> environmentValues,
      String? errorMessage});
}

/// @nodoc
class __$EnvironmentStateCopyWithImpl<$Res>
    implements _$EnvironmentStateCopyWith<$Res> {
  __$EnvironmentStateCopyWithImpl(this._self, this._then);

  final _EnvironmentState _self;
  final $Res Function(_EnvironmentState) _then;

  /// Create a copy of EnvironmentState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? state = null,
    Object? environments = null,
    Object? environmentValues = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_EnvironmentState(
      state: null == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as NotifierState,
      environments: null == environments
          ? _self._environments
          : environments // ignore: cast_nullable_to_non_nullable
              as List<Environment>,
      environmentValues: null == environmentValues
          ? _self._environmentValues
          : environmentValues // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
