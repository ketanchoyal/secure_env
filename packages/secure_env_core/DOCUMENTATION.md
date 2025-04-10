# secure_env_core Documentation

## Models

### Environment
Represents an environment with its variables and metadata.

#### Properties:
- **name** (required): Name of the environment
- **projectName** (required): Name of the project this environment belongs to
- **values** (required): Map of environment variables
- **sensitiveKeys** (optional): Map indicating which keys contain sensitive values
- **description** (optional): Description of the environment
- **lastModified** (optional): Last modification timestamp
- **metadata** (optional): Additional metadata key-value pairs

```dart
// Example: Create a new environment
final env = Environment(
  name: 'production',
  projectName: 'my-project',
  values: {'API_URL': 'https://api.example.com'},
  sensitiveKeys: {'API_KEY': true},
  description: 'Production environment',
  metadata: {'region': 'us-east-1'}
);
```

### Project
Represents a secure environment project.

#### Properties:
- **name** (required): Unique name of the project
- **path** (required): Base directory path where project files are stored
- **description** (optional): Description of the project
- **environments** (optional): List of environment names in this project
- **config** (optional): Project configuration
- **status** (optional): Project status (active/archived/markedForDeletion)
- **metadata** (optional): Additional metadata key-value pairs
- **createdAt**: Creation timestamp
- **updatedAt**: Last update timestamp

```dart
// Example: Create a new project
final project = Project(
  name: 'my-app',
  path: '/path/to/project',
  description: 'My application',
  environments: ['dev', 'prod'],
  metadata: {'team': 'backend'}
);
```

### ProjectMetadata
Metadata about a project stored in the central registry.

#### Properties:
- **name** (required): Unique name of the project
- **basePath** (required): Absolute base path of the project directory
- **createdAt**: Creation timestamp
- **updatedAt**: Last update timestamp
- **status**: Project status

## Services

### ProjectService
Manages secure environment projects.

#### Methods:
- **createProject({String? name, required String path, String? description, Map<String, String>? metadata})**
  - Creates a new project with the given name and path
  - Returns: `Future<Project>`

- **getProject(String name, String path)**
  - Gets a project by name and path
  - Returns: `Future<Project?>`

- **listProjects()**
  - Lists all active projects
  - Returns: `Future<List<Project>>`

- **updateProject(Project project)**
  - Updates project details
  - Returns: `Future<Project>`

- **archiveProject(String name, String path)**
  - Archives a project
  - Returns: `Future<Project>`

- **deleteProject(String name, String path)**
  - Deletes a project and its files
  - Returns: `Future<void>`

### ProjectRegistryService
Manages a central registry of all secure_env projects.

#### Methods:
- **listProjects({ProjectStatus? status})**
  - Lists all registered projects, optionally filtered by status
  - Returns: `Future<List<ProjectMetadata>>`

- **getProjectMetadata(String name)**
  - Gets metadata for a specific project
  - Returns: `Future<ProjectMetadata?>`

- **registerProject(ProjectMetadata metadata)**
  - Registers a new project in the central registry
  - Returns: `Future<ProjectMetadata>`

- **updateProjectMetadata(ProjectMetadata metadata)**
  - Updates metadata for an existing project
  - Returns: `Future<ProjectMetadata>`

- **unregisterProject(String name)**
  - Removes a project from the central registry
  - Returns: `Future<void>`

### EnvironmentService
Manages environment variables and their storage across different project environments. The service provides methods for creating, updating, and deleting environments, as well as managing their values and sensitive keys.

#### Key Features
- Create and manage multiple environments per project
- Secure storage of sensitive values
- Import from various file formats (.env, .properties, .xcconfig)
- Export environment variables to different formats
- Track environment modifications

#### Configuration
```dart
final environmentService = await EnvironmentService.forProject(
  project: project,
  projectService: projectService,
  logger: logger,
  secureStorage: secureStorageService,
  encryptionService: encryptionService,
);
```

#### Usage Examples

```dart
// Create a new environment
final env = await environmentService.createEnvironment(
  name: 'production',
  description: 'Production environment',
  initialValues: {
    'API_URL': 'https://api.example.com',
    'API_KEY': 'secret-key'
  },
  sensitiveKeys: {'API_KEY': true}
);

// Set environment variables
await environmentService.setValue(
  key: 'DATABASE_URL',
  value: 'postgres://localhost:5432/db',
  envName: 'production',
  isSecret: true
);

// Import from .env file
final importedEnv = await environmentService.importFromEnv(
  filePath: '/path/to/.env',
  name: 'staging',
  description: 'Staging environment',
  sensitiveKeys: {'API_KEY': true}
);

// List all environments
final environments = await environmentService.listEnvironments();

// Delete an environment
await environmentService.deleteEnvironment(name: 'staging');
```

#### Methods
- **forProject({required Project project, required ProjectService projectService, Logger? logger, SecureStorageService? secureStorage, EncryptionService? encryptionService})**
  - Creates an EnvironmentService for a specific project
  - Returns: `Future<EnvironmentService>`

- **createEnvironment({required String name, String? description, Map<String, String>? initialValues, Map<String, bool>? sensitiveKeys})**
  - Creates a new environment
  - Returns: `Future<Environment>`

- **listEnvironments()**
  - Lists all environments for a project
  - Returns: `Future<List<Environment>>`

- **loadEnvironment({required String name})**
  - Loads an environment from disk
  - Returns: `Future<Environment?>`

- **setValue({required String key, required String value, required String envName, bool isSecret = false})**
  - Sets a value in an environment
  - Returns: `Future<Environment>`

- **deleteEnvironment({required String name})**
  - Deletes an environment and its sensitive values
  - Returns: `Future<void>`

- **importFromEnv({required String filePath, required String name, String? description, Map<String, bool>? sensitiveKeys})**
  - Imports environment from a .env file
  - Returns: `Future<Environment>`

## Utils

## Format Services

### EnvService
Handles .env file format operations.

#### Methods:
- **readEnvFile(String filePath)**
  - Reads and parses a .env file
  - Returns: `Future<Map<String, String>>`

### PropertiesService
Handles Java properties file format operations.

#### Methods:
- **readPropertiesFile(String filePath)**
  - Reads and parses a .properties file
  - Returns: `Future<Map<String, String>>`

### XcConfigService
Handles Xcode configuration file format operations.

#### Methods:
- **readXcConfigFile(String filePath)**
  - Reads and parses a .xcconfig file
  - Returns: `Future<Map<String, String>>`

## Core Services

### ProjectService
The ProjectService is responsible for managing secure environment projects. It provides methods for creating, updating, and deleting projects, as well as managing their configurations.

#### Configuration
```dart
final projectService = ProjectService(
  projectRegistry: projectRegistry,
  logger: logger,
);
```

#### Usage Examples

```dart
// Create a new project
final project = await projectService.createProject(
  name: 'my-app',
  path: '/path/to/project',
  description: 'My application',
  metadata: {'team': 'backend'}
);

// Get a project
final project = await projectService.getProject('my-app', '/path/to/project');

// Update a project
final updatedProject = await projectService.updateProject(
  project: project,
);

// Import from .env file
final importedEnv = await environmentService.importFromEnv(
  filePath: '/path/to/.env',
  name: 'staging',
  description: 'Staging environment',
  sensitiveKeys: {'API_KEY': true}
);

// Import from .properties file
final importedProperties = await environmentService.importFromProperties(
  filePath: '/path/to/.properties',
  name: 'staging',
  description: 'Staging environment',
  sensitiveKeys: {'API_KEY': true}
);

// Import from .xcconfig file
final importedXcconfig = await environmentService.importFromXcconfig(
  filePath: '/path/to/.xcconfig',
  name: 'staging',
  description: 'Staging environment',
  sensitiveKeys: {'API_KEY': true}
);

// List all environments
final environments = await environmentService.listEnvironments();

// Delete an environment
await environmentService.deleteEnvironment(name: 'staging');
```

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
