// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$projectsNotifierHash() => r'c9d8029e05a0667fddf4f835f09415a78f66be1e';

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
    r'2b82fc919e2fe43dbd4ec338c84cc2bc6bbaa54f';

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
