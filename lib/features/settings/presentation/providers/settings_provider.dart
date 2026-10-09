import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/settings_local_datasource.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';

// Provider for SharedPreferences
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

// Provider for SettingsLocalDataSource
final settingsLocalDataSourceProvider = Provider<SettingsLocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider).maybeWhen(
        data: (prefs) => prefs,
        orElse: () => throw Exception('SharedPreferences not initialized'),
      );
  return SettingsLocalDataSource(prefs);
});

// Provider for SettingsRepository
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final dataSource = ref.watch(settingsLocalDataSourceProvider);
  return SettingsRepositoryImpl(dataSource);
});

// Settings Notifier
class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    _loadSettings();
    return AppSettings.defaultSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final repository = ref.read(settingsRepositoryProvider);
      final settings = await repository.getSettings();
      state = settings;
    } catch (e) {
      // Keep default settings if loading fails
      state = AppSettings.defaultSettings();
    }
  }

  Future<void> toggleDarkMode() async {
    final newSettings = state.copyWith(isDarkMode: !state.isDarkMode);
    state = newSettings;
    await _saveSettings(newSettings);
  }

  Future<void> toggleSound() async {
    final newSettings = state.copyWith(soundEnabled: !state.soundEnabled);
    state = newSettings;
    await _saveSettings(newSettings);
  }

  Future<void> toggleHaptic() async {
    final newSettings = state.copyWith(hapticEnabled: !state.hapticEnabled);
    state = newSettings;
    await _saveSettings(newSettings);
  }

  Future<void> _saveSettings(AppSettings settings) async {
    try {
      final repository = ref.read(settingsRepositoryProvider);
      await repository.saveSettings(settings);
    } catch (e) {
      // Silent fail - settings are still updated in UI
    }
  }
}

// Settings Provider
final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(() {
  return SettingsNotifier();
});
