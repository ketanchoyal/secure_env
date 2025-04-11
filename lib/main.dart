import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secure_env_gui/src/providers/registry_watcher_provider.dart';
import 'src/routing/app_router.dart';
import 'src/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
    ref.watch(registryWatcherProvider);

    return MaterialApp.router(
      title: 'Secure Env',
      theme: AppTheme.lightTheme, // Apply light theme
      darkTheme: AppTheme.darkTheme, // Apply dark theme
      themeMode: ThemeMode.system, // Use system setting (can be changed later)
      routerConfig: router, // Use the GoRouter instance from the provider
    );
  }
}
