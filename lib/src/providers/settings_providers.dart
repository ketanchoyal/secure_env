import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:secure_env_core/secure_env_core.dart';
import 'package:secure_env_gui/src/services/logging_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_providers.g.dart';

/// State class for managing app settings
@immutable
class AppSettings {
  final ThemeMode themeMode;
  final bool isVerboseLogging;
  final String? lastProjectPath;
  final String? lastEnvironmentName;
  final List<RecentProject> recentProjects;
  final Duration autoSaveInterval;
  final String fontFamily;

  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.isVerboseLogging = false,
    this.lastProjectPath,
    this.lastEnvironmentName,
    this.recentProjects = const [],
    this.autoSaveInterval = const Duration(milliseconds: 200),
    this.fontFamily = 'Anta',
  });

  AppSettings copyWith({
    ThemeMode? themeMode,
    bool? isVerboseLogging,
    String? lastProjectPath,
    String? lastEnvironmentName,
    List<RecentProject>? recentProjects,
    Duration? autoSaveInterval,
    String? fontFamily,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      isVerboseLogging: isVerboseLogging ?? this.isVerboseLogging,
      lastProjectPath: lastProjectPath ?? this.lastProjectPath,
      lastEnvironmentName: lastEnvironmentName ?? this.lastEnvironmentName,
      recentProjects: recentProjects ?? this.recentProjects,
      autoSaveInterval: autoSaveInterval ?? this.autoSaveInterval,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode.name,
      'isVerboseLogging': isVerboseLogging,
      'lastProjectPath': lastProjectPath,
      'lastEnvironmentName': lastEnvironmentName,
      'recentProjects': recentProjects.map((p) => p.toJson()).toList(),
      'autoSaveInterval': autoSaveInterval.inMilliseconds,
      'fontFamily': fontFamily,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      themeMode: ThemeMode.values.firstWhere(
        (mode) => mode.name == json['themeMode'],
        orElse: () => ThemeMode.system,
      ),
      isVerboseLogging: json['isVerboseLogging'] as bool? ?? false,
      lastProjectPath: json['lastProjectPath'] as String?,
      lastEnvironmentName: json['lastEnvironmentName'] as String?,
      recentProjects: (json['recentProjects'] as List?)
              ?.map((e) => RecentProject.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      autoSaveInterval: Duration(
        milliseconds: json['autoSaveInterval'] as int? ?? 200,
      ),
      fontFamily: json['fontFamily'] as String? ?? 'ABeeZee',
    );
  }
}

/// Model class for recent projects
@immutable
class RecentProject {
  final String name;
  final String path;
  final DateTime lastAccessed;

  const RecentProject({
    required this.name,
    required this.path,
    required this.lastAccessed,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'lastAccessed': lastAccessed.toIso8601String(),
    };
  }

  factory RecentProject.fromJson(Map<String, dynamic> json) {
    return RecentProject(
      name: json['name'] as String,
      path: json['path'] as String,
      lastAccessed: DateTime.parse(json['lastAccessed'] as String),
    );
  }
}

/// Provider for managing app settings
@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  static const _settingsKey = 'app_settings';

  @override
  AppSettings build() {
    _loadSettings();
    return const AppSettings();
  }

  Logger get logger => ref.read(loggerProvider(SettingsNotifier));

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_settingsKey);
      if (jsonStr != null) {
        final settings = AppSettings.fromJson(jsonDecode(jsonStr));
        state = settings;
      }
    } catch (e, stack) {
      logger.error('Failed to load settings: $e', e, stack);
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_settingsKey, jsonEncode(state.toJson()));
    } catch (e, stack) {
      logger.error('Failed to save settings: $e', e, stack);
    }
  }

  void toggleDarkMode(ThemeMode themeMode) {
    state = state.copyWith(themeMode: themeMode);
    _saveSettings();
  }

  void toggleVerboseLogging() {
    state = state.copyWith(isVerboseLogging: !state.isVerboseLogging);
    _saveSettings();
  }

  void setLastProjectPath(String path) {
    state = state.copyWith(lastProjectPath: path);
    _saveSettings();
  }

  void setLastEnvironmentName(String name) {
    state = state.copyWith(lastEnvironmentName: name);
    _saveSettings();
  }

  void addRecentProject(String name, String path) {
    final recentProject = RecentProject(
      name: name,
      path: path,
      lastAccessed: DateTime.now(),
    );

    final updatedProjects = List<RecentProject>.from(state.recentProjects)
      ..removeWhere((p) => p.name == name)
      ..insert(0, recentProject);

    // Keep only the 10 most recent projects
    if (updatedProjects.length > 10) {
      updatedProjects.removeRange(10, updatedProjects.length);
    }

    state = state.copyWith(recentProjects: updatedProjects);
    _saveSettings();
  }

  void removeRecentProject(String name) {
    final updatedProjects = List<RecentProject>.from(state.recentProjects)
      ..removeWhere((p) => p.name == name);

    state = state.copyWith(recentProjects: updatedProjects);
    _saveSettings();
  }

  void setAutoSaveInterval(Duration interval) {
    state = state.copyWith(autoSaveInterval: interval);
    _saveSettings();
  }

  void setFontFamily(String family) {
    state = state.copyWith(fontFamily: family);
    _saveSettings();
  }
}
