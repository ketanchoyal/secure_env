import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';

import 'commands/base_command.dart';
import 'commands/version_command.dart';
import 'commands/xcconfig_command.dart';
import 'commands/env/env_command.dart';
import 'commands/import/import_command.dart';

/// Command runner for the secure_env CLI
class SecureEnvRunner extends CommandRunner<int> {
  SecureEnvRunner({
    Logger? logger,
  })  : _logger = logger ?? Logger(),
        super(
          'secure_env',
          'A robust CLI tool for managing environment variables across different formats.',
        ) {
    argParser.addFlag(
      'version',
      abbr: 'v',
      help: 'Print the current version.',
      negatable: false,
    );

    addCommand(VersionCommand(logger: _logger));
    addCommand(XConfigCommand(logger: _logger));
    addCommand(EnvCommand(logger: _logger));
    addCommand(ImportCommand(logger: _logger));
  }

  final Logger _logger;

  @override
  Future<int> run(Iterable<String> args) async {
    try {
      // Handle version flag globally
      final topLevelResults = parse(args);
      if (topLevelResults['version'] as bool) {
        final command = VersionCommand(logger: _logger);
        final result = await command.run();
        return result;
      }

      final result = await super.run(args);
      return result ?? BaseCommand.successExitCode;
    } on FormatException catch (e) {
      _logger
        ..err(e.message)
        ..info('')
        ..info(usage);
      return BaseCommand.failureExitCode;
    } on UsageException catch (e) {
      _logger
        ..err(e.message)
        ..info('')
        ..info(e.usage);
      return BaseCommand.failureExitCode;
    } catch (error) {
      _logger.err('Error: $error');
      return BaseCommand.failureExitCode;
    }
  }
}
