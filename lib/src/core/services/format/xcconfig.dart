import 'dart:io';
import 'package:path/path.dart' as path;

class XConfigService {
  /// Reads an xcconfig file and returns a map of key-value pairs
  Future<Map<String, String>> readXConfig(
    String filePath, {
    Set<String>? processedFiles,
  }) async {
    processedFiles ??= {};
    
    if (processedFiles.contains(filePath)) {
      return {};
    }
    
    processedFiles.add(filePath);
    final config = <String, String>{};
    
    if (!await File(filePath).exists()) {
      print('Warning: File $filePath not found');
      return config;
    }
    
    final directory = path.dirname(filePath);
    final lines = await File(filePath).readAsLines();
    
    for (final line in lines) {
      final trimmedLine = line.trim();
      if (trimmedLine.isEmpty || trimmedLine.startsWith('//')) {
        continue;
      }
      
      if (trimmedLine.startsWith('#include')) {
        // Handle includes
        final includeFile = trimmedLine.split('"')[1];
        final includePath = path.join(directory, includeFile);
        final includedConfig = await readXConfig(
          includePath,
          processedFiles: processedFiles,
        );
        config.addAll(includedConfig);
      } else if (trimmedLine.contains('=')) {
        // Handle key-value pairs
        final parts = trimmedLine.split('=');
        final key = parts[0].trim();
        final value = parts[1].trim();
        // Remove any ${PROJECT_DIR} or similar variables
        final cleanValue = value.replaceAll(RegExp(r'\${.*?}'), '').trim();
        config[key] = cleanValue;
      }
    }
    
    return config;
  }

  /// Validates if a file is a valid xcconfig file
  Future<bool> isValidXConfig(String filePath) async {
    if (!await File(filePath).exists()) {
      return false;
    }

    try {
      final content = await File(filePath).readAsString();
      // Basic validation: should contain at least one valid key=value pair
      return RegExp(r'^\s*[A-Za-z_][A-Za-z0-9_]*\s*=').hasMatch(content);
    } catch (e) {
      return false;
    }
  }
}
