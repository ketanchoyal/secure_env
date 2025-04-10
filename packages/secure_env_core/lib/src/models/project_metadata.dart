import 'package:secure_env_core/src/models/project_status.dart';

/// Represents the essential metadata of a project stored in the central registry.
class ProjectMetadata {
  /// The unique name of the project.
  final String name;

  /// The unique identifier for the project.
  final String id;

  /// The absolute base path of the project directory.
  final String basePath;

  /// The date and time when the project was first registered.
  final DateTime createdAt;

  /// The date and time when the project metadata was last updated.
  final DateTime updatedAt;

  /// The current status of the project (e.g., active, archived).
  final ProjectStatus status;

  final Map<String, dynamic> config;

  ProjectMetadata({
    required this.name,
    required this.basePath,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.config = const {},
    this.status = ProjectStatus.active,
  });

  /// Creates a copy of this metadata but with the given fields replaced with the new values.
  ProjectMetadata copyWith({
    String? name,
    String? basePath,
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    ProjectStatus? status,
    Map<String, dynamic>? config,
  }) {
    return ProjectMetadata(
      name: name ?? this.name,
      basePath: basePath ?? this.basePath,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      config: config ?? this.config,
    );
  }

  /// Creates [ProjectMetadata] from a JSON map.
  factory ProjectMetadata.fromJson(Map<String, dynamic> json) {
    return ProjectMetadata(
      id: json['id'] as String,
      name: json['name'] as String,
      basePath: json['basePath'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      config: json['config'] as Map<String, dynamic>? ?? const {},
      status: ProjectStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => ProjectStatus.active,
      ),
    );
  }

  /// Converts this [ProjectMetadata] instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'basePath': basePath,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'status': status.toString(),
      'config': config,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectMetadata &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          basePath == other.basePath &&
          id == other.id &&
          config == other.config;

  @override
  int get hashCode => name.hashCode ^ basePath.hashCode;

  @override
  String toString() {
    return 'ProjectMetadata{name: $name, basePath: $basePath, status: $status, id: $id, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
