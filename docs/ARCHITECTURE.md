# Technical Architecture

## Technology Stack

### Core Technologies
- **Language**: Dart (SDK >=3.0.0)
- **UI Framework**: Flutter (>=3.16.0)
- **State Management**: Riverpod (^2.4.9)
- **Code Generation**: build_runner, freezed

### Project Structure
```
lib/
├── core/                     # Core functionality
│   ├── models/              # Data models
│   │   ├── project.dart
│   │   ├── environment.dart
│   │   └── config.dart
│   ├── services/            # Business logic
│   │   ├── encryption.dart
│   │   ├── storage.dart
│   │   └── git.dart
│   └── utils/              # Utility functions
│       ├── constants.dart
│       └── extensions.dart
│
├── features/               # Feature-based modules
│   ├── cli/               # CLI implementation
│   │   ├── commands/
│   │   └── runner.dart
│   └── gui/               # GUI implementation
│       ├── screens/
│       ├── widgets/
│       └── providers/
│
└── main.dart              # Entry point

test/
├── core/                  # Core tests
├── features/             # Feature tests
└── integration/          # Integration tests
```

## Dependencies

```yaml
dependencies:
  # Core
  flutter:
    sdk: flutter
  dart_cli: ^1.0.0        # CLI framework
  
  # State Management
  flutter_riverpod: ^2.4.9
  riverpod_annotation: ^2.3.3
  
  # Data Handling
  freezed: ^2.4.6
  json_serializable: ^6.7.1
  
  # Storage & Encryption
  encrypt: ^5.0.3
  path: ^1.8.3
  yaml: ^3.1.2
  
  # Development
  logger: ^2.0.2
  
dev_dependencies:
  # Code Generation
  build_runner: ^2.4.7
  riverpod_generator: ^2.3.9
  freezed_annotation: ^2.4.1
  
  # Testing
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.1
```

## Architecture Patterns

### Core Architecture
- **Clean Architecture** principles
- Clear separation of concerns
- Dependency injection using Riverpod

```dart
// Example of a service provider
@riverpod
EncryptionService encryption(EncryptionRef ref) {
  return EncryptionService();
}

// Example of a repository provider
@riverpod
class ProjectRepository extends _$ProjectRepository {
  @override
  FutureOr<List<Project>> build() async {
    return _loadProjects();
  }
}
```

### State Management
- **Riverpod** for dependency injection and state management
- Use of providers for:
  - Services
  - Repositories
  - UI State
  - Application State

```dart
// Example of a UI state provider
@riverpod
class ProjectsNotifier extends _$ProjectsNotifier {
  @override
  FutureOr<List<Project>> build() {
    return ref.watch(projectRepositoryProvider.future);
  }
  
  Future<void> addProject(Project project) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final projects = await future;
      return [...projects, project];
    });
  }
}
```

### Features Implementation

#### CLI Feature
- Command pattern for CLI operations
- Async command execution
- Error handling and logging

```dart
@riverpod
class CliCommand extends _$CliCommand {
  Future<void> execute(String command, List<String> args) async {
    final runner = ref.read(commandRunnerProvider);
    await runner.run([command, ...args]);
  }
}
```

#### GUI Feature
- Material 3 design system
- Responsive layouts
- Platform-specific adaptations
- Custom widgets and themes

```dart
class ProjectScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectsProvider);
    
    return projects.when(
      data: (data) => ProjectList(projects: data),
      loading: () => const LoadingIndicator(),
      error: (error, stack) => ErrorView(error: error),
    );
  }
}
```

## Data Flow

1. **User Input** → UI/CLI
2. **Command/Action** → Provider
3. **Business Logic** → Service
4. **Data Operation** → Repository
5. **State Update** → UI Refresh

## Security Considerations

- Encryption at rest for sensitive data
- Secure key storage
- Input validation
- Error handling without data leakage

## Testing Strategy

1. **Unit Tests**
   - Services
   - Repositories
   - Providers
   - Models

2. **Widget Tests**
   - Screen widgets
   - Custom components
   - Navigation

3. **Integration Tests**
   - End-to-end workflows
   - Cross-feature interactions

## Performance Considerations

- Lazy loading of data
- Efficient state management
- Caching when appropriate
- Minimal rebuilds in UI

## Next Steps

1. Set up project structure
2. Implement core services
3. Create CLI interface
4. Develop GUI screens
5. Add tests
6. Documentation
