import 'package:args/command_runner.dart';
import 'package:secure_env/src/core/logger.dart';

/// Base command class for all commands
abstract class BaseCommand extends Command<int> {
  /// Create a new base command
  BaseCommand({required this.logger});

  /// Logger instance
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
        ..error('Error: $error')
        ..info('')
        ..info(usage);
      return failureExitCode;
    }
  }
}
