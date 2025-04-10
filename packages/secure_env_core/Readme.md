# Secure Env Core

A robust library for securely managing environment variables across projects and formats.

[![Pub Version](https://img.shields.io/pub/v/secure_env_core.svg)](https://pub.dev/packages/secure_env_core)

## Overview

`secure_env_core` provides a complete solution for managing environment variables securely across different projects and file formats. It supports encryption of sensitive values, multiple file formats, and flexible project management.

## Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  secure_env_core: ^1.0.0
```

Then run:
```bash
dart pub get
```

## Key Features

- **Secure Storage**: Encrypt sensitive environment variables
- **Multiple Format Support**: Import/export from/to .env, .properties, and .xcconfig files
- **Project Management**: Organize environments by project
- **Variable Substitution**: Support for variable references in configuration files

## Basic Usage

### Initialize Project

```dart
import 'package:secure_env_core/secure_env_core.dart';

Future<void> main() async {
  // Create logger
  final logger = DefaultLogger();
  
  // Initialize registry service
  final registryService = ProjectRegistryService(logger: logger);
  
  // Initialize project service
  final projectService = ProjectService(
    logger: logger,
    registryService: registryService,
  );
  
  // Create a new project
  final project = await projectService.createProject(
    name: 'my_app',
    path: '/path/to/project',
    description: 'My application environment',
  );
  
  print('Project created: ${project.name}');
}
```

### Working with Environments

```dart
import 'package:secure_env_core/secure_env_core.dart';

Future<void> manageEnvironments() async {
  final logger = DefaultLogger();
  final projectService = ProjectService(
    logger: logger,
    registryService: ProjectRegistryService(logger: logger),
  );
  
  // Get existing project
  final project = await projectService.getProject('/path/to/project');
  if (project == null) {
    print('Project not found');
    return;
  }
  
  // Create environment service for this project
  final environmentService = await EnvironmentService.forProject(
    project: project,
    projectService: projectService,
    logger: logger,
  );
  
  // Create a new environment
  final devEnv = await environmentService.createEnvironment(
    name: 'development',
    description: 'Development environment variables',
    initialValues: {
      'API_URL': 'https://dev-api.example.com',
      'DEBUG': 'true',
    },
    sensitiveKeys: {
      'API_KEY': true, // Mark as sensitive
    },
  );
  
  // Set a sensitive value
  await environmentService.setValue(
    key: 'API_KEY',
    value: 'secret-dev-key-123',
    envName: 'development',
    isSecret: true,
  );
  
  // List all environments
  final environments = await environmentService.listEnvironments();
  print('Available environments:');
  for (final env in environments) {
    print('- ${env.name}');
  }
}
```

### Import/Export Environments

```dart
import 'package:secure_env_core/secure_env_core.dart';

Future<void> importExportExample() async {
  final logger = DefaultLogger();
  final projectService = ProjectService(
    logger: logger,
    registryService: ProjectRegistryService(logger: logger),
  );
  
  final project = await projectService.getProjectFromCurrentDirectory();
  if (project == null) {
    print('No project found in current directory');
    return;
  }
  
  final envService = await EnvironmentService.forProject(
    project: project,
    projectService: projectService,
    logger: logger,
  );
  
  // Import from .env file
  final importedEnv = await envService.importEnvironment(
    filePath: 'config/.env.production',
    envName: 'production',
    description: 'Production environment',
  );
  
  print('Imported ${importedEnv.values.length} values to environment ${importedEnv.name}');
  
  // Export to .xcconfig format
  final env = await envService.loadEnvironment(name: 'production');
  if (env != null) {
    final xcconfigService = XcConfigService();
    final xcconfigContent = xcconfigService.toXcConfig(env.values);
    await File('ios/Config/Production.xcconfig').writeAsString(xcconfigContent);
    print('Exported to iOS configuration file');
  }
}
```

## Working with Different File Formats

### .env Files

```dart
import 'package:secure_env_core/secure_env_core.dart';

void envFileExample() {
  final envService = EnvService();
  
  // Parse .env file
  final envMap = envService.readEnvFile('path/to/.env');
  
  // Create .env content
  final envContent = envService.toEnv({
    'API_URL': 'https://api.example.com',
    'DEBUG': 'true',
    'APP_NAME': 'My Cool App',
  });
  
  // Write .env file
  envService.writeEnvFile('output/.env', {
    'API_URL': 'https://api.example.com',
    'DEBUG': 'true',
  });
}
```

### .properties Files

```dart
import 'package:secure_env_core/secure_env_core.dart';

void propertiesExample() {
  final propertiesService = PropertiesService();
  
  // Convert to properties format
  final propertiesContent = propertiesService.toProperties({
    'api.url': 'https://api.example.com',
    'app.debug': 'true',
  });
  
  // Parse properties content
  final configMap = propertiesService.fromProperties(
    'api.url=https://api.example.com\napp.debug=true',
  );
  
  // Android format
  final androidProperties = propertiesService.toProperties(
    {'sdk.dir': '/Users/username/Library/Android/sdk'},
    androidStyle: true,
  );
}
```

### .xcconfig Files

```dart
import 'package:secure_env_core/secure_env_core.dart';

void xcconfigExample() {
  final xconfigService = XcConfigService();
  
  // Create xcconfig content with variable substitution
  final xconfigMap = {
    'BASE_URL': 'https://api.example.com',
    'ENV': 'production',
    'API_ENDPOINT': '$(BASE_URL)/v1',
    'SERVICE_URL': '$(BASE_URL)/$(ENV)/api',
  };
  
  final xconfigContent = xconfigService.toXcConfig(xconfigMap);
  
  // Parse xcconfig file with variable resolution
  final Map<String, String> parsedXcconfig = xconfigService.fromXcConfig(
    'BASE_URL = https://api.example.com\nENV = production\nAPI_ENDPOINT = $(BASE_URL)/v1',
    resolveVariables: true,
  );
}
```

## Encryption Service

The package includes an encryption service for securing sensitive data:

```dart
import 'package:secure_env_core/secure_env_core.dart';

void encryptionExample() {
  final encryptionService = EncryptionService();
  
  // Initialize with a strong password
  encryptionService.initialize('your-secure-master-password');
  
  // Encrypt sensitive data
  final encrypted = encryptionService.encrypt('api-secret-key-123');
  print('Encrypted: $encrypted');
  
  // Decrypt data
  final decrypted = encryptionService.decrypt(encrypted);
  print('Decrypted: $decrypted');
  
  // Generate a secure random key
  final masterKey = EncryptionService.generateMasterKey();
  print('Generated master key: $masterKey');
}
```

## Advanced Usage

### Working with Project Registry

```dart
import 'package:secure_env_core/secure_env_core.dart';

Future<void> projectRegistryExample() async {
  final logger = DefaultLogger();
  final registryService = ProjectRegistryService(logger: logger);
  
  // List all registered projects
  final projects = await registryService.listProjects();
  for (final project in projects) {
    print('${project.name}: ${project.path}');
  }
  
  // Get a specific project by name
  final projectMetadata = await registryService.getProjectMetadata('my-project');
  if (projectMetadata != null) {
    print('Found project: ${projectMetadata.name} at ${projectMetadata.path}');
  }
}
```

### Validation

The package provides validation utilities to ensure data integrity:

```dart
import 'package:secure_env_core/secure_env_core.dart';

void validationExample() {
  final secrets = {
    'API_KEY': 'valid-key',
    '': 'invalid-key', // Empty key will fail validation
    'DEBUG': 'true',
  };
  
  try {
    validateSecrets(secrets);
  } on ValidationException catch (e) {
    print('Validation failed: ${e.message}');
  }
}
```

## Best Practices

1. **Master Password Security**: Store the encryption master password securely and never hardcode it
2. **Sensitive Keys**: Always mark API keys, tokens, and passwords as sensitive
3. **Backup**: Regularly back up your project registry and environments
4. **File Exclusions**: Add `.secure_env/` to your .gitignore file
5. **Access Control**: Limit who has access to production environment values

## License

This package is available under the MIT License.