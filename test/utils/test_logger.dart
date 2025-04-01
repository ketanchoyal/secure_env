import 'package:mason_logger/mason_logger.dart';

/// A logger that captures logs for testing
class TestLogger implements Logger {
  final List<String> infoLogs = [];
  final List<String> errorLogs = [];
  final List<String> warningLogs = [];
  Level _level = Level.info;
  ProgressOptions _progressOptions = const ProgressOptions();

  @override
  void err(String? message, {String? Function(String?)? style}) {
    errorLogs.add(message ?? '');
  }

  @override
  void info(String? message, {String? Function(String?)? style}) {
    infoLogs.add(message ?? '');
  }

  @override
  void warn(String? message, {String? Function(String?)? style, String tag = ''}) {
    warningLogs.add(message ?? '');
  }

  void clear() {
    infoLogs.clear();
    errorLogs.clear();
    warningLogs.clear();
  }

  @override
  Progress progress(String message, {ProgressOptions? options}) {
    throw UnimplementedError();
  }

  @override
  void success(String? message, {String? Function(String?)? style}) {
    info('✓ $message');
  }

  @override
  void detail(String? message, {String? Function(String?)? style}) {
    info('  $message');
  }

  @override
  String prompt(String? message, {Object? defaultValue, bool hidden = false}) {
    throw UnimplementedError();
  }

  @override
  bool confirm(String? message, {bool defaultValue = false}) {
    throw UnimplementedError();
  }

  @override
  void write(String? message) {
    info(message);
  }

  bool get writeErrorsToStderr => false;

  @override
  void alert(String? message, {String? Function(String?)? style}) {
    info(message);
  }

  @override
  List<T> chooseAny<T extends Object?>(
    String? message, {
    required List<T> choices,
    List<T>? defaultValues,
    String Function(T)? display,
  }) {
    throw UnimplementedError();
  }

  @override
  T chooseOne<T extends Object?>(
    String? message, {
    required List<T> choices,
    T? defaultValue,
    String Function(T)? display,
  }) {
    throw UnimplementedError();
  }

  @override
  void delayed(String? message, {String? Function(String?)? style}) {
    info(message);
  }

  @override
  void flush([void Function(String?)? callback]) {}

  @override
  Level get level => _level;

  @override
  set level(Level value) {
    _level = value;
  }

  @override
  ProgressOptions get progressOptions => _progressOptions;

  @override
  set progressOptions(ProgressOptions value) {
    _progressOptions = value;
  }

  @override
  LogTheme get theme => LogTheme();

  @override
  List<String> promptAny(String? message, {String separator = ','}) {
    throw UnimplementedError();
  }

  @override
  void setLevel(Level level) {
    this.level = level;
  }
}
