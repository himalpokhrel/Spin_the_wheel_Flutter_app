import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/wheel_model.dart';

class WheelLocalDataSource {
  WheelLocalDataSource(this._prefs);

  final SharedPreferences _prefs;
  static const String _wheelsKey = 'wheels';

  Future<List<WheelModel>> getWheels() async {
    try {
      final String? wheelsJson = _prefs.getString(_wheelsKey);
      
      if (wheelsJson == null) {
        return [];
      }

      final List<dynamic> wheelsList = jsonDecode(wheelsJson) as List<dynamic>;
      return wheelsList
          .map((json) => WheelModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load wheels: $e');
    }
  }

  Future<void> saveWheels(List<WheelModel> wheels) async {
    try {
      final List<Map<String, dynamic>> wheelsJson =
          wheels.map((wheel) => wheel.toJson()).toList();
      
      final String encodedWheels = jsonEncode(wheelsJson);
      await _prefs.setString(_wheelsKey, encodedWheels);
    } catch (e) {
      throw Exception('Failed to save wheels: $e');
    }
  }
}
