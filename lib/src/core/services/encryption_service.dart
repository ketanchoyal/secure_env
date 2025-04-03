import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:crypto/crypto.dart';

/// Service responsible for encrypting and decrypting sensitive data using AES-256 encryption
///
/// Example usage:
/// ```dart
/// final encryptionService = EncryptionService();
///
/// // Initialize with a master password
/// encryptionService.initialize('my-secure-password');
///
/// // Encrypt sensitive data
/// final encrypted = encryptionService.encrypt('api-key-123');
/// print(encrypted); // Outputs: "base64encoded..."
///
/// // Decrypt data
/// final decrypted = encryptionService.decrypt(encrypted);
/// print(decrypted); // Outputs: "api-key-123"
///
/// // Generate a new master key
/// final masterKey = EncryptionService.generateMasterKey();
/// print(masterKey); // Outputs: "base64encoded..."
/// ```
class EncryptionService {
  late final Key _key;
  late final Encrypter _encrypter;
  bool _isInitialized = false;

  /// Initialize the encryption service with a master password
  ///
  /// The master password is used to derive a 32-byte key using SHA-256.
  /// A random IV is generated for each encryption operation.
  ///
  /// Example:
  /// ```dart
  /// encryptionService.initialize('my-secure-password');
  /// ```
  ///
  /// Throws nothing, but sets internal state for encryption operations.
  void initialize(String masterPassword) {
    // Generate a 32-byte key from the master password using SHA-256
    final keyBytes = sha256.convert(utf8.encode(masterPassword)).bytes;
    _key = Key(Uint8List.fromList(keyBytes));

    // Create AES encrypter in CBC mode
    _encrypter = Encrypter(AES(_key, mode: AESMode.cbc));
    _isInitialized = true;
  }

  /// Encrypt a string value using AES-256 in CBC mode
  ///
  /// Returns the encrypted value as a base64 string that can be safely stored.
  /// Each encryption uses a random IV to ensure non-deterministic output.
  /// The IV is prepended to the encrypted data for decryption.
  ///
  /// Example:
  /// ```dart
  /// final encrypted = encryptionService.encrypt('my-secret-value');
  /// // Store encrypted value safely
  /// await storage.write('secret', encrypted);
  /// ```
  ///
  /// Throws [StateError] if the service is not initialized
  String encrypt(String value) {
    if (!isInitialized) {
      throw StateError('Encryption service not initialized');
    }

    // Generate a random IV for each encryption
    final iv = IV.fromSecureRandom(16);
    final encrypted = _encrypter.encrypt(value, iv: iv);

    // Combine IV and encrypted data
    final combined = Uint8List(iv.bytes.length + encrypted.bytes.length);
    combined.setAll(0, iv.bytes);
    combined.setAll(iv.bytes.length, encrypted.bytes);

    return base64.encode(combined);
  }

  /// Decrypt a base64 encrypted string back to its original value
  ///
  /// Takes a base64 encoded string containing the IV and encrypted data
  /// and returns the original plaintext.
  ///
  /// Example:
  /// ```dart
  /// final encrypted = await storage.read('secret');
  /// final decrypted = encryptionService.decrypt(encrypted);
  /// print(decrypted); // Original value
  /// ```
  ///
  /// Throws [StateError] if the service is not initialized
  /// Throws [FormatException] if the input is not valid base64
  String decrypt(String encryptedValue) {
    if (!isInitialized) {
      throw StateError('Encryption service not initialized');
    }

    // Decode the combined IV and encrypted data
    final combined = base64.decode(encryptedValue);

    // Extract IV and encrypted data
    final iv = IV(Uint8List.fromList(combined.sublist(0, 16)));
    final encrypted = Encrypted(Uint8List.fromList(combined.sublist(16)));

    return _encrypter.decrypt(encrypted, iv: iv);
  }

  /// Check if the encryption service is initialized and ready to use
  ///
  /// Example:
  /// ```dart
  /// if (!encryptionService.isInitialized) {
  ///   encryptionService.initialize('master-password');
  /// }
  /// ```
  bool get isInitialized => _isInitialized;

  /// Generate a secure random key that can be used as a master key
  ///
  /// Returns a base64 encoded 32-byte random key
  ///
  /// Example:
  /// ```dart
  /// final newKey = EncryptionService.generateMasterKey();
  /// // Save this key securely and provide it to the user
  /// print('Your master key is: $newKey');
  /// ```
  static String generateMasterKey() {
    final key = Key.fromSecureRandom(32);
    return base64.encode(key.bytes);
  }
}
