import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart' hide Logger;
import 'package:secure_env/src/core/logger.dart';

/// Base command class for all commands
abstract class BaseCommand extends Command<int> {
  /// Create a new base command
  BaseCommand({required this.logger});

  /// Logger instance
  final Logger logger;

  /// Exit code for successful execution
  @Deprecated('Use ExitCode.success.code instead')
  static const successExitCode = 0;

  /// Exit code for command failure
  @Deprecated('Use ExitCode.software.code instead')
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
      if (error is UsageException || error is ArgumentError) {
        return ExitCode.usage.code;
      }
      return ExitCode.software.code;
    }
  }
}
