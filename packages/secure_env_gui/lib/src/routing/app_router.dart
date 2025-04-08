import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:go_router/go_router.dart';

import '../features/dashboard/dashboard_screen.dart';
import '../features/project_view/project_view_screen.dart';
import '../features/shared_widgets/main_layout.dart'; // Import MainLayout

// Global navigator key
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

// Define route paths
class AppRoutes {
  static const String dashboard = '/';
  static const String projectView = '/project/:projectName'; // Use path parameter

  static String projectViewPath(String projectName) => '/project/${Uri.encodeComponent(projectName)}';
}

// Riverpod provider for the GoRouter instance
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey, // Assign the navigator key
    initialLocation: AppRoutes.dashboard,
    // TODO: Add observers for logging/analytics if needed
    // observers: [],
    // TODO: Add error handler page
    // errorBuilder: (context, state) => ErrorScreen(error: state.error),
    routes: [
      // ShellRoute wraps pages that share the MainLayout UI (NavigationRail)
      ShellRoute(
        navigatorKey: GlobalKey<NavigatorState>(debugLabel: 'shell'), // Optional key for shell navigator
        builder: (context, state, child) {
          return MainLayout(child: child); // Use MainLayout as the shell
        },
        routes: [
          // Dashboard route within the shell
          GoRoute(
            path: AppRoutes.dashboard,
            name: AppRoutes.dashboard,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardScreen(), // Display DashboardScreen in the shell
            ),
            routes: [
              // Project View route nested under dashboard to keep shell
              GoRoute(
                path: 'project/:projectName', // Path relative to dashboard '/'
                name: AppRoutes.projectView, // Name remains the same
                pageBuilder: (context, state) {
                  final projectName = state.pathParameters['projectName']!;
                  return NoTransitionPage(
                    child: ProjectViewScreen(
                      projectName: Uri.decodeComponent(projectName),
                    ),
                  );
                },
              ),
            ],
          ),
          // TODO: Add Settings route within the shell
          // GoRoute(
          //   path: AppRoutes.settings,
          //   name: AppRoutes.settings,
          //   pageBuilder: (context, state) => const NoTransitionPage(
          //     child: SettingsScreen(), // Replace with actual SettingsScreen
          //   ),
          // ),
        ],
      ),
      // TODO: Add routes outside the shell if needed (e.g., Login Screen)
    ],
  );
});
