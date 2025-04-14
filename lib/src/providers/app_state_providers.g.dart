// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$projectsNotifierHash() => r'93f306fa1ea4fd99ca5bc214de5f547e4a94dd80';

/// Provider for managing projects state
///
/// This provider is just for fetching projects and not for managing them.
/// For managing projects, use [ProjectNotifier].
///
/// Copied from [ProjectsNotifier].
@ProviderFor(ProjectsNotifier)
final projectsNotifierProvider =
    NotifierProvider<ProjectsNotifier, ProjectState>.internal(
  ProjectsNotifier.new,
  name: r'projectsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$projectsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProjectsNotifier = Notifier<ProjectState>;
String _$environmentsNotifierHash() =>
    r'4bfecfc3528a0e1c7aebccc390e1a7a2a01f4561';

/// Provider for managing environments state
///
/// This provider is just for fetching environments and not for managing them.
/// For managing environments, use [EnvironmentNotifier].
///
/// Copied from [EnvironmentsNotifier].
@ProviderFor(EnvironmentsNotifier)
final environmentsNotifierProvider =
    NotifierProvider<EnvironmentsNotifier, EnvironmentState>.internal(
  EnvironmentsNotifier.new,
  name: r'environmentsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$environmentsNotifierHash,
  dependencies: <ProviderOrFamily>[projectsNotifierProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    projectsNotifierProvider,
    ...?projectsNotifierProvider.allTransitiveDependencies
  },
);

typedef _$EnvironmentsNotifier = Notifier<EnvironmentState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
