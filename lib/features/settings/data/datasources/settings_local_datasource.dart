import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_settings_model.dart';

class SettingsLocalDataSource {
  static const String _settingsKey = 'app_settings';
  final SharedPreferences _prefs;

  SettingsLocalDataSource(this._prefs);

  Future<AppSettingsModel> getSettings() async {
    try {
      final jsonString = _prefs.getString(_settingsKey);
      if (jsonString == null) {
        // Return default settings if none are saved
        return AppSettingsModel.fromEntity(AppSettingsModel(
          isDarkMode: false,
          soundEnabled: true,
          hapticEnabled: true,
        ));
      }
      return AppSettingsModel.fromJsonString(jsonString);
    } catch (e) {
      // If there's any error, return default settings
      return AppSettingsModel.fromEntity(AppSettingsModel(
        isDarkMode: false,
        soundEnabled: true,
        hapticEnabled: true,
      ));
    }
  }

  Future<void> saveSettings(AppSettingsModel settings) async {
    try {
      await _prefs.setString(_settingsKey, settings.toJsonString());
    } catch (e) {
      throw Exception('Failed to save settings: $e');
    }
  }
}
