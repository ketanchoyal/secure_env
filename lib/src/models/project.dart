/// Represents a project in the Secure Env application
class Project {
  final String name;
  final String path;
  final String? description;
  late final List<String> environments;
  late final Map<String, dynamic> config;
  late final DateTime createdAt;
  late final DateTime updatedAt;

  Project({
    required this.name,
    required this.path,
    this.description,
    List<String>? environments,
    Map<String, dynamic>? config,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    this.environments = environments ?? [];
    this.config = config ?? {};
    this.createdAt = createdAt ?? DateTime.now();
    this.updatedAt = updatedAt ?? DateTime.now();
  }

  /// Create a Project from JSON
  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      name: json['name'] as String,
      path: json['path'] as String,
      description: json['description'] as String?,
      environments: (json['environments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      config: json['config'] as Map<String, dynamic>? ?? {},
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convert Project to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      if (description != null) 'description': description,
      'environments': environments,
      'config': config,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
