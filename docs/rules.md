# Development Guidelines

## Core Rules

### 1. Logging
- Use `MasonLoggerAdapter` from `lib/src/core/mason_logger_adapter.dart` for all logging
- Never use print statements
- Use appropriate log levels:
  - `error`: For errors that affect functionality
  - `warn`: For potential issues or deprecations
  - `info`: For general information
  - `success`: For successful operations
  - `alert`: For important user notifications

### 2. Error Handling
- Use `ExitCode` from `mason_logger` package for all command return values
  - `ExitCode.success.code` for successful operations
  - `ExitCode.software.code` for general errors
- Always wrap command logic in `handleError` from `BaseCommand`:
  ```dart
  @override
  Future<int> run() => handleErrors(() async {
    // Command implementation
  });
  ```

### 3. Command Implementation
- All commands must extend `BaseCommand`
- Implement required `name` and `description` getters
- Use `argParser` for command options
- Document all command options with help messages
- Place new commands in `lib/src/cli/commands/`

### 4. Code Organization
- Keep clear separation between:
  - CLI layer (`lib/src/cli/`)
  - Core business logic (`lib/src/core/`)
  - Services (`lib/src/core/services/`)
- Follow service pattern as shown in `EnvironmentService`
- Keep business logic in services
- Commands should only handle CLI interaction

### 5. Testing
- Place tests in corresponding directories:
  - CLI command tests in `test/cli/commands/`
  - Core tests in `test/core/`
  - Service tests in `test/services/`
- Use test fixtures from `test/fixtures/`

### 6. Documentation
- Document all public APIs with dartdoc comments
- Include usage examples in command help text
- Keep README.md up to date

### 7. Dependencies
- Use `mason_logger` for CLI output and exit codes
- Use `args` package for command-line argument parsing
- Keep dependencies minimal
