import 'package:freezed_annotation/freezed_annotation.dart';
import 'project_status.dart';

part 'project.freezed.dart';
part 'project.g.dart';

@freezed
abstract class Project with _$Project {
  const factory Project({
    /// Unique name of the project
    required String name,

    /// Base directory path where project files are stored
    required String path,

    /// Optional description of the project
    String? description,

    /// List of environment names in this project
    @Default([]) List<String> environments,

    /// Project configuration
    @Default({}) Map<String, dynamic> config,

    /// Project status (active/archived/markedForDeletion)
    @Default(ProjectStatus.active) ProjectStatus status,

    /// Project metadata for custom tags and attributes
    @Default({}) Map<String, String> metadata,

    /// Project creation timestamp
    required DateTime createdAt,

    /// Project last modified timestamp
    required DateTime updatedAt,
  }) = _Project;

  /// Create a new project with current timestamps
  factory Project.create({
    required String name,
    required String path,
    String? description,
    Map<String, String>? metadata,
  }) {
    final now = DateTime.now();
    return Project(
      name: name,
      path: path,
      description: description,
      metadata: metadata ?? {},
      environments: [],
      config: {},
      status: ProjectStatus.active,
      createdAt: now,
      updatedAt: now,
    );
  }

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  Map<String, dynamic> toJson() => {
        'name': name,
        'path': path,
        'description': description,
        'environments': environments,
        'config': config,
        'status': status.toString().split('.').last,
        'metadata': metadata,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}
