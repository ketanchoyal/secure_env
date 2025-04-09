import 'package:secure_env_core/src/models/project_status.dart';

/// Represents the essential metadata of a project stored in the central registry.
class ProjectMetadata {
  /// The unique name of the project.
  final String name;

  /// The absolute base path of the project directory.
  final String basePath;

  /// The date and time when the project was first registered.
  final DateTime createdAt;

  /// The date and time when the project metadata was last updated.
  final DateTime updatedAt;

  /// The current status of the project (e.g., active, archived).
  final ProjectStatus status;

  ProjectMetadata({
    required this.name,
    required this.basePath,
    required this.createdAt,
    required this.updatedAt,
    this.status = ProjectStatus.active,
  });

  /// Creates a copy of this metadata but with the given fields replaced with the new values.
  ProjectMetadata copyWith({
    String? name,
    String? basePath,
    DateTime? createdAt,
    DateTime? updatedAt,
    ProjectStatus? status,
  }) {
    return ProjectMetadata(
      name: name ?? this.name,
      basePath: basePath ?? this.basePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
    );
  }

  /// Creates [ProjectMetadata] from a JSON map.
  factory ProjectMetadata.fromJson(Map<String, dynamic> json) {
    return ProjectMetadata(
      name: json['name'] as String,
      basePath: json['basePath'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      status: ProjectStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => ProjectStatus.active,
      ),
    );
  }

  /// Converts this [ProjectMetadata] instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'basePath': basePath,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'status': status.toString(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectMetadata &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          basePath == other.basePath;

  @override
  int get hashCode => name.hashCode ^ basePath.hashCode;

  @override
  String toString() {
    return 'ProjectMetadata{name: $name, basePath: $basePath, status: $status}';
  }
}
