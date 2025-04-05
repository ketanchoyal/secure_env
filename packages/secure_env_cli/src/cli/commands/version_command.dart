import 'package:path/path.dart' as path;
import 'package:pub_semver/pub_semver.dart';
import 'package:yaml/yaml.dart';
import 'dart:io';

import 'base_command.dart';

/// Command to display the current version of secure_env
class VersionCommand extends BaseCommand {
  VersionCommand({
    required super.logger,
  }) {
    argParser.addFlag(
      'verbose',
      abbr: 'v',
      help: 'Print verbose version information',
      negatable: false,
    );
  }

  @override
  String get description => 'Print the current version.';

  @override
  String get name => 'version';

  @override
  Future<int> run() => handleErrors(() async {
        final verbose = argResults?['verbose'] as bool? ?? false;
        final version = await _getVersion();

        if (verbose) {
          logger
            ..info('secure_env version: $version')
            ..info('Installation path: ${await _getInstallPath()}')
            ..info('Dart version: ${Platform.version.split(' ').first}')
            ..info('Platform: ${Platform.operatingSystem}');
        } else {
          logger.info(version.toString());
        }

        return BaseCommand.successExitCode;
      });

  Future<Version> _getVersion() async {
    final pubspecFile = File(path.join(_getPackageRoot(), 'pubspec.yaml'));
    final pubspecContent = await pubspecFile.readAsString();
    final pubspec = loadYaml(pubspecContent) as YamlMap;
    return Version.parse(pubspec['version'] as String);
  }

  String _getPackageRoot() {
    final script = Platform.script.toFilePath();
    return path.dirname(path.dirname(path.dirname(path.dirname(script))));
  }

  Future<String> _getInstallPath() async {
    try {
      final result = await Process.run('which', ['secure_env']);
      return result.stdout.toString().trim();
    } catch (_) {
      return 'Not found in PATH';
    }
  }
}
