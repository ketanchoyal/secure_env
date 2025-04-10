import 'dart:io';

import 'package:secure_env_core/secure_env_core.dart';
import 'package:secure_env_core/src/exceptions/file_not_found_exception.dart';

/// Service for formatting .env files
class EnvService {
  /// Converts a map of key-value pairs to .env format
  String toEnv(Map<String, String> config) {
    final buffer = StringBuffer();

    for (final entry in config.entries) {
      final value = _formatValue(entry.value);
      buffer.writeln('${entry.key}=$value');
    }

    return buffer.toString();
  }

  /// Formats a value for .env file
  /// Handles spaces, quotes, and special characters
  String _formatValue(String value) {
    if (value.contains(' ') || value.contains('#')) {
      // Quote values containing spaces or comments
      return '"${value.replaceAll('"', r'\"')}"';
    }
    return value;
  }

  /// Writes the .env file to disk
  Future<void> writeEnvFile(
    String filePath,
    Map<String, String> config,
  ) async {
    final content = toEnv(config);
    await File(filePath).writeAsString(content);
  }

  /// Reads an existing .env file
  Future<Map<String, String>> readEnvFile(String filePath) async {
    final config = <String, String>{};

    if (!await File(filePath).exists()) {
      throw FileNotFoundException('File not found: $filePath');
    }

    final lines = await File(filePath).readAsLines();

    //Check if file have jsut comments
    if (lines.isEmpty ||
        lines.every(
            (line) => line.trim().isEmpty || line.trim().startsWith('#'))) {
      throw ValidationException('Empty .env file: $filePath');
    }

    for (final line in lines) {
      final trimmedLine = line.trim();
      if (trimmedLine.isEmpty || trimmedLine.startsWith('#')) {
        continue;
      }

      final parts = trimmedLine.split('=');
      if (parts.length < 2) continue;

      final key = parts[0].trim();
      final value = parts.sublist(1).join('=').trim();

      // Remove surrounding quotes if present
      final cleanValue = _cleanValue(value);
      config[key] = cleanValue;
    }

    validateSecrets(config);
    return config;
  }

  /// Cleans a value by removing surrounding quotes and unescaping
  String _cleanValue(String value) {
    if ((value.startsWith('"') && value.endsWith('"')) ||
        (value.startsWith("'") && value.endsWith("'"))) {
      // Remove surrounding quotes and unescape
      return value
          .substring(1, value.length - 1)
          .replaceAll(r'\"', '"')
          .replaceAll(r"\'", "'");
    }
    return value;
  }
}
