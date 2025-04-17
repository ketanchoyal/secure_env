/// Model representing configuration for exporting environment files.
import 'package:json_annotation/json_annotation.dart';

part 'export_config.g.dart';

/// Model representing configuration for exporting environment files.
@JsonSerializable()
class ExportConfig {
  /// Toggle to export .xcconfig file
  final bool exportXcconfig;

  /// Path where .xcconfig file should be exported
  final String xcconfigPath;

  /// Filename (without extension) for .xcconfig
  final String xcconfigFileName;

  /// Toggle to export .env file
  final bool exportEnv;

  /// Path where .env file should be exported
  final String envPath;

  /// Filename (without extension) for .env
  final String envFileName;

  /// Toggle to export .properties file
  final bool exportProperties;

  /// Path where .properties file should be exported
  final String propertiesPath;

  /// Filename (without extension) for .properties
  final String propertiesFileName;

  const ExportConfig({
    this.exportXcconfig = false,
    this.xcconfigPath = '',
    this.xcconfigFileName = '',
    this.exportEnv = false,
    this.envPath = '',
    this.envFileName = '',
    this.exportProperties = false,
    this.propertiesPath = '',
    this.propertiesFileName = '',
  });

  factory ExportConfig.fromJson(Map<String, dynamic> json) => _$ExportConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ExportConfigToJson(this);
}
