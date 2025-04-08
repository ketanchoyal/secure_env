# secure_env_core Documentation

## Core Services

### EnvironmentService
Manages environment variables and their storage across different project environments.

#### Methods:
- **listEnvironments(String projectName)**
  - Lists all environments for a project
  - Returns: `Future<List<Environment>>`
  ```dart
  // Example: List all environments for 'my-project'
  final environments = await environmentService.listEnvironments('my-project');
  ```

- **createEnvironment({required String name, required String projectName, String? description, Map<String, String>? initialValues})**
  - Creates a new environment with optional initial values
  - Returns: `Future<Environment>`
  ```dart
  // Example: Create a new development environment
  final env = await environmentService.createEnvironment(
    name: 'development',
    projectName: 'my-project',
    description: 'Development environment',
    initialValues: {'API_URL': 'http://dev-api.example.com'}
  );
  ```

- **loadEnvironment({required String name, required String projectName})**
  - Loads an environment from disk, including sensitive values
  - Automatically decrypts sensitive values using SecureStorageService
  - Returns: `Future<Environment?>`
  ```dart
  // Example: Load the development environment
  final env = await environmentService.loadEnvironment(
    name: 'development',
    projectName: 'my-project'
  );
  ```

- **saveEnvironment(Environment env)**
  - Saves environment to disk
  - Automatically encrypts sensitive values using SecureStorageService
  - Masks sensitive values in the JSON file with '********'
  ```dart
  // Example: Save environment changes
  await environmentService.saveEnvironment(env);
  ```

- **setValue({required String key, required String value, required String envName, required String projectName, bool isSecret = false})**
  - Sets a value in an environment
  - Optionally marks the value as sensitive for secure storage
  - Returns: `Future<Environment>`
  ```dart
  // Example: Set an API key as a secret value
  final updatedEnv = await environmentService.setValue(
    key: 'API_KEY',
    value: 'secret-key-123',
    envName: 'production',
    projectName: 'my-project',
    isSecret: true
  );
  ```

- **getValue({required String key, required String envName, required String projectName})**
  - Retrieves a value from an environment
  - Automatically handles decryption for sensitive values
  - Returns: `Future<String?>`
  ```dart
  // Example: Get an environment variable
  final apiKey = await environmentService.getValue(
    key: 'API_KEY',
    envName: 'production',
    projectName: 'my-project'
  );
  ```

- **deleteEnvironment({required String name, required String projectName})**
  - Deletes an environment and its sensitive values
  - Securely removes encrypted values from storage
  - Returns: `Future<void>`
  ```dart
  // Example: Delete a test environment
  await environmentService.deleteEnvironment(
    name: 'test',
    projectName: 'my-project'
  );
  ```

- **importEnvironment({required String filePath, required String envName, required String projectName, String? description})**
  - Imports environment variables from a file
  - Supports .env, .xcconfig, and .properties formats
  - Returns: `Future<Environment>`
  ```dart
  // Example: Import from a .env file
  final env = await environmentService.importEnvironment(
    filePath: '/path/to/.env',
    envName: 'staging',
    projectName: 'my-project',
    description: 'Staging environment'
  );
  ```

### SecureStorageService
Handles secure storage of sensitive values using encryption.

#### Methods:
- **store(String key, String value)**
  - Stores a value securely using encryption
  - Automatically creates storage directory if needed
  - Returns: `Future<bool>`
  ```dart
  // Example: Store a sensitive value
  final success = await secureStorage.store('api-key', 'secret-123');
  ```

- **retrieve(String key)**
  - Retrieves and decrypts a securely stored value
  - Returns: `Future<String?>`
  ```dart
  // Example: Retrieve a sensitive value
  final value = await secureStorage.retrieve('api-key');
  ```

- **delete(String key)**
  - Securely deletes a stored value
  - Returns: `Future<bool>`
  ```dart
  // Example: Delete a sensitive value
  final deleted = await secureStorage.delete('api-key');
  ```

### EncryptionService
Manages encryption and decryption of sensitive data using AES-256 in CBC mode.

#### Methods:
- **initialize(String masterPassword)**
  - Initializes the encryption service with a master password
  - Derives a 32-byte key using SHA-256
  - Returns: `void`
  ```dart
  // Example: Initialize encryption service
  encryptionService.initialize('my-secure-master-password');
  ```

- **encrypt(String value)**
  - Encrypts a string value using AES-256 in CBC mode
  - Generates a random IV for each encryption
  - Returns: Base64 encoded string
  ```dart
  // Example: Encrypt a sensitive value
  final encrypted = encryptionService.encrypt('secret-api-key-123');
  ```

- **decrypt(String encryptedValue)**
  - Decrypts a base64 encrypted string
  - Returns: Original plaintext
  ```dart
  // Example: Decrypt a value
  final decrypted = encryptionService.decrypt(encrypted);
  ```

- **generateMasterKey()**
  - Generates a secure random 32-byte key
  - Returns: Base64 encoded key string
  ```dart
  // Example: Generate a new master key
  final masterKey = EncryptionService.generateMasterKey();
  ```

## Format Services

### EnvService
Handles .env file format operations with proper escaping and quoting.

#### Methods:
- **toEnv(Map<String, String> config)**
  - Converts key-value pairs to .env format
  - Properly handles spaces, quotes, and special characters
  - Returns: String
  ```dart
  // Example: Convert config to .env format
  final envContent = envService.toEnv({
    'API_URL': 'http://api.example.com',
    'SECRET_KEY': 'my secret key'
  });
  ```

- **fromEnv(String content)**
  - Parses .env file content
  - Handles quoted values and comments
  - Returns: Map<String, String>
  ```dart
  // Example: Parse .env content
  final config = envService.fromEnv('API_URL="http://api.example.com"');
  ```

### PropertiesService
Handles Java properties file format operations.

#### Methods:
- **toProperties(Map<String, String> config, {bool androidStyle = false})**
  - Converts key-value pairs to .properties format
  - Optional Android-style formatting
  - Returns: String
  ```dart
  // Example: Convert to properties format
  final properties = propertiesService.toProperties(
    {'api.url': 'http://api.example.com'},
    androidStyle: true
  );
  ```

- **fromProperties(String content, {bool androidStyle = false})**
  - Parses .properties file content
  - Supports both standard and Android-style properties
  - Returns: Map<String, String>
  ```dart
  // Example: Parse properties content
  final config = propertiesService.fromProperties(
    'api.url=http://api.example.com',
    androidStyle: true
  );
  ```

### XConfigService
Handles Xcode configuration file operations with variable substitution support.

#### Methods:
- **readXConfig(String filePath, {Set<String>? processedFiles, Map<String, String>? variables})**
  - Reads an xcconfig file with variable substitution
  - Handles includes and variable references
  - Returns: `Future<Map<String, String>>`
  ```dart
  // Example: Read xcconfig file with variables
  final config = await xconfigService.readXConfig(
    'Config.xcconfig',
    variables: {'PRODUCT_NAME': 'MyApp'}
  );
  ```

- **isValidXConfig(String filePath)**
  - Validates if a file is a valid xcconfig file
  - Checks for proper key=value format
  - Returns: `Future<bool>`
  ```dart
  // Example: Validate xcconfig file
  final isValid = await xconfigService.isValidXConfig('Config.xcconfig');
  ```

## Utilities

### ValidationUtils

#### Methods:
- **validateSecrets(Map<String, String?> secrets)**
  - Validates a map of secrets (key-value pairs)
  - Ensures no empty or null values
  - Throws ValidationException if validation fails
  ```dart
  // Example: Validate secrets map
  try {
    validateSecrets({'API_KEY': 'secret', 'DB_PASS': 'password'});
  } catch (e) {
    print('Validation failed: $e');
  }
  ```
