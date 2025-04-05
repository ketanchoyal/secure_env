import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:secure_env_core/secure_env_core.dart';
import 'base_command.dart';

/// Command to convert xcconfig files to env/properties format
class XConfigCommand extends BaseCommand {
  XConfigCommand({
    required super.logger,
  }) {
    argParser
      ..addOption(
        'project-path',
        abbr: 'p',
        help: 'Flutter project path',
        mandatory: true,
      )
      ..addOption(
        'xcconfig-path',
        help: 'Path to xcconfig files',
        defaultsTo: 'ios/Flutter',
      )
      ..addOption(
        'env-path',
        help: 'Output env file path',
        defaultsTo: '.env',
      )
      ..addOption(
        'properties-path',
        help: 'Output properties file path',
      )
      ..addOption(
        'format',
        help: 'Output format: env, properties, both',
        defaultsTo: 'both',
        allowed: ['env', 'properties', 'both'],
      )
      ..addOption(
        'config',
        help: 'Path to env_config.json',
      )
      ..addOption(
        'android-res',
        help: 'Android resources directory',
      );
  }

  @override
  String get description => 'Convert xcconfig files to env/properties format';

  @override
  String get name => 'xcconfig';

  @override
  Future<int> run() => handleErrors(() async {
        final projectPath = argResults!['project-path'] as String;
        final xconfigPath =
            path.join(projectPath, argResults!['xcconfig-path'] as String);
        final format = argResults!['format'] as String;
        final envPath = argResults!['env-path'] as String;
        final propertiesPath = argResults!['properties-path'] as String?;
        final configPath = argResults!['config'] as String?;
        final androidResPath = argResults!['android-res'] as String?;

        // Validate paths
        if (!Directory(projectPath).existsSync()) {
          throw 'Project path does not exist: $projectPath';
        }

        if (!Directory(xconfigPath).existsSync()) {
          throw 'XConfig path does not exist: $xconfigPath';
        }

        // Load config if provided
        Config? config;
        if (configPath != null) {
          final configFile = File(configPath);
          if (await configFile.exists()) {
            final configJson = jsonDecode(await configFile.readAsString());
            config = Config.fromJson(configJson as Map<String, dynamic>);
          }
        }

        // Initialize services
        final xconfigService = XConfigService();
        final envService = EnvService();
        final propertiesService = PropertiesService();

        // Process each xcconfig file
        final xconfigFiles = Directory(xconfigPath)
            .listSync()
            .whereType<File>()
            .where((f) => f.path.endsWith('.xcconfig'));

        for (final file in xconfigFiles) {
          final values = await xconfigService.readXConfig(file.path);

          // Apply key mapping and ignore keys if config is provided
          final mappedValues = _applyConfig(values, config);

          // Generate .env file
          if (format == 'env' || format == 'both') {
            await envService.writeEnvFile(envPath, mappedValues);
            logger.success('Generated .env file: $envPath');
          }

          // Generate .properties file
          if ((format == 'properties' || format == 'both') &&
              propertiesPath != null) {
            final androidStyle = androidResPath != null;
            await propertiesService.writePropertiesFile(
              propertiesPath,
              mappedValues,
              androidStyle: androidStyle,
            );
            logger.success('Generated .properties file: $propertiesPath');
          }
        }

        return BaseCommand.successExitCode;
      });

  Map<String, String> _applyConfig(Map<String, String> values, Config? config) {
    if (config == null) return values;

    final result = <String, String>{};
    for (final entry in values.entries) {
      // Skip ignored keys
      if (config.ignoreKeys.contains(entry.key)) continue;

      // Apply key mapping or use original key
      final mappedKey = config.keyMapping[entry.key] ?? entry.key;
      result[mappedKey] = entry.value;
    }

    return result;
  }
}
