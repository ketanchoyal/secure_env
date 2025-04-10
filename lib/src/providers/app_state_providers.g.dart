// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$projectsNotifierHash() => r'4ceb8f165dfa9085ff4c1a6cd8d4e3728b6cd3f3';

/// Provider for managing projects state
///
/// Copied from [ProjectsNotifier].
@ProviderFor(ProjectsNotifier)
final projectsNotifierProvider =
    AutoDisposeNotifierProvider<ProjectsNotifier, ProjectState>.internal(
  ProjectsNotifier.new,
  name: r'projectsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$projectsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProjectsNotifier = AutoDisposeNotifier<ProjectState>;
String _$environmentsNotifierHash() =>
    r'eace48e73c7b6940fb0ca15148e38b21a9c09240';

/// Provider for managing environments state
///
/// Copied from [EnvironmentsNotifier].
@ProviderFor(EnvironmentsNotifier)
final environmentsNotifierProvider = AutoDisposeNotifierProvider<
    EnvironmentsNotifier, EnvironmentState>.internal(
  EnvironmentsNotifier.new,
  name: r'environmentsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$environmentsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EnvironmentsNotifier = AutoDisposeNotifier<EnvironmentState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
