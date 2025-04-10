import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:secure_env_gui/src/services/logging_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_providers.g.dart';

/// State class for managing app settings
@immutable
class AppSettings {
  final bool isDarkMode;
  final bool isVerboseLogging;
  final String? lastProjectPath;
  final String? lastEnvironmentName;
  final List<RecentProject> recentProjects;
  final bool autoSave;
  final Duration autoSaveInterval;

  const AppSettings({
    this.isDarkMode = false,
    this.isVerboseLogging = false,
    this.lastProjectPath,
    this.lastEnvironmentName,
    this.recentProjects = const [],
    this.autoSave = true,
    this.autoSaveInterval = const Duration(minutes: 5),
  });

  AppSettings copyWith({
    bool? isDarkMode,
    bool? isVerboseLogging,
    String? lastProjectPath,
    String? lastEnvironmentName,
    List<RecentProject>? recentProjects,
    bool? autoSave,
    Duration? autoSaveInterval,
  }) {
    return AppSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isVerboseLogging: isVerboseLogging ?? this.isVerboseLogging,
      lastProjectPath: lastProjectPath ?? this.lastProjectPath,
      lastEnvironmentName: lastEnvironmentName ?? this.lastEnvironmentName,
      recentProjects: recentProjects ?? this.recentProjects,
      autoSave: autoSave ?? this.autoSave,
      autoSaveInterval: autoSaveInterval ?? this.autoSaveInterval,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isDarkMode': isDarkMode,
      'isVerboseLogging': isVerboseLogging,
      'lastProjectPath': lastProjectPath,
      'lastEnvironmentName': lastEnvironmentName,
      'recentProjects': recentProjects.map((p) => p.toJson()).toList(),
      'autoSave': autoSave,
      'autoSaveInterval': autoSaveInterval.inMinutes,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      isDarkMode: json['isDarkMode'] as bool? ?? false,
      isVerboseLogging: json['isVerboseLogging'] as bool? ?? false,
      lastProjectPath: json['lastProjectPath'] as String?,
      lastEnvironmentName: json['lastEnvironmentName'] as String?,
      recentProjects:
          (json['recentProjects'] as List?)
              ?.map((e) => RecentProject.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      autoSave: json['autoSave'] as bool? ?? true,
      autoSaveInterval: Duration(
        minutes: json['autoSaveInterval'] as int? ?? 5,
      ),
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

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_settingsKey);
      if (jsonStr != null) {
        final settings = AppSettings.fromJson(jsonDecode(jsonStr));
        state = settings;
      }
    } catch (e, stack) {
      ref.read(loggerProvider).error('Failed to load settings: $e');
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_settingsKey, jsonEncode(state.toJson()));
    } catch (e, stack) {
      ref.read(loggerProvider).error('Failed to save settings: $e');
    }
  }

  void toggleDarkMode() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
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

    final updatedProjects =
        List<RecentProject>.from(state.recentProjects)
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

  void setAutoSave(bool enabled) {
    state = state.copyWith(autoSave: enabled);
    _saveSettings();
  }

  void setAutoSaveInterval(Duration interval) {
    state = state.copyWith(autoSaveInterval: interval);
    _saveSettings();
  }
}

/// Provider for the app's theme data
@riverpod
ThemeData theme(ThemeRef ref) {
  final settings = ref.watch(settingsNotifierProvider);
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: settings.isDarkMode ? Brightness.dark : Brightness.light,
    ),
    useMaterial3: true,
  );
}
