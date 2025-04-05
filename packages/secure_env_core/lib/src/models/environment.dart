import 'package:freezed_annotation/freezed_annotation.dart';

part 'environment.freezed.dart';
part 'environment.g.dart';

@freezed
class Environment with _$Environment {
  const factory Environment({
    required String name,
    required String projectName,
    required Map<String, String> values,
    @Default({}) Map<String, bool> sensitiveKeys,
    String? description,
    DateTime? lastModified,
  }) = _Environment;

  factory Environment.fromJson(Map<String, dynamic> json) =>
      _$EnvironmentFromJson(json);
}
