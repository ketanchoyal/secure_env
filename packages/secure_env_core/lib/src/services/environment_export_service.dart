import 'dart:io';
import 'package:path/path.dart' as path;
import '../models/export_config.dart';

/// Service to export environment variables to various config formats: .xcconfig, .env, .properties
class EnvironmentExportService {
  final ExportConfig config;

  EnvironmentExportService(this.config);

  /// Converts [env] to .xcconfig format string (e.g., FOO = bar;)
  String toXcconfig(Map<String, String> env) {
    return env.entries.map((e) => '${e.key} = ${e.value};').join('\n');
  }

  /// Converts [env] to .env format string (e.g., FOO=bar)
  String toDotenv(Map<String, String> env) {
    return env.entries.map((e) => '${e.key}=${e.value}').join('\n');
  }

  /// Converts [env] to .properties format string (e.g., foo=bar)
  String toProperties(Map<String, String> env) {
    return env.entries.map((e) => '${e.key}=${e.value}').join('\n');
  }

  /// Writes the formatted string to a file at [filePath]
  Future<void> exportToFile(String content, String filePath) async {
    final file = File(filePath);
    await file.writeAsString(content);
  }

  /// Exports [env] to the configured file formats based on ExportConfig.
  Future<void> export(Map<String, String> env) async {
    if (config.exportXcconfig) {
      final content = toXcconfig(env);
      final filePath = path.join(config.xcconfigPath, '${config.xcconfigFileName}.xcconfig');
      await File(filePath).parent.create(recursive: true);
      await exportToFile(content, filePath);
    }
    if (config.exportEnv) {
      final content = toDotenv(env);
      final filePath = path.join(config.envPath, '${config.envFileName}.env');
      await File(filePath).parent.create(recursive: true);
      await exportToFile(content, filePath);
    }
    if (config.exportProperties) {
      final content = toProperties(env);
      final filePath = path.join(config.propertiesPath, '${config.propertiesFileName}.properties');
      await File(filePath).parent.create(recursive: true);
      await exportToFile(content, filePath);
    }
  }
}
