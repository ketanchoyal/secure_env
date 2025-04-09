import 'package:secure_env_core/secure_env_core.dart';
import 'package:test/test.dart';
import 'package:secure_env_core/src/services/encryption_service.dart';

void main() {
  late EncryptionService encryptionService;

  setUp(() {
    encryptionService = EncryptionService();
  });

  group('EncryptionService', () {
    /// Test that initialization properly sets up the encryption service
    /// This is a critical test as all other operations depend on proper initialization
    test('initialization sets up encryption correctly', () {
      expect(encryptionService.isInitialized, isFalse);
      encryptionService.initialize('test-password');
      expect(encryptionService.isInitialized, isTrue);
    });

    /// Test the core encryption/decryption functionality
    /// Verifies that:
    /// 1. Encrypted value is different from original
    /// 2. Decrypted value matches original
    test('encrypts and decrypts values correctly', () {
      encryptionService.initialize('test-password');
      const originalValue = 'sensitive-data';

      final encrypted = encryptionService.encrypt(originalValue);
      expect(encrypted, isNot(equals(originalValue)));

      final decrypted = encryptionService.decrypt(encrypted);
      expect(decrypted, equals(originalValue));
    });

    /// Test that encryption is non-deterministic
    /// The same input should produce different ciphertexts
    /// This is important for security to prevent pattern analysis
    test('same value encrypts to different ciphertexts', () {
      encryptionService.initialize('test-password');
      const value = 'test-value';

      final encrypted1 = encryptionService.encrypt(value);
      final encrypted2 = encryptionService.encrypt(value);

      expect(encrypted1, isNot(equals(encrypted2)));
    });

    /// Test that the master key generation produces unique keys
    /// This is critical for security as each installation should
    /// have its own unique master key
    test('generates different master keys', () {
      final key1 = EncryptionService.generateMasterKey();
      final key2 = EncryptionService.generateMasterKey();

      expect(key1, isNot(equals(key2)));
    });

    /// Test error handling when service is not initialized
    /// All encryption operations should fail safely when not initialized
    test('throws when not initialized', () {
      expect(
        () => encryptionService.encrypt('test'),
        throwsA(isA<StateError>()),
      );
      expect(
        () => encryptionService.decrypt('test'),
        throwsA(isA<StateError>()),
      );
    });
  });
}
