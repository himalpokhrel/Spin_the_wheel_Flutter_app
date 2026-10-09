import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/spin_history_model.dart';

class HistoryLocalDatasource {
  HistoryLocalDatasource(this._prefs);

  final SharedPreferences _prefs;
  static const String _historyKey = 'spin_history';

  Future<List<SpinHistoryModel>> getHistory() async {
    final String? jsonString = _prefs.getString(_historyKey);
    if (jsonString == null) {
      return [];
    }

    try {
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => SpinHistoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // If there's an error parsing, return empty list
      return [];
    }
  }

  Future<void> saveHistory(List<SpinHistoryModel> history) async {
    final List<Map<String, dynamic>> jsonList =
        history.map((entry) => entry.toJson()).toList();
    final String jsonString = json.encode(jsonList);
    await _prefs.setString(_historyKey, jsonString);
  }

  Future<void> clearHistory() async {
    await _prefs.remove(_historyKey);
  }
}
