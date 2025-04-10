import 'package:mason_logger/mason_logger.dart' as mason;
import 'package:secure_env_core/src/utils/logger.dart';

/// Adapter to use mason_logger as our Logger
class MasonLoggerAdapter implements Logger {
  /// Create a new mason logger adapter
  MasonLoggerAdapter() : _logger = mason.Logger();

  final mason.Logger _logger;

  @override
  void alert(String message) {
    _logger.alert(message);
  }

  @override
  void error(String message) {
    _logger.err(message);
  }

  @override
  void info(String message) {
    _logger.info(message);
  }

  @override
  void success(String message) {
    _logger.success(message);
  }

  @override
  void warn(String message) {
    _logger.warn(message);
  }

  @override
  void write(String message) {
    _logger.write(message);
  }
}
