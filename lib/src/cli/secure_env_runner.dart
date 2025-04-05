import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart' hide Logger;
import 'package:secure_env/src/cli/commands/env/env_command.dart';
import 'package:secure_env/src/cli/commands/import/import_command.dart';
import 'package:secure_env/src/cli/commands/version_command.dart';
import 'package:secure_env/src/cli/commands/xcconfig_command.dart';
import 'package:secure_env/src/core/logger.dart';
import 'package:secure_env/src/core/mason_logger_adapter.dart';
import 'package:secure_env/src/core/services/environment_service.dart';

/// Command runner for the secure_env CLI
class SecureEnvRunner extends CommandRunner<int> {
  SecureEnvRunner({
    Logger? logger,
    required EnvironmentService environmentService,
  })  : _logger = logger ?? MasonLoggerAdapter(),
        _environmentService = environmentService,
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
    addCommand(
        EnvCommand(logger: _logger, environmentService: _environmentService));
    addCommand(ImportCommand(logger: _logger));
  }

  final Logger _logger;
  final EnvironmentService _environmentService;

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
      return result ?? ExitCode.success.code;
    } on FormatException catch (e) {
      _logger
        ..error(e.message)
        ..info('')
        ..info(usage);
      return ExitCode.software.code;
    } on UsageException catch (e) {
      _logger
        ..error(e.message)
        ..info('')
        ..info(e.usage);
      return ExitCode.software.code;
    } catch (error) {
      _logger.error('Error: $error');
      return ExitCode.software.code;
    }
  }
}
