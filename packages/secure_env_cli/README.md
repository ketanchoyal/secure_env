# secure_env_cli

A command-line interface tool for managing environment variables securely across different projects and environments.

## Features

- **Project Management**: Create and manage secure environment projects
- **Environment Variables**: Create, edit, and manage environment variables
- **Multiple Formats**: Support for .env, .properties, and .xcconfig file formats
- **Import/Export**: Import from and export to various file formats
- **Secure Storage**: Securely store sensitive values with encryption
- **Cross-Platform**: Works on macOS, Linux, and Windows

## Installation

### Using Dart

```bash
# Install globally
dart pub global activate secure_env_cli

# Or run directly
dart run secure_env_cli
```

### Using Homebrew (macOS) [WIP]

```bash
brew tap ketanchoyal/secure_env
brew install secure_env
```

## Quick Start

1. **Initialize a new project**:
   ```bash
   secure-env init --name my-app --description "My application"
   ```

2. **Create an environment**:
   ```bash
   secure-env env create -n production -d "Production environment" --key "API_URL" --value "https://api.example.com" --sensitive-keys "API_KEY"
   ```

3. **Import from existing files**:
   ```bash
   secure-env import env -f .env.example -n staging -d "Staging environment" -s "API_KEY,DB_PASSWORD"
   ```

4. **Export to different formats**:
   ```bash
   secure-env env export -n production -f env -o .env.production
   ```

## Commands

### Global Options
- `--version, -v`: Print the current version

### Init
Initialize a new secure environment project.

```bash
secure-env init [options]
```

#### Options:
- `--name, -n`: Project name
- `--description, -d`: Project description

### Environment Management

#### List Environments
```bash
secure-env env list
```

#### Create Environment
```bash
secure-env env create [options]
```

#### Options:
- `--name, -n`: Environment name (required)
- `--description, -d`: Environment description
- `--key, -k`: Key to add (can be used multiple times)
- `--value, -v`: Value for the key (can be used multiple times)
- `--sensitive-keys, -s`: Keys to mark as sensitive (comma-separated)

#### Edit Environment
```bash
secure-env env edit [options]
```

#### Options:
- `--name, -n`: Environment name (required)
- `--key, -k`: Key to edit (required)
- `--value, -v`: New value (required)
- `--sensitive, -s`: Mark as sensitive value

#### Delete Environment
```bash
secure-env env delete [options]
```

#### Options:
- `--name, -n`: Environment name (required)

#### Environment Info
```bash
secure-env env info [options]
```

#### Options:
- `--name, -n`: Environment name (required)

#### Export Environment
```bash
secure-env env export [options]
```

#### Options:
- `--name, -n`: Environment name (required)
- `--format, -f`: Output format (env, properties, xcconfig)
- `--output, -o`: Output file path

### Import Commands

#### Import .env File
```bash
secure-env import env [options]
```

#### Options:
- `--file, -f`: Path to .env file (required)
- `--name, -n`: Target environment name (required)
- `--description, -d`: Environment description
- `--sensitive-keys, -s`: Keys to mark as sensitive (comma-separated)

#### Import .properties File
```bash
secure-env import properties [options]
```

#### Options:
- `--file, -f`: Path to .properties file (required)
- `--name, -n`: Target environment name (required)
- `--description, -d`: Environment description
- `--sensitive-keys, -s`: Keys to mark as sensitive (comma-separated)
- `--android-style`: Use Android-style properties format

#### Import .xcconfig File
```bash
secure-env import xcconfig [options]
```

#### Options:
- `--file, -f`: Path to .xcconfig file (required)
- `--name, -n`: Target environment name (required)
- `--description, -d`: Environment description
- `--sensitive-keys, -s`: Keys to mark as sensitive (comma-separated)

### XConfig Command
Convert xcconfig files to env/properties format.

```bash
secure-env xcconfig [options]
```

#### Options:
- `--project-path, -p`: Flutter project path (required)
- `--xcconfig-path`: Path to xcconfig files (default: ios/Flutter)
- `--env-path`: Output env file path (default: .env)
- `--properties-path`: Output properties file path
- `--format`: Output format: env, properties, both (default: both)
- `--config`: Path to env_config.json
- `--android-res`: Android resources directory

## Examples

### Initialize a New Project
```bash
# Initialize a project in the current directory
secure-env init --name my-app --description "My application"

# Initialize a project with a specific name
secure-env init -n my-flutter-app -d "Flutter application"
```

### Create and Manage Environments
```bash
# Create a new environment with multiple key-value pairs
secure-env env create -n production -d "Production environment" \
  --key "API_URL" --value "https://api.example.com" \
  --key "API_KEY" --value "secret-key" \
  --sensitive-keys "API_KEY"

# List all environments
secure-env env list

# Edit an environment variable
secure-env env edit -n production -k "DATABASE_URL" -v "postgres://localhost:5432/db" -s

# Export an environment to .env file
secure-env env export -n production -f env -o .env.production
```

### Import Environment Variables
```bash
# Import from .env file
secure-env import env -f .env.example -n staging -d "Staging environment" -s "API_KEY,DB_PASSWORD"

# Import from .properties file
secure-env import properties -f config.properties -n android -d "Android configuration" -s "API_KEY"

# Import from .xcconfig file
secure-env import xcconfig -f Debug.xcconfig -n ios-debug -d "iOS Debug configuration" -s "API_KEY"
```

### Convert XConfig Files
```bash
# Convert xcconfig files to both .env and .properties
secure-env xcconfig -p /path/to/flutter/project -f both

# Convert to .env only
secure-env xcconfig -p /path/to/flutter/project -f env -e .env.ios

# Convert to .properties with Android style
secure-env xcconfig -p /path/to/flutter/project -f properties -a android/app/src/main/res/values
```

## Development

### Prerequisites

- Dart SDK (>=3.0.0)
- Git

### Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/ketanchoyal/secure_env.git
   cd secure_env
   ```

2. Install dependencies:
   ```bash
   dart pub get
   ```

3. Build the CLI:
   ```bash
   dart compile exe bin/secure_env.dart -o secure-env
   ```

### Running Tests

```bash
dart test
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [args](https://pub.dev/packages/args) - Command-line argument parsing
- [mason_logger](https://pub.dev/packages/mason_logger) - Logging functionality
- [secure_env_core](https://github.com/ketanchoyal/secure_env/tree/main/packages/secure_env_core) - Core functionality 