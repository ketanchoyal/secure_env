import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/features/dashboard/dashboard_screen.dart'; // Keep for now, might remove if not directly used
import 'src/routing/app_router.dart';

// TODO: Define providers
// import 'src/theme/app_theme.dart'; // Import theme
import 'src/theme/app_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: SecureEnvApp(),
    ),
  );
}

class SecureEnvApp extends ConsumerWidget {
  const SecureEnvApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the provider to get the GoRouter instance
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Secure Env',
      theme: AppTheme.lightTheme, // Apply light theme
      darkTheme: AppTheme.darkTheme, // Apply dark theme
      themeMode: ThemeMode.system, // Use system setting (can be changed later)
      routerConfig: router, // Use the GoRouter instance from the provider
    );
  }
}
