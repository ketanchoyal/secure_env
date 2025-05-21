import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:secure_env_core/secure_env_core.dart';
import 'package:secure_env_gui/src/features/project_view/project_view_screen.dart';
import 'package:secure_env_gui/src/providers/app_state_providers.dart';
import 'package:secure_env_gui/src/providers/core_providers.dart';
import 'package:secure_env_gui/src/providers/environment_file_watcher_provider.dart';
import 'package:secure_env_gui/src/providers/environment_provider.dart'; // For EnvironmentOperations
import 'package:secure_env_gui/src/services/logging_service.dart';

// Mocks
class MockLogger extends Mock implements Logger {}
class MockProject extends Mock implements Project {}
class MockEnvironment extends Mock implements Environment {}
class MockExportConfig extends Mock implements ExportConfig {}

class MockProjectsNotifier extends Mock implements ProjectsNotifier {}
class MockEnvironmentsNotifier extends Mock implements EnvironmentsNotifier {}
class MockEnvironmentOperations extends Mock implements EnvironmentOperations {}

// Mock FileSystemEvent for FileWatchEventInfo
class MockFileSystemEvent extends Mock implements FileSystemEvent {}

void main() {
  late MockLogger mockLogger;
  late MockProjectsNotifier mockProjectsNotifier;
  late MockEnvironmentsNotifier mockEnvironmentsNotifier;
  late MockEnvironmentOperations mockEnvironmentOperations;

  late Project mockProjectInstance;
  late Environment mockEnvironmentInstance;
  late ExportConfig mockExportConfigInstance;

  // Stream controller for the file watcher provider
  late StreamController<FileWatchEventInfo> fileWatcherController;

  setUpAll(() {
    // Register fallback values for types used with registerFallbackValue
    // For any() matchers on generic methods or parameters.
    registerFallbackValue(ProjectState.initial());
    registerFallbackValue(EnvironmentState.initial());
    // No need to register fallback for EnvironmentOperationState if not directly used in verify with any() on a generic
  });

  setUp(() {
    mockLogger = MockLogger();
    mockProjectsNotifier = MockProjectsNotifier();
    mockEnvironmentsNotifier = MockEnvironmentsNotifier();
    mockEnvironmentOperations = MockEnvironmentOperations();

    mockProjectInstance = MockProject();
    mockEnvironmentInstance = MockEnvironment();
    mockExportConfigInstance = MockExportConfig();

    fileWatcherController = StreamController<FileWatchEventInfo>.broadcast();

    // Default stubbing for project and environment
    when(() => mockProjectInstance.id).thenReturn('proj1');
    when(() => mockProjectInstance.name).thenReturn('Test Project');
    when(() => mockProjectInstance.environments).thenReturn(['env1_name']); // List of env names
    when(() => mockProjectInstance.config).thenReturn(const ProjectConfig()); // Default config
    when(() => mockProjectInstance.createdAt).thenReturn(DateTime.now());
    when(() => mockProjectInstance.updatedAt).thenReturn(DateTime.now());
    when(() => mockProjectInstance.status).thenReturn(ProjectStatus.active);


    when(() => mockEnvironmentInstance.name).thenReturn('env1_name');
    when(() => mockEnvironmentInstance.values).thenReturn({'KEY': 'VALUE'});
    when(() => mockEnvironmentInstance.exportConfig).thenReturn(mockExportConfigInstance);
    when(() => mockEnvironmentInstance.createdAt).thenReturn(DateTime.now());


    when(() => mockExportConfigInstance.exportEnv).thenReturn(true); // Example
    when(() => mockExportConfigInstance.envPath).thenReturn('/fake/path/.env');

    // Stubbing for notifiers
    // ProjectsNotifier
    when(() => mockProjectsNotifier.selectedProject).thenReturn(mockProjectInstance);
    when(() => mockProjectsNotifier.state).thenReturn(ProjectState(
        projects: [mockProjectInstance], selectedProjectId: 'proj1'));
    when(() => mockProjectsNotifier.projectFromId(any())).thenReturn(mockProjectInstance);


    // EnvironmentsNotifier
    when(() => mockEnvironmentsNotifier.environments).thenReturn([mockEnvironmentInstance]);
    when(() => mockEnvironmentsNotifier.state).thenReturn(
        EnvironmentState(environments: [mockEnvironmentInstance]));
    
    // EnvironmentOperations
    when(() => mockEnvironmentOperations.syncEnvironmentFromFile(
            environmentName: any(named: 'environmentName'),
            filePath: any(named: 'filePath')))
        .thenAnswer((_) async {}); // Default successful sync

    // Logger
    when(() => mockLogger.info(any())).thenReturn(null);
    when(() => mockLogger.error(any(), any(), any())).thenReturn(null);
    when(() => mockLogger.warn(any())).thenReturn(null);

  });

  tearDown(() {
    fileWatcherController.close();
  });

  Widget buildTestableWidget() {
    return ProviderScope(
      overrides: [
        loggerProvider.overrideWithValue(mockLogger),
        projectsNotifierProvider.overrideWith((ref) => mockProjectsNotifier),
        environmentsNotifierProvider.overrideWith((ref) => mockEnvironmentsNotifier),
        environmentFileWatcherProvider.overrideWith((ref) => fileWatcherController.stream),
        environmentOperationsProvider.overrideWith((ref) => mockEnvironmentOperations),
      ],
      child: MaterialApp(
        home: ProjectViewScreen(projectId: 'proj1'), // Ensure a valid project ID
      ),
    );
  }

  testWidgets('Button is initially hidden', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle(); // Allow time for initial builds and states to settle

    expect(find.widgetWithText(TextButton, 'Sync Changes'), findsNothing);
  });

  testWidgets('Button appears on file event from watcher', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextButton, 'Sync Changes'), findsNothing);

    final mockFsEvent = MockFileSystemEvent();
    when(() => mockFsEvent.path).thenReturn('/fake/path/.env');
    when(() => mockFsEvent.type).thenReturn(FileSystemEvent.modify);
    
    final eventInfo = FileWatchEventInfo(mockFsEvent, mockEnvironmentInstance, '/fake/path/.env');
    fileWatcherController.add(eventInfo);

    await tester.pump(); // Rebuild with the new state after stream event

    expect(find.widgetWithText(TextButton, 'Sync Changes'), findsOneWidget);
  });

  testWidgets('Pressing button calls syncEnvironmentFromFile and button hides', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    // Make button appear
    final mockFsEvent = MockFileSystemEvent();
    const filePath = '/fake/path/.env';
    const envName = 'env1_name';
    when(() => mockFsEvent.path).thenReturn(filePath);
    when(() => mockFsEvent.type).thenReturn(FileSystemEvent.modify);
    when(() => mockEnvironmentInstance.name).thenReturn(envName); // Ensure env name is consistent

    final eventInfo = FileWatchEventInfo(mockFsEvent, mockEnvironmentInstance, filePath);
    fileWatcherController.add(eventInfo);
    await tester.pump();

    expect(find.widgetWithText(TextButton, 'Sync Changes'), findsOneWidget);

    // Tap the button
    await tester.tap(find.widgetWithText(TextButton, 'Sync Changes'));
    await tester.pump(); // Process the tap and subsequent setState

    // Verify syncEnvironmentFromFile was called
    verify(() => mockEnvironmentOperations.syncEnvironmentFromFile(
          environmentName: envName,
          filePath: filePath,
        )).called(1);

    // Verify button is hidden again
    expect(find.widgetWithText(TextButton, 'Sync Changes'), findsNothing);
  });

   testWidgets('Button appears and correctly passes different path/env to sync', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    final mockFsEvent = MockFileSystemEvent();
    const testFilePath = "/test/path/props.properties";
    const testEnvName = "another_env";

    // Prepare a different environment mock for this event
    final anotherMockEnv = MockEnvironment();
    when(() => anotherMockEnv.name).thenReturn(testEnvName);
    when(() => anotherMockEnv.exportConfig).thenReturn(mockExportConfigInstance); // Can reuse or make specific
    when(() => mockExportConfigInstance.propertiesPath).thenReturn(testFilePath); // Ensure this path is "configured"

    when(() => mockFsEvent.path).thenReturn(testFilePath); // Actual event path
    when(() => mockFsEvent.type).thenReturn(FileSystemEvent.create);

    final eventInfo = FileWatchEventInfo(mockFsEvent, anotherMockEnv, testFilePath);
    fileWatcherController.add(eventInfo);
    await tester.pump();

    expect(find.widgetWithText(TextButton, 'Sync Changes'), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, 'Sync Changes'));
    await tester.pump();

    verify(() => mockEnvironmentOperations.syncEnvironmentFromFile(
          environmentName: testEnvName,
          filePath: testFilePath,
        )).called(1);
    expect(find.widgetWithText(TextButton, 'Sync Changes'), findsNothing);
  });

}
