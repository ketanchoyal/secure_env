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
  const EnvironmentStateLoading(
      {final List<Environment> environments = const [],
      this.selectedEnvironment,
      final Map<String, String> environmentValues = const {},
      this.isEditing = false})
      : _environments = environments,
        _environmentValues = environmentValues;

  final List<Environment> _environments;
  @JsonKey()
  List<Environment> get environments {
    if (_environments is EqualUnmodifiableListView) return _environments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_environments);
  }

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
  $EnvironmentStateLoadingCopyWith<EnvironmentStateLoading> get copyWith =>
      _$EnvironmentStateLoadingCopyWithImpl<EnvironmentStateLoading>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EnvironmentStateLoading &&
            const DeepCollectionEquality()
                .equals(other._environments, _environments) &&
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
      selectedEnvironment,
      const DeepCollectionEquality().hash(_environmentValues),
      isEditing);

  @override
  String toString() {
    return 'EnvironmentState.loading(environments: $environments, selectedEnvironment: $selectedEnvironment, environmentValues: $environmentValues, isEditing: $isEditing)';
  }
}

/// @nodoc
abstract mixin class $EnvironmentStateLoadingCopyWith<$Res>
    implements $EnvironmentStateCopyWith<$Res> {
  factory $EnvironmentStateLoadingCopyWith(EnvironmentStateLoading value,
          $Res Function(EnvironmentStateLoading) _then) =
      _$EnvironmentStateLoadingCopyWithImpl;
  @useResult
  $Res call(
      {List<Environment> environments,
      Environment? selectedEnvironment,
      Map<String, String> environmentValues,
      bool isEditing});

  $EnvironmentCopyWith<$Res>? get selectedEnvironment;
}

/// @nodoc
class _$EnvironmentStateLoadingCopyWithImpl<$Res>
    implements $EnvironmentStateLoadingCopyWith<$Res> {
  _$EnvironmentStateLoadingCopyWithImpl(this._self, this._then);

  final EnvironmentStateLoading _self;
  final $Res Function(EnvironmentStateLoading) _then;

  /// Create a copy of EnvironmentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? environments = null,
    Object? selectedEnvironment = freezed,
    Object? environmentValues = null,
    Object? isEditing = null,
  }) {
    return _then(EnvironmentStateLoading(
      environments: null == environments
          ? _self._environments
          : environments // ignore: cast_nullable_to_non_nullable
              as List<Environment>,
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

class EnvironmentStateLoaded implements EnvironmentState {
  const EnvironmentStateLoaded(
      {required final List<Environment> environments,
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
      selectedEnvironment,
      const DeepCollectionEquality().hash(_environmentValues),
      isEditing);

  @override
  String toString() {
    return 'EnvironmentState.loaded(environments: $environments, selectedEnvironment: $selectedEnvironment, environmentValues: $environmentValues, isEditing: $isEditing)';
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
    Object? selectedEnvironment = freezed,
    Object? environmentValues = null,
    Object? isEditing = null,
  }) {
    return _then(EnvironmentStateLoaded(
      environments: null == environments
          ? _self._environments
          : environments // ignore: cast_nullable_to_non_nullable
              as List<Environment>,
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
      selectedEnvironment,
      const DeepCollectionEquality().hash(_environmentValues),
      isEditing);

  @override
  String toString() {
    return 'EnvironmentState.error(message: $message, environments: $environments, selectedEnvironment: $selectedEnvironment, environmentValues: $environmentValues, isEditing: $isEditing)';
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
