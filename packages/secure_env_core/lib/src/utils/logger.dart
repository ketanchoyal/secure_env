/// Logger interface for the application
abstract class Logger {
  /// Log an info message
  void info(String message);

  /// Log an error message
  void error(String message);

  /// Log a success message
  void success(String message);

  /// Log a warning message
  void warn(String message);

  /// Write a message without any formatting
  void write(String message);

  /// Log an alert message
  void alert(String message);
}

/// Progress options for logger
class ProgressOptions {
  /// Create new progress options
  const ProgressOptions();
}

/// Log level
enum Level {
  /// Info level
  info,

  /// Warning level
  warning,

  /// Error level
  error,

  /// Success level
  success,
}
