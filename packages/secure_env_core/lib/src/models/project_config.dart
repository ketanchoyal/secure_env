import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_config.freezed.dart';
part 'project_config.g.dart';

/// Defines project-level settings for auto-sync behavior
/// and conflict resolution policy.
@freezed
abstract class ProjectConfig with _$ProjectConfig {
  const factory ProjectConfig({
    /// Master switch for auto-syncing env files.
    @Default(false) bool autoSync,

    /// Policy when external modifications are detected.
    @Default(ConflictPolicy.warnAndSkip) ConflictPolicy conflictPolicy,
  }) = _ProjectConfig;

  factory ProjectConfig.fromJson(Map<String, dynamic> json) =>
      _$ProjectConfigFromJson(json);
}

/// Conflict resolution policies for file sync
enum ConflictPolicy { warnAndSkip, forceOverwrite }
