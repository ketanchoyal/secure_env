# secure_env_core Documentation

## Overview
secure_env_core is a Dart package that provides a secure and flexible way to manage environment variables across different projects and environments. It supports multiple file formats, secure storage of sensitive values, and project management capabilities.

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
Manages environment variables and their storage across different project environments.

#### Methods:
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

- **importFromProperties({required String filePath, required String name, String? description, Map<String, bool>? sensitiveKeys})**
  - Imports environment from a .properties file
  - Returns: `Future<Environment>`

- **importFromXcconfig({required String filePath, required String name, String? description, Map<String, bool>? sensitiveKeys})**
  - Imports environment from a .xcconfig file
  - Returns: `Future<Environment>`

### SecureStorageService
Handles secure storage of sensitive values using encryption.

#### Methods:
- **store(String key, String value)**
  - Stores a value securely using encryption
  - Returns: `Future<bool>`

- **retrieve(String key)**
  - Retrieves and decrypts a securely stored value
  - Returns: `Future<String?>`

- **delete(String key)**
  - Securely deletes a stored value
  - Returns: `Future<bool>`

## Format Services

### EnvService
Handles .env file format operations.

#### Methods:
- **readEnvFile(String filePath)**
  - Reads and parses a .env file
  - Returns: `Future<Map<String, String>>`

- **toEnv(Map<String, String> config)**
  - Converts key-value pairs to .env format
  - Returns: String

- **fromEnv(String content)**
  - Parses .env file content
  - Returns: Map<String, String>

### PropertiesService
Handles Java properties file format operations.

#### Methods:
- **readPropertiesFile(String filePath)**
  - Reads and parses a .properties file
  - Returns: `Future<Map<String, String>>`

- **toProperties(Map<String, String> config, {bool androidStyle = false})**
  - Converts key-value pairs to .properties format
  - Returns: String

- **fromProperties(String content, {bool androidStyle = false})**
  - Parses .properties file content
  - Returns: Map<String, String>

### XcConfigService
Handles Xcode configuration file format operations.

#### Methods:
- **readXcConfigFile(String filePath)**
  - Reads and parses a .xcconfig file
  - Returns: `Future<Map<String, String>>`

- **readXConfig(String filePath, {Set<String>? processedFiles, Map<String, String>? variables})**
  - Reads an xcconfig file with variable substitution
  - Returns: `Future<Map<String, String>>`

- **isValidXConfig(String filePath)**
  - Validates if a file is a valid xcconfig file
  - Returns: `Future<bool>`

## Utilities

### ValidationUtils
Provides validation functions for environment variables and secrets.

#### Methods:
- **validateSecrets(Map<String, String?> secrets)**
  - Validates a map of secrets
  - Throws ValidationException if validation fails

### Logger
Provides logging functionality for the package.

#### Methods:
- **info(String message)**
  - Logs an info message

- **warning(String message)**
  - Logs a warning message

- **error(String message)**
  - Logs an error message

- **debug(String message)**
  - Logs a debug message

## Exceptions

### ValidationException
Thrown when validation fails.

### FileNotFoundException
Thrown when a required file is not found.

## Usage Examples

### Creating a New Project
```dart
final projectService = ProjectService(
  projectRegistry: projectRegistry,
  logger: logger,
);

final project = await projectService.createProject(
  name: 'my-app',
  path: '/path/to/project',
  description: 'My application',
  metadata: {'team': 'backend'}
);
```

### Managing Environments
```dart
final environmentService = await EnvironmentService.forProject(
  project: project,
  projectService: projectService,
  logger: logger,
  secureStorage: secureStorageService,
);

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

// Import from .env file
final importedEnv = await environmentService.importFromEnv(
  filePath: '/path/to/.env',
  name: 'staging',
  description: 'Staging environment',
  sensitiveKeys: {'API_KEY': true}
);
```

### Working with Format Services
```dart
// Read .env file
final envService = EnvService();
final envConfig = await envService.readEnvFile('/path/to/.env');

// Read .properties file
final propertiesService = PropertiesService();
final propertiesConfig = await propertiesService.readPropertiesFile('/path/to/.properties');

// Read .xcconfig file
final xcconfigService = XcConfigService();
final xcconfigConfig = await xcconfigService.readXcConfigFile('/path/to/Config.xcconfig');
```
