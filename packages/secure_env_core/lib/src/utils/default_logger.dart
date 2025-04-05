import 'logger.dart';

/// A simple default logger implementation
class DefaultLogger implements Logger {
  @override
  void error(String message) {
    print('ERROR: $message');
  }

  @override
  void info(String message) {
    print('INFO: $message');
  }

  @override
  void success(String message) {
    print('SUCCESS: $message');
  }

  @override
  void warn(String message) {
    print('WARN: $message');
  }

  @override
  void write(String message) {
    print(message);
  }

  @override
  void alert(String message) {
    print('ALERT: $message');
  }
}
