/// Exception thrown when validation fails.
class ValidationException implements Exception {
  /// The error message describing the validation failure.
  final String message;

  /// Creates a new [ValidationException] with the given [message].
  const ValidationException(this.message);

  @override
  String toString() => message;
}
