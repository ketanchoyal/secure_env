import 'package:secure_env_core/secure_env_core.dart';

/// A logger that captures logs for testing
class TestLogger implements Logger {
  final List<String> _infoLogs = [];
  final List<String> _errorLogs = [];
  final List<String> _successLogs = [];
  final List<String> _warningLogs = [];
  final List<String> _debugLogs = [];

  List<String> get infoLogs => _infoLogs;
  List<String> get errorLogs => _errorLogs;
  List<String> get successLogs => _successLogs;
  List<String> get warningLogs => _warningLogs;
  List<String> get debugLogs => _debugLogs;
  @override
  void info(String message) {
    _infoLogs.add(message);
  }

  @override
  void error(String message) {
    _errorLogs.add(message);
  }

  @override
  void success(String message) {
    _successLogs.add(message);
  }

  @override
  void warn(String message) {
    _warningLogs.add(message);
  }

  void clear() {
    _infoLogs.clear();
    _errorLogs.clear();
    _successLogs.clear();
    _warningLogs.clear();
  }

  @override
  void write(String message) {
    info(message);
  }

  @override
  void alert(String message) {
    info(message);
  }

  @override
  void debug(String message) {
    _debugLogs.add(message);
  }
}
