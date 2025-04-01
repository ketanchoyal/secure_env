import 'dart:io';

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
      return config;
    }

    final lines = await File(filePath).readAsLines();

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
