import 'package:freezed_annotation/freezed_annotation.dart';
import 'export_config.dart';

part 'environment.freezed.dart';
part 'environment.g.dart';

@freezed
abstract class Environment with _$Environment {
  const factory Environment({
    required String name,
    required Map<String, String> values,
    String? description,
    DateTime? lastModified,
    required DateTime createdAt,
    @Default({}) Map<String, bool> sensitiveKeys,
    @Default({}) Map<String, String> metadata,
    @Default(ExportConfig()) ExportConfig exportConfig,
    @Default({}) Map<String, String> lastFileChecksums, // tracks per-format file checksums for auto-sync
  }) = _Environment;

  factory Environment.fromJson(Map<String, dynamic> json) =>
      _$EnvironmentFromJson(json);
}
