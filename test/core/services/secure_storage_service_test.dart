import 'dart:io';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;
import 'package:secure_env/src/core/services/encryption_service.dart';
import 'package:secure_env/src/core/services/secure_storage_service.dart';
import '../../utils/test_logger.dart';

void main() {
  late Directory tempDir;
  late EncryptionService encryptionService;
  late SecureStorageService storageService;
  late TestLogger logger;

  /// Set up test environment before each test:
  /// 1. Create temporary directory for secure storage
  /// 2. Initialize encryption service with test password
  /// 3. Create test logger for capturing messages
  /// 4. Initialize storage service with dependencies
  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('secure_storage_test_');
    encryptionService = EncryptionService()..initialize('test-password');
    logger = TestLogger();
    storageService = SecureStorageService(
      encryptionService: encryptionService,
      logger: logger,
      storageDirectory: tempDir.path,
    );
  });

  /// Clean up after each test by removing the temporary directory
  /// This ensures each test starts with a clean state
  tearDown(() {
    tempDir.deleteSync(recursive: true);
  });

  group('SecureStorageService', () {
    /// Test core functionality of storing and retrieving values
    /// This is the primary use case of the service
    /// Verifies that:
    /// 1. Values are stored successfully
    /// 2. Retrieved values match the originals
    test('stores and retrieves values correctly', () async {
      const key = 'test-key';
      const value = 'test-value';

      final stored = await storageService.store(key, value);
      expect(stored, isTrue);

      final retrieved = await storageService.retrieve(key);
      expect(retrieved, equals(value));
    });

    /// Test secure deletion functionality
    /// Verifies that:
    /// 1. Files are properly created when storing values
    /// 2. Files are completely removed after deletion
    /// 3. The delete operation succeeds
    test('deletes values securely', () async {
      const key = 'delete-test';
      const value = 'sensitive-data';

      await storageService.store(key, value);
      final filePath = path.join(tempDir.path, '$key.enc');
      expect(File(filePath).existsSync(), isTrue);

      final deleted = await storageService.delete(key);
      expect(deleted, isTrue);
      expect(File(filePath).existsSync(), isFalse);
    });

    /// Test error handling for non-existent keys
    /// The service should handle missing values gracefully
    test('handles non-existent keys', () async {
      final value = await storageService.retrieve('non-existent');
      expect(value, isNull);
    });

    /// Test error handling when encryption service is not initialized
    /// All operations should fail safely and log errors
    test('fails gracefully when encryption service not initialized', () async {
      final uninitializedEncryption = EncryptionService();
      final service = SecureStorageService(
        encryptionService: uninitializedEncryption,
        logger: logger,
        storageDirectory: tempDir.path,
      );

      final stored = await service.store('key', 'value');
      expect(stored, isFalse);
      expect(logger.errorLogs, isNotEmpty);
    });

    /// Test path traversal prevention
    /// Verifies that:
    /// 1. Unsafe paths are properly sanitized
    /// 2. Files are always created in the storage directory
    /// 3. No path traversal vulnerabilities exist
    test('sanitizes storage keys', () async {
      const key = '../unsafe/path/../../key';
      const value = 'test-value';

      await storageService.store(key, value);
      
      // Check that the file is created in the correct directory
      final files = tempDir.listSync();
      expect(files.length, equals(1));
      expect(
        files.first.path,
        path.join(tempDir.path, '___unsafe_path_______key.enc'),
      );
    });
  });
}
