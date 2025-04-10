import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart' as log;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:secure_env_core/secure_env_core.dart' as core;

part 'logging_service.g.dart';

/// A logging service that implements the Logger interface from secure_env_core
/// and uses the logger package for better logging capabilities.
class LoggingService implements core.Logger {
  final log.Logger _logger;
  final String? _prefix;
  final bool _verbose;

  LoggingService({String? prefix, bool verbose = false})
    : _prefix = prefix,
      _verbose = verbose,
      _logger = log.Logger(
        printer: log.PrettyPrinter(
          methodCount: 0,
          errorMethodCount: 8,
          lineLength: 120,
          colors: true,
          printEmojis: true,
          printTime: true,
        ),
      );

  String _formatMessage(String message) {
    return _prefix != null ? '[$_prefix] $message' : message;
  }

  @override
  void alert(String message) {
    _logger.f(_formatMessage(message));
  }

  @override
  void debug(String message) {
    if (_verbose) {
      _logger.d(_formatMessage(message));
    }
  }

  @override
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.e(_formatMessage(message), error: error, stackTrace: stackTrace);
  }

  @override
  void info(String message) {
    _logger.i(_formatMessage(message));
  }

  @override
  void success(String message) {
    _logger.i('✅ ${_formatMessage(message)}');
  }

  @override
  void warn(String message) {
    _logger.w(_formatMessage(message));
  }

  @override
  void write(String message) {
    _logger.v(_formatMessage(message));
  }
}

/// Provider for the logging service
@riverpod
LoggingService loggingService(Ref ref) {
  return LoggingService(
    prefix: 'SecureEnvGUI',
    verbose: true, // You can make this configurable based on your needs
  );
}

/// Provider for the Logger interface implementation
@riverpod
core.Logger logger(Ref ref) {
  return ref.watch(loggingServiceProvider);
}
