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
        color: colorScheme.onSurface.withOpacity(0.7),
        fontSize: 16,
      ),
      hintStyle: TextStyle(
        color: colorScheme.onSurface.withOpacity(0.5),
        fontSize: 16,
      ),
      errorStyle: TextStyle(
        color: colorScheme.error,
        fontSize: 13,
      ),
      prefixIconColor: colorScheme.primary,
      suffixIconColor: colorScheme.onSurface.withOpacity(0.7),
    );
  }

  static final ThemeData lightTheme = FlexThemeData.light(
    scheme: _scheme,
    useMaterial3: true,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 6,
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
    fontFamily: 'SF Pro Display',
  ).copyWith(
    inputDecorationTheme: _getIOSInputDecorationTheme(
        FlexThemeData.light(scheme: _scheme).colorScheme),
    cardTheme: CardTheme(
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_defaultRadius),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0.5,
      iconTheme: IconThemeData(color: Color(0xFF007AFF)),
      titleTextStyle: TextStyle(
          color: Color(0xFF1C1C1E), fontSize: 20, fontWeight: FontWeight.w600),
    ),
  );

  static ThemeData get darkTheme => FlexThemeData.dark(
        scheme: _scheme,
        useMaterial3: true,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffoldVariantDialog,
        blendLevel: 12,
        useMaterial3ErrorColors: true,
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
        fontFamily: 'SF Pro Display',
      ).copyWith(
        inputDecorationTheme: _getIOSInputDecorationTheme(
            FlexThemeData.dark(scheme: _scheme).colorScheme),
        cardTheme: CardTheme(
          elevation: 0.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_defaultRadius),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2C2C2E),
          elevation: 0.5,
          iconTheme: IconThemeData(color: Color(0xFF0A84FF)),
          titleTextStyle: TextStyle(
              color: Color(0xFFF2F2F7),
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
      );
}
