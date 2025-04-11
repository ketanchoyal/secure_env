import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

// Using FlexColorScheme for easier theme management
class AppTheme {
  // Define the scheme
  static const FlexScheme _scheme = FlexScheme.barossa; // Changed scheme

  // iOS-style input decoration theme
  static InputDecorationTheme _getIOSInputDecorationTheme(
      ColorScheme colorScheme) {
    return InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colorScheme.primary, width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colorScheme.error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colorScheme.error, width: 1),
      ),
      labelStyle: TextStyle(
        color: colorScheme.onSurface.withOpacity(0.6),
        fontSize: 16,
      ),
      hintStyle: TextStyle(
        color: colorScheme.onSurface.withOpacity(0.4),
        fontSize: 16,
      ),
      errorStyle: TextStyle(
        color: colorScheme.error,
        fontSize: 12,
      ),
      prefixIconColor: colorScheme.primary,
      suffixIconColor: colorScheme.onSurface.withOpacity(0.6),
    );
  }

  static final ThemeData lightTheme = FlexThemeData.light(
    scheme: _scheme,
    useMaterial3: true,
    // Optional customizations:
    // surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold, // Example
    // blendLevel: 7,
    subThemesData: const FlexSubThemesData(
      // General settings
      blendOnLevel: 10, // Increase blending slightly
      useMaterial3Typography: true,
      useM2StyleDividerInM3: true,
      defaultRadius: 8.0, // Apply corner radius to most components
      // NavigationRail specific
      navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
      navigationRailIndicatorSchemeColor: SchemeColor.primary,
      navigationRailIndicatorOpacity: 0.20,
      // TODO: Add more specific component themes if needed
      // elevatedButtonTheme: ElevatedButtonThemeData(...),
      // inputDecoratorTheme: InputDecorationTheme(...),
      // cardTheme: CardTheme(...),
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    // To use the Playground font, add GoogleFonts package and uncomment:
    // fontFamily: GoogleFonts.notoSans().fontFamily,
  ).copyWith(
    inputDecorationTheme: _getIOSInputDecorationTheme(
        FlexThemeData.light(scheme: _scheme).colorScheme),
  );

  static final ThemeData darkTheme = FlexThemeData.dark(
    scheme: _scheme,
    useMaterial3: true,
    // Optional customizations:
    // surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold, // Example
    // blendLevel: 13,
    subThemesData: const FlexSubThemesData(
      // General settings
      blendOnLevel: 20, // Increase blending slightly
      useMaterial3Typography: true,
      useM2StyleDividerInM3: true,
      defaultRadius: 8.0, // Apply corner radius to most components
      // NavigationRail specific
      navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
      navigationRailIndicatorSchemeColor: SchemeColor.primary,
      navigationRailIndicatorOpacity: 0.20,
      // TODO: Add more specific component themes if needed
      // elevatedButtonTheme: ElevatedButtonThemeData(...),
      // inputDecoratorTheme: InputDecorationTheme(...),
      // cardTheme: CardTheme(...),
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    // To use the Playground font, add GoogleFonts package and uncomment:
    // fontFamily: GoogleFonts.notoSans().fontFamily,
  ).copyWith(
    inputDecorationTheme: _getIOSInputDecorationTheme(
        FlexThemeData.dark(scheme: _scheme).colorScheme),
  );
}
