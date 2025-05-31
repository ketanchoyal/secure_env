import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

// Polished iOS-inspired FlexColorScheme theme
class AppTheme {
  static const FlexScheme _scheme =
      FlexScheme.barossa; // You can change this to custom if you want

  // Custom iOS-like sub-theme data for polish
  static const double _defaultRadius = 10.0;
  static const double _buttonRadius = 16.0;

  static InputDecorationTheme _getIOSInputDecorationTheme(
      ColorScheme colorScheme) {
    return InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_defaultRadius),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_defaultRadius),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_defaultRadius),
        borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_defaultRadius),
        borderSide: BorderSide(color: colorScheme.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_defaultRadius),
        borderSide: BorderSide(color: colorScheme.error, width: 1.5),
      ),
      labelStyle: TextStyle(
        color: colorScheme.onSurface.withValues(alpha: 0.7),
        fontSize: 16,
      ),
      hintStyle: TextStyle(
        color: colorScheme.onSurface.withValues(alpha: 0.5),
        fontSize: 16,
      ),
      errorStyle: TextStyle(
        color: colorScheme.error,
        fontSize: 13,
      ),
      prefixIconColor: colorScheme.primary,
      suffixIconColor: colorScheme.onSurface.withValues(alpha: 0.7),
    );
  }

  static final ThemeData lightTheme = FlexThemeData.light(
    scheme: _scheme,
    useMaterial3: true,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 6,
    appBarStyle: FlexAppBarStyle.background,
    transparentStatusBar: true,
    appBarElevation: 0.5,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 10,
      useMaterial3Typography: true,
      useM2StyleDividerInM3: true,
      defaultRadius: _defaultRadius,
      elevatedButtonRadius: _buttonRadius,
      outlinedButtonRadius: _buttonRadius,
      textButtonRadius: _buttonRadius,
      cardRadius: _defaultRadius,
      dialogRadius: _defaultRadius,
      inputDecoratorRadius: _defaultRadius,
      navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
      navigationRailIndicatorSchemeColor: SchemeColor.primary,
      navigationRailIndicatorOpacity: 0.20,
      fabRadius: _buttonRadius,
      bottomSheetRadius: _defaultRadius,
      chipRadius: _defaultRadius,
      popupMenuRadius: _defaultRadius,
      menuRadius: _defaultRadius,
      tooltipRadius: _defaultRadius,
      // Removed unsupported tabBarItemRadius
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
  ).copyWith(
    inputDecorationTheme: _getIOSInputDecorationTheme(
        FlexThemeData.light(scheme: _scheme).colorScheme),
    cardTheme: CardThemeData(
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_defaultRadius),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: null, // Let FlexColorScheme blend app bar
      elevation: 0.5,
      iconTheme: IconThemeData(color: Color(0xFF007AFF)),
    ),
  );

  static ThemeData get darkTheme => FlexThemeData.dark(
        scheme: _scheme,
        useMaterial3: true,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffoldVariantDialog,
        blendLevel: 12,
        useMaterial3ErrorColors: true,
        appBarStyle: FlexAppBarStyle.background,
        transparentStatusBar: true,
        appBarElevation: 0.5,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 20,
          useMaterial3Typography: true,
          useM2StyleDividerInM3: true,
          defaultRadius: _defaultRadius,
          elevatedButtonRadius: _buttonRadius,
          outlinedButtonRadius: _buttonRadius,
          textButtonRadius: _buttonRadius,
          cardRadius: _defaultRadius,
          dialogRadius: _defaultRadius,
          inputDecoratorRadius: _defaultRadius,
          navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
          navigationRailIndicatorSchemeColor: SchemeColor.primary,
          navigationRailIndicatorOpacity: 0.20,
          fabRadius: _buttonRadius,
          bottomSheetRadius: _defaultRadius,
          chipRadius: _defaultRadius,
          popupMenuRadius: _defaultRadius,
          menuRadius: _defaultRadius,
          tooltipRadius: _defaultRadius,
          // Removed unsupported tabBarItemRadius
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
      ).copyWith(
        inputDecorationTheme: _getIOSInputDecorationTheme(
            FlexThemeData.dark(scheme: _scheme).colorScheme),
        cardTheme: CardThemeData(
          elevation: 0.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_defaultRadius),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: null, // Let FlexColorScheme blend app bar
          elevation: 0.5,
          iconTheme: IconThemeData(color: Color(0xFF0A84FF)),
        ),
      );
}
