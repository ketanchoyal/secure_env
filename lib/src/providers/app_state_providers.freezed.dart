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
  String? get selectedProjectId;
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
            (identical(other.selectedProjectId, selectedProjectId) ||
                other.selectedProjectId == selectedProjectId) &&
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
      selectedProjectId,
      isEditing,
      errorMessage);

  @override
  String toString() {
    return 'ProjectState(state: $state, projects: $projects, selectedProjectId: $selectedProjectId, isEditing: $isEditing, errorMessage: $errorMessage)';
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
      String? selectedProjectId,
      bool isEditing,
      String? errorMessage});
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
    Object? selectedProjectId = freezed,
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
      selectedProjectId: freezed == selectedProjectId
          ? _self.selectedProjectId
          : selectedProjectId // ignore: cast_nullable_to_non_nullable
              as String?,
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
}

/// @nodoc

class _ProjectState extends ProjectState {
  const _ProjectState(
      {this.state = NotifierState.initial,
      final List<Project> projects = const [],
      this.selectedProjectId,
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
  final String? selectedProjectId;
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
            (identical(other.selectedProjectId, selectedProjectId) ||
                other.selectedProjectId == selectedProjectId) &&
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
      selectedProjectId,
      isEditing,
      errorMessage);

  @override
  String toString() {
    return 'ProjectState(state: $state, projects: $projects, selectedProjectId: $selectedProjectId, isEditing: $isEditing, errorMessage: $errorMessage)';
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
      String? selectedProjectId,
      bool isEditing,
      String? errorMessage});
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
    Object? selectedProjectId = freezed,
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
      selectedProjectId: freezed == selectedProjectId
          ? _self.selectedProjectId
          : selectedProjectId // ignore: cast_nullable_to_non_nullable
              as String?,
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
}

/// @nodoc
mixin _$EnvironmentState {
  NotifierState get state;
  List<Environment> get environments;
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
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, state,
      const DeepCollectionEquality().hash(environments), errorMessage);

  @override
  String toString() {
    return 'EnvironmentState(state: $state, environments: $environments, errorMessage: $errorMessage)';
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
      this.errorMessage})
      : _environments = environments,
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
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, state,
      const DeepCollectionEquality().hash(_environments), errorMessage);

  @override
  String toString() {
    return 'EnvironmentState(state: $state, environments: $environments, errorMessage: $errorMessage)';
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
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
