import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';

/// Base command class for all secure_env commands
abstract class BaseCommand extends Command<int> {
  BaseCommand({
    required this.logger,
  });

  /// Logger instance for CLI output
  final Logger logger;

  /// Exit code for successful execution
  static const successExitCode = 0;

  /// Exit code for command failure
  static const failureExitCode = 1;

  /// Helper method to handle errors consistently
  Future<int> handleErrors(Future<int> Function() run) async {
    try {
      return await run();
    } catch (error) {
      logger
        ..err('Error: $error')
        ..info('')
        ..info(usage);
      return failureExitCode;
    }
  }
}
