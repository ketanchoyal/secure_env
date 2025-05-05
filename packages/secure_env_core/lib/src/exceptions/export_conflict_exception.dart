class ExportConflictException implements Exception {
  const ExportConflictException(this.message, {this.details});
  final String message;
  final String? details;
  @override
  String toString() => details == null ? message : '$message \n $details';
}

class ExportConflictExceptionMultiple extends ExportConflictException {
  const ExportConflictExceptionMultiple(this.exceptions, {super.details})
      : super('Multiple conflicts');
  final List<ExportConflictException> exceptions;
  @override
  String toString() =>
      'Multiple conflicts: ${exceptions.map((e) => e.message).join('; ')}';
}
