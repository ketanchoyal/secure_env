/// Exception thrown when a file is not found.
class FileNotFoundException implements Exception {
  const FileNotFoundException(this.message);
  final String message;
  @override
  String toString() => message;
}
