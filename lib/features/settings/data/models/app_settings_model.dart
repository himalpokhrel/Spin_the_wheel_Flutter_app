import 'dart:convert';

import '../../domain/entities/app_settings.dart';

class AppSettingsModel extends AppSettings {
  const AppSettingsModel({
    required super.isDarkMode,
    required super.soundEnabled,
    required super.hapticEnabled,
  });

  factory AppSettingsModel.fromEntity(AppSettings settings) {
    return AppSettingsModel(
      isDarkMode: settings.isDarkMode,
      soundEnabled: settings.soundEnabled,
      hapticEnabled: settings.hapticEnabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isDarkMode': isDarkMode,
      'soundEnabled': soundEnabled,
      'hapticEnabled': hapticEnabled,
    };
  }

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
      isDarkMode: json['isDarkMode'] as bool? ?? false,
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      hapticEnabled: json['hapticEnabled'] as bool? ?? true,
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory AppSettingsModel.fromJsonString(String jsonString) {
    return AppSettingsModel.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  }
}
