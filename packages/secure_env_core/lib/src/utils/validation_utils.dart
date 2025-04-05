import '../exceptions/validation_exception.dart';

/// Validates a map of secrets (key-value pairs).
///
/// Throws a [ValidationException] if any key is empty or null.
/// Values can be empty or null.
///
/// Example:
/// ```dart
/// final secrets = {'API_KEY': 'abc123', 'DEBUG': ''};
/// try {
///   validateSecrets(secrets);
/// } on ValidationException catch (e) {
///   print('Invalid secrets: $e');
/// }
/// ```
void validateSecrets(Map<String, String?> secrets) {
  final invalidKeys = secrets.keys.where((key) => key.trim().isEmpty).toList();

  if (invalidKeys.isNotEmpty) {
    final message = invalidKeys.length == 1
        ? 'Empty key found at position ${secrets.keys.toList().indexOf(invalidKeys.first) + 1}'
        : 'Empty keys found at positions: ${invalidKeys.map((key) => secrets.keys.toList().indexOf(key) + 1).join(', ')}';

    throw ValidationException(message);
  }
}
