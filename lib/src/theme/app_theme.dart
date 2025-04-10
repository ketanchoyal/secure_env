import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

// Using FlexColorScheme for easier theme management
class AppTheme {
  // Define the scheme
  static const FlexScheme _scheme = FlexScheme.barossa; // Changed scheme

  static final ThemeData lightTheme = FlexThemeData.light(
    scheme: _scheme,
    useMaterial3: true,
    // Optional customizations:
    // surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold, // Example
    // blendLevel: 7,
    subThemesData: const FlexSubThemesData(
      // General settings
      blendOnLevel: 10, // Increase blending slightly
      useTextTheme: true,
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
      useTextTheme: true,
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
  );
}
