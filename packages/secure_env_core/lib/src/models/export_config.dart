/// Model representing configuration for exporting environment files.
library;

import 'package:json_annotation/json_annotation.dart';
import 'package:path/path.dart' as path;

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

  factory ExportConfig.fromJson(Map<String, dynamic> json) =>
      _$ExportConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ExportConfigToJson(this);

  ExportConfig copyWith({
    bool? exportXcconfig,
    String? xcconfigPath,
    String? xcconfigFileName,
    bool? exportEnv,
    String? envPath,
    String? envFileName,
    bool? exportProperties,
    String? propertiesPath,
    String? propertiesFileName,
  }) {
    return ExportConfig(
      exportXcconfig: exportXcconfig ?? this.exportXcconfig,
      xcconfigPath: xcconfigPath ?? this.xcconfigPath,
      xcconfigFileName: xcconfigFileName ?? this.xcconfigFileName,
      exportEnv: exportEnv ?? this.exportEnv,
      envPath: envPath ?? this.envPath,
      envFileName: envFileName ?? this.envFileName,
      exportProperties: exportProperties ?? this.exportProperties,
      propertiesPath: propertiesPath ?? this.propertiesPath,
      propertiesFileName: propertiesFileName ?? this.propertiesFileName,
    );
  }
}

extension ExportConfigExtension on ExportConfig {
  String? get xcconfigFilePath => exportXcconfig
      ? path.join(xcconfigPath, '$xcconfigFileName.xcconfig')
      : null;

  String? get envFilePath =>
      exportEnv ? path.join(envPath, '$envFileName.env') : null;

  String? get propertiesFilePath => exportProperties
      ? path.join(propertiesPath, '$propertiesFileName.properties')
      : null;
}
