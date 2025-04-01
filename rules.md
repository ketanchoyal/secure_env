# Environment Manager Project Rules

## Project Context

```yaml
name: env-manager
description: A Flutter-based environment manager for handling xcconfig, .env, and .properties files
language: dart
framework: flutter
state_management: riverpod
```

## File Structure Rules

### Enforced Paths
```yaml
- lib/core/models/     # Data models
- lib/core/services/   # Business logic services
- lib/features/cli/    # CLI implementation
- lib/features/gui/    # GUI implementation
- test/               # Test files
```

### Naming Conventions

#### Files
```yaml
pattern: "[a-z_]+\\.dart$"
exceptions:
  - "README.md"
  - "pubspec.yaml"
```

#### Classes
```yaml
pattern: "^[A-Z][a-zA-Z0-9]*$"  # Example: EnvironmentManager
```

#### Methods
```yaml
pattern: "^[a-z][a-zA-Z0-9]*$"  # Example: convertConfig
```

#### Private Members
```yaml
pattern: "^_[a-zA-Z0-9]*$"      # Example: _configPath
```

## Code Style Rules

```yaml
line_length: 80      # Maximum characters per line
indent: 2           # Spaces for indentation
trailing_comma: true # Use trailing commas for multi-line
sort_imports: true   # Sort imports alphabetically
prefer_const: true   # Prefer const over final
avoid_print: true    # Avoid using print statements
use_logger: true     # Use a logger for logging
```

## Architecture Rules

### Enforced Layers

```yaml
- name: models
  allowed_dependencies: []
- name: services
  allowed_dependencies:
    - models
- name: providers
  allowed_dependencies:
    - models
    - services
- name: commands
  allowed_dependencies:
    - models
    - services
    - providers
```

## Testing Rules

```yaml
required_coverage: 80  # Minimum test coverage percentage
test_file_pattern: "*_test.dart"  # Pattern for test files
test_directories:
  - test/core/
  - test/features/
required_tests:
  models: true
  services: true
  providers: true
  commands: true
  widgets: true
```

## Documentation Rules

```yaml
required_sections:
  - description
  - parameters
  - returns
  - throws
  - example
files_requiring_docs:
  - "lib/core/**/*.dart"
  - "lib/features/cli/commands/*.dart"
  - "lib/features/gui/screens/*.dart"
```

## Package Rules

```yaml
allowed_dependencies:
  core:
    - freezed_annotation
    - json_annotation
    - meta
    - path
  cli:
    - args
    - mason_logger
  services:
    - encrypt
    - yaml
    - path
  state:
    - flutter_riverpod
    - riverpod_annotation
  dev:
    - build_runner
    - freezed
    - json_serializable
    - riverpod_generator
    - test
    - mocktail
```

## Format Conversion Rules

```yaml
supported_formats:
  - xcconfig
  - env
  - properties
conversion_rules:
  xcconfig_to_env:
    - remove_variable_expansions
    - remove_spaces_around_equals
    - handle_includes
  xcconfig_to_properties:
    - convert_to_lowercase_dot_case
    - remove_variable_expansions
    - handle_includes
    - add_android_prefixes
```

## Security Rules

```yaml
required_practices:
  - encrypt_sensitive_data
  - validate_inputs
  - sanitize_file_paths
  - secure_key_storage
forbidden_practices:
  - hardcoded_secrets
  - direct_file_paths
  - system_commands
  - print_sensitive_data
```

## Error Handling Rules

```yaml
required_practices:
  - use_typed_errors
  - catch_specific_exceptions
  - provide_error_context
  - log_errors
error_hierarchy:
  - FormatError
  - FileSystemError
  - ConfigurationError
  - ValidationError
  - SecurityError
```

## Logging Rules

```yaml
required_levels:
  - error
  - warning
  - info
  - debug
log_format:
  - timestamp
  - level
  - context
  - message
  - stack_trace_if_error
```

## Performance Rules

```yaml
guidelines:
  - use_async_for_io
  - cache_file_reads
  - minimize_string_operations
  - batch_file_operations
