import 'dart:io';

class PropertiesService {
  /// Converts a map of key-value pairs to .properties format
  String toProperties(
    Map<String, String> config, {
    bool androidStyle = false,
  }) {
    final buffer = StringBuffer();
    
    for (final entry in config.entries) {
      final key = _formatKey(entry.key, androidStyle: androidStyle);
      final value = _formatValue(entry.value);
      buffer.writeln('$key=$value');
    }
    
    return buffer.toString();
  }

  /// Formats a key for .properties file
  /// Converts UPPERCASE to lowercase.dot.case if androidStyle is true
  String _formatKey(String key, {bool androidStyle = false}) {
    if (!androidStyle) return key;

    // Convert HELLO_WORLD to hello.world
    return key.toLowerCase().replaceAll('_', '.');
  }

  /// Formats a value for .properties file
  String _formatValue(String value) {
    // Escape special characters
    return value
        .replaceAll('\\', '\\\\')
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '\\r')
        .replaceAll('\t', '\\t');
  }

  /// Writes the .properties file to disk
  Future<void> writePropertiesFile(
    String filePath,
    Map<String, String> config, {
    bool androidStyle = false,
  }) async {
    final content = toProperties(config, androidStyle: androidStyle);
    await File(filePath).writeAsString(content);
  }

  /// Reads an existing .properties file
  Future<Map<String, String>> readPropertiesFile(
    String filePath, {
    bool androidStyle = false,
  }) async {
    final config = <String, String>{};
    
    if (!await File(filePath).exists()) {
      return config;
    }

    final lines = await File(filePath).readAsLines();
    String? continuationLine;
    
    for (final line in lines) {
      final trimmedLine = line.trim();
      if (trimmedLine.isEmpty || trimmedLine.startsWith('#')) {
        continue;
      }

      // Handle line continuation
      if (continuationLine != null) {
        continuationLine += trimmedLine;
      } else {
        continuationLine = trimmedLine;
      }

      // Check if line ends with backslash (continuation)
      if (continuationLine.endsWith('\\')) {
        continuationLine = continuationLine.substring(
          0,
          continuationLine.length - 1,
        );
        continue;
      }

      // Process the complete line
      final parts = continuationLine.split('=');
      if (parts.length < 2) {
        continuationLine = null;
        continue;
      }

      final key = parts[0].trim();
      final value = parts.sublist(1).join('=').trim();
      
      // Unescape special characters
      final cleanValue = _unescapeValue(value);
      config[androidStyle ? key.toLowerCase() : key] = cleanValue;
      continuationLine = null;
    }
    
    return config;
  }

  /// Unescapes special characters in value
  String _unescapeValue(String value) {
    return value
        .replaceAll('\\\\', '\\')
        .replaceAll('\\n', '\n')
        .replaceAll('\\r', '\r')
        .replaceAll('\\t', '\t');
  }
}
