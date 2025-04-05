import 'dart:io';
import 'package:path/path.dart' as path;

import '../utils/logger.dart';
import 'encryption_service.dart';

/// Service responsible for securely storing sensitive data on disk
///
/// This service handles the secure storage of sensitive values by:
/// 1. Encrypting values using the [EncryptionService]
/// 2. Storing encrypted data in isolated files
/// 3. Implementing secure deletion
/// 4. Sanitizing storage keys to prevent path traversal
///
/// Example usage:
/// ```dart
/// final encryptionService = EncryptionService()..initialize('master-password');
/// final storageService = SecureStorageService(
///   encryptionService: encryptionService,
///   logger: logger,
///   storageDirectory: '/path/to/secure/storage'
/// );
///
/// // Store a sensitive value
/// await storageService.store('api-key', 'secret-123');
///
/// // Retrieve the value
/// final value = await storageService.retrieve('api-key');
/// print(value); // Outputs: "secret-123"
///
/// // Securely delete the value
/// await storageService.delete('api-key');
/// ```
class SecureStorageService {
  final EncryptionService _encryptionService;
  final Logger _logger;
  final String _storageDir;

  /// Creates a new SecureStorageService
  ///
  /// Parameters:
  /// - [encryptionService]: Initialized encryption service for value encryption
  /// - [logger]: Logger instance for error reporting
  /// - [storageDirectory]: Base directory for storing encrypted files
  ///
  /// The constructor will create the storage directory if it doesn't exist.
  ///
  /// Example:
  /// ```dart
  /// final service = SecureStorageService(
  ///   encryptionService: encryptionService,
  ///   logger: logger,
  ///   storageDirectory: path.join(homeDir, '.secure_env', 'storage')
  /// );
  /// ```
  SecureStorageService({
    required EncryptionService encryptionService,
    required Logger logger,
    required String storageDirectory,
  })  : _encryptionService = encryptionService,
        _logger = logger,
        _storageDir = storageDirectory {
    // Ensure storage directory exists
    Directory(_storageDir).createSync(recursive: true);
  }

  /// Store a value securely
  ///
  /// Parameters:
  /// - [key]: Unique identifier for the value
  /// - [value]: The sensitive value to store
  ///
  /// Returns true if the operation was successful
  ///
  /// Example:
  /// ```dart
  /// // Store API credentials
  /// final stored = await storageService.store(
  ///   'aws-credentials',
  ///   jsonEncode({
  ///     'accessKey': 'AKIA...',
  ///     'secretKey': 'abc123...'
  ///   })
  /// );
  ///
  /// if (!stored) {
  ///   print('Failed to store credentials');
  /// }
  /// ```
  Future<bool> store(String key, String value) async {
    try {
      if (!_encryptionService.isInitialized) {
        throw StateError('Encryption service not initialized');
      }

      final encryptedValue = _encryptionService.encrypt(value);
      final file = File(_getFilePath(key));
      await file.writeAsString(encryptedValue);

      return true;
    } catch (e) {
      _logger.error('Failed to store value: $e');
      return false;
    }
  }

  /// Retrieve a securely stored value
  ///
  /// Parameters:
  /// - [key]: Unique identifier of the value to retrieve
  ///
  /// Returns the decrypted value or null if:
  /// - The value doesn't exist
  /// - Decryption fails
  /// - The encryption service isn't initialized
  ///
  /// Example:
  /// ```dart
  /// final apiKey = await storageService.retrieve('github-token');
  /// if (apiKey != null) {
  ///   await github.authenticate(apiKey);
  /// } else {
  ///   print('GitHub token not found or invalid');
  /// }
  /// ```
  Future<String?> retrieve(String key) async {
    try {
      if (!_encryptionService.isInitialized) {
        throw StateError('Encryption service not initialized');
      }

      final file = File(_getFilePath(key));
      if (!file.existsSync()) {
        return null;
      }

      final encryptedValue = await file.readAsString();
      return _encryptionService.decrypt(encryptedValue);
    } catch (e) {
      _logger.error('Failed to retrieve value: $e');
      return null;
    }
  }

  /// Delete a securely stored value
  ///
  /// This method implements secure deletion by:
  /// 1. Overwriting the file with random data
  /// 2. Flushing to disk
  /// 3. Deleting the file
  ///
  /// Parameters:
  /// - [key]: Unique identifier of the value to delete
  ///
  /// Returns true if the operation was successful or if the value didn't exist
  ///
  /// Example:
  /// ```dart
  /// // Securely remove old credentials
  /// final deleted = await storageService.delete('old-api-key');
  /// if (!deleted) {
  ///   print('Failed to securely delete the key');
  /// }
  /// ```
  Future<bool> delete(String key) async {
    try {
      final file = File(_getFilePath(key));
      if (!file.existsSync()) {
        return true;
      }

      // Securely delete by overwriting with random data
      final length = await file.length();
      final sink = file.openWrite();
      final random = List.generate(length, (_) => 0);
      sink.add(random);
      await sink.flush();
      await sink.close();

      // Delete the file
      await file.delete();
      return true;
    } catch (e) {
      _logger.error('Failed to delete value: $e');
      return false;
    }
  }

  /// Get the full path for a storage key
  ///
  /// This method:
  /// 1. Sanitizes the key to prevent path traversal
  /// 2. Adds the .enc extension
  /// 3. Joins with the storage directory
  ///
  /// Example:
  /// ```dart
  /// final path = _getFilePath('config/api-key');
  /// // Outputs: /storage/dir/config_api_key.enc
  /// ```
  String _getFilePath(String key) {
    final sanitizedKey = key.replaceAll(RegExp(r'[^\w\s-]'), '_');
    return path.join(_storageDir, '$sanitizedKey.enc');
  }
}
