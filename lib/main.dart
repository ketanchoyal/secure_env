import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:secure_env_gui/src/providers/registry_watcher_provider.dart';
import 'src/routing/app_router.dart';
import 'src/theme/app_theme.dart';
import 'src/routing/app_snackbar.dart';
import 'src/providers/settings_providers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: SecureEnvApp(),
    ),
  );

  doWhenWindowReady(() {
    const initialSize = Size(1000, 800);
    appWindow.minSize = Size(600, 400);
    appWindow.size = initialSize;
    appWindow.title = 'Secure Env';
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class SecureEnvApp extends ConsumerWidget {
  const SecureEnvApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the provider to get the GoRouter instance
    final router = ref.watch(goRouterProvider);
    ref.watch(registryWatcherProvider);

    // Get the global ScaffoldMessengerKey from the provider
    final scaffoldMessengerKey = ref.watch(scaffoldMessengerKeyProvider);

    ref.watch(snackbarProvider); // Initialize snackbar provider

    return MaterialApp.router(
      title: 'Secure Env',
      builder: (context, child) => Material(
        color: Colors.transparent,
        child: Column(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onPanStart: (details) {
                appWindow.startDragging();
              },
              onDoubleTap: () => appWindow.maximizeOrRestore(),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        'Secure Env',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 1,
            ),
            Expanded(
              child: child!,
            ),
          ],
        ),
      ),
      theme: AppTheme.lightTheme.copyWith(
        tabBarTheme: const TabBarTheme(
          indicatorAnimation: TabIndicatorAnimation.elastic,
          indicatorColor: Colors.black,
        ),
        textTheme: GoogleFonts.getTextTheme(
            ref.watch(settingsNotifierProvider).fontFamily,
            ThemeData.light().textTheme),
        primaryTextTheme: GoogleFonts.getTextTheme(
            ref.watch(settingsNotifierProvider).fontFamily,
            ThemeData.light().primaryTextTheme),
        // iconTheme: const IconThemeData(),
      ),
      darkTheme: AppTheme.darkTheme.copyWith(
        tabBarTheme: const TabBarTheme(
          indicatorAnimation: TabIndicatorAnimation.elastic,
          indicatorColor: Colors.white,
        ),
        textTheme: GoogleFonts.getTextTheme(
            ref.watch(settingsNotifierProvider).fontFamily,
            ThemeData.dark().textTheme),
        primaryTextTheme: GoogleFonts.getTextTheme(
            ref.watch(settingsNotifierProvider).fontFamily,
            ThemeData.dark().primaryTextTheme),
        // iconTheme: const IconThemeData(),
      ),
      themeMode: ref.watch(settingsNotifierProvider).themeMode,
      routerConfig: router,
      scaffoldMessengerKey: scaffoldMessengerKey,
    );
  }
}
