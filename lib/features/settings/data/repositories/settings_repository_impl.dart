import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_datasource.dart';
import '../models/app_settings_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource _dataSource;

  SettingsRepositoryImpl(this._dataSource);

  @override
  Future<AppSettings> getSettings() async {
    try {
      return await _dataSource.getSettings();
    } catch (e) {
      // Return default settings if there's an error
      return AppSettings.defaultSettings();
    }
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    try {
      final model = AppSettingsModel.fromEntity(settings);
      await _dataSource.saveSettings(model);
    } catch (e) {
      throw Exception('Failed to save settings: $e');
    }
  }
}
