class ExceptionForProviders implements Exception {
  final String message;
  final Error? error;
  final StackTrace? stackTrace;

  ExceptionForProviders(this.message, {this.error, this.stackTrace});

  @override
  String toString() {
    return 'ExceptionForProviders: $message \n'
        'Error: ${error?.toString()}\n'
        'StackTrace: ${stackTrace?.toString()}';
  }
}
