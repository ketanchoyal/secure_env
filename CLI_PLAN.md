# CLI Implementation Details

## Command Structure

### Base Command
```dart
abstract class SecureEnvCommand extends Command<int> {
  @override
  final String name;
  final String description;
  
  Future<int> run();
  void printUsage();
}
```

## Commands

### 1. Version Command
```dart
secure_env version
```
- Shows current version
- Shows installation path
- Lists available commands

### 2. XConfig Command
```dart
secure_env xcconfig [flavor]
  --project-path     # Flutter project path
  --xcconfig-path    # Path to xcconfig files
  --env-path        # Output env file path (optional)
  --properties-path # Output properties file path (optional)
  --format          # Output format: env,properties,both (default: both)
  --config          # Path to env_config.json
  --android-res     # Android resources directory (for properties)
```

Implementation:
```dart
class XConfigCommand extends SecureEnvCommand {
  @override
  final name = 'xcconfig';
  final description = 'Convert xcconfig files to env/properties';
  
  XConfigCommand() {
    argParser
      ..addOption('project-path',
        help: 'Flutter project path',
        mandatory: true)
      ..addOption('xcconfig-path',
        help: 'Path to xcconfig files',
        defaultsTo: 'ios/Flutter')
      // ... other options
  }
  
  @override
  Future<int> run() async {
    // Implementation
  }
}
```

### 3. Environment Commands

#### Create Environment
```dart
secure_env env create [name]
  --project     # Project name
  --template    # Template to use (optional)
```

#### List Environments
```dart
secure_env env list
  --project     # Project name (optional)
```

#### Edit Environment
```dart
secure_env env edit [name]
  --project     # Project name
  --editor      # Preferred editor (optional)
```

### 4. Value Management

#### Set Value
```dart
secure_env value set [key] [value]
  --env         # Environment name
  --project     # Project name
  --secret      # Mark as secret (optional)
```

#### Get Value
```dart
secure_env value get [key]
  --env         # Environment name
  --project     # Project name
```

## Services Integration

### 1. Format Service
```dart
class FormatService {
  final XConfigService _xcconfig;
  final EnvService _env;
  final PropertiesService _properties;

  Future<void> convert({
    required String sourcePath,
    required String format,
    required String outputPath,
    Config? config,
  }) async {
    // Implementation
  }
}
```

### 2. Storage Service
```dart
class StorageService {
  Future<void> saveProject(Project project) async {
    // Implementation
  }

  Future<void> saveEnvironment(Environment env) async {
    // Implementation
  }
}
```

## Error Handling

### Error Types
```dart
sealed class CliError {
  final String message;
  final dynamic source;
}

class CommandError extends CliError {
  final String command;
  final List<String> args;
}

class FileError extends CliError {
  final String path;
  final FileOperation operation;
}
```

### Error Handling Strategy
1. Command-specific errors
2. File operation errors
3. Format conversion errors
4. Configuration errors

## Testing Strategy

### 1. Unit Tests
- Command parsing
- Option validation
- Format conversion
- File operations

### 2. Integration Tests
- Full command workflows
- File system interactions
- Format conversions

### 3. E2E Tests
- Complete use cases
- Cross-platform verification

## CLI Usage Examples

### Basic Usage
```bash
# Initialize new project
secure_env init my_project

# Convert xcconfig to env
secure_env xcconfig UAT --project-path ./my_flutter_app

# Create new environment
secure_env env create staging --project my_project

# Set environment value
secure_env value set API_KEY "my-api-key" --env staging --project my_project
```

### Advanced Usage
```bash
# Convert with custom paths
secure_env xcconfig PROD \
  --project-path ./my_app \
  --xcconfig-path config/xcconfig \
  --env-path .env \
  --properties-path android/app/src/main/res/values/env.xml

# List all environments
secure_env env list --project my_project

# Edit environment in preferred editor
secure_env env edit staging --project my_project --editor vim
