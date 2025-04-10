# secure_env_cli Documentation

## Overview
secure_env_cli is a command-line interface tool for managing environment variables securely across different projects and environments. It provides a robust set of commands for creating, managing, and importing environment variables from various file formats.

## Installation

```bash
# Install globally
dart pub global activate secure_env_cli

# Or run directly
dart run secure_env_cli
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
List all environments in the current project.

```bash
secure-env env list
```

#### Create Environment
Create a new environment.

```bash
secure-env env create [options]
```

#### Options:
- `--name, -n`: Environment name (required)
- `--description, -d`: Environment description
- `--values, -v`: Initial values in key=value format (comma-separated)
- `--sensitive-keys, -s`: Keys to mark as sensitive (comma-separated)

#### Edit Environment
Edit an existing environment.

```bash
secure-env env edit [options]
```

#### Options:
- `--name, -n`: Environment name (required)
- `--key, -k`: Key to edit (required)
- `--value, -v`: New value (required)
- `--sensitive, -s`: Mark as sensitive value

#### Delete Environment
Delete an environment.

```bash
secure-env env delete [options]
```

#### Options:
- `--name, -n`: Environment name (required)

#### Environment Info
Display information about an environment.

```bash
secure-env env info [options]
```

#### Options:
- `--name, -n`: Environment name (required)

#### Export Environment
Export an environment to a file.

```bash
secure-env env export [options]
```

#### Options:
- `--name, -n`: Environment name (required)
- `--format, -f`: Output format (env, properties, xcconfig)
- `--output, -o`: Output file path

### Import Commands

#### Import .env File
Import environment variables from a .env file.

```bash
secure-env import env [options]
```

#### Options:
- `--file, -f`: Path to .env file (required)
- `--name, -n`: Target environment name (required)
- `--description, -d`: Environment description
- `--sensitive-keys, -s`: Keys to mark as sensitive (comma-separated)

#### Import .properties File
Import environment variables from a .properties file.

```bash
secure-env import properties [options]
```

#### Options:
- `--file, -f`: Path to .properties file (required)
- `--name, -n`: Target environment name (required)
- `--description, -d`: Environment description
- `--sensitive-keys, -s`: Keys to mark as sensitive (comma-separated)

#### Import .xcconfig File
Import environment variables from an .xcconfig file.

```bash
secure-env import xcconfig [options]
```

#### Options:
- `--file, -f`: Path to .xcconfig file (required)
- `--name, -n`: Target environment name (required)
- `--description, -d`: Environment description
- `--sensitive-keys, -s`: Keys to mark as sensitive (comma-separated)

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
# Create a new environment
secure-env env create -n production -d "Production environment" -v "API_URL=https://api.example.com,API_KEY=secret-key" -s "API_KEY"

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

### Convert XConfig Files [IN PROGRESS]
```bash
# Convert xcconfig files to both .env and .properties
secure-env xcconfig -p /path/to/flutter/project -f both

# Convert to .env only
secure-env xcconfig -p /path/to/flutter/project -f env -e .env.ios

# Convert to .properties with Android style
secure-env xcconfig -p /path/to/flutter/project -f properties -a android/app/src/main/res/values
```

## Architecture

The CLI is built using the following components:

### Command Runner
The `SecureEnvRunner` class serves as the main entry point for the CLI, handling command parsing and execution.

### Base Command
All commands extend the `BaseCommand` class, which provides common functionality like error handling and logging.

### Command Structure
Commands are organized hierarchically:
- Top-level commands (init, env, import, xcconfig)
- Subcommands (e.g., env create, env list, import env)

### Integration with Core
The CLI integrates with the `secure_env_core` package to provide the underlying functionality for managing projects and environments.

## Error Handling

The CLI provides consistent error handling across all commands:
- Usage errors (ExitCode.usage)
- File not found errors (ExitCode.unavailable)
- Other errors (ExitCode.software)

## Logging

The CLI uses the `mason_logger` package for consistent and colorful logging output.

## Dependencies

- args: Command-line argument parsing
- mason_logger: Logging functionality
- yaml: YAML file parsing
- secure_env_core: Core functionality for managing environments 