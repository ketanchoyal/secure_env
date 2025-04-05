import 'package:test/test.dart';
import 'package:secure_env/src/core/exceptions/validation_exception.dart';
import 'package:secure_env/src/core/utils/validation_utils.dart';

void main() {
  group('validateSecrets', () {
    test('succeeds for valid secrets', () {
      final secrets = {
        'API_KEY': 'abc123',
        'DEBUG': 'true',
        'EMPTY_VALUE': '',
        'NULL_VALUE': null,
      };

      expect(() => validateSecrets(secrets), returnsNormally);
    });

    test('throws for single empty key', () {
      final secrets = {
        'API_KEY': 'abc123',
        '': 'value',
        'DEBUG': 'true',
      };

      expect(
        () => validateSecrets(secrets),
        throwsA(
          isA<ValidationException>().having(
            (e) => e.toString(),
            'message',
            'Empty key found at position 2',
          ),
        ),
      );
    });

    test('throws for multiple empty keys', () {
      final secrets = {
        '': 'value1',
        'API_KEY': 'abc123',
        '  ': 'value2',
        'DEBUG': 'true',
        ' ': 'value3',
      };

      expect(
        () => validateSecrets(secrets),
        throwsA(
          isA<ValidationException>().having(
            (e) => e.toString(),
            'message',
            'Empty keys found at positions: 1, 3, 5',
          ),
        ),
      );
    });

    test('throws for whitespace-only keys', () {
      final secrets = {
        'API_KEY': 'abc123',
        '   ': 'value',
        'DEBUG': 'true',
      };

      expect(
        () => validateSecrets(secrets),
        throwsA(
          isA<ValidationException>().having(
            (e) => e.toString(),
            'message',
            'Empty key found at position 2',
          ),
        ),
      );
    });

    test('succeeds for empty map', () {
      expect(() => validateSecrets({}), returnsNormally);
    });
  });
}
