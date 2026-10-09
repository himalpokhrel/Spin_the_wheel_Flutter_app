import 'package:flutter/services.dart';

class HapticsHelper {
  const HapticsHelper._();

  static Future<void> lightImpact(bool enabled) async {
    if (!enabled) return;
    
    try {
      await HapticFeedback.lightImpact();
    } catch (e) {
      // Silent fail - haptics might not be supported on all devices
    }
  }

  static Future<void> heavyImpact(bool enabled) async {
    if (!enabled) return;
    
    try {
      await HapticFeedback.heavyImpact();
    } catch (e) {
      // Silent fail - haptics might not be supported on all devices
    }
  }

  static Future<void> selectionClick(bool enabled) async {
    if (!enabled) return;
    
    try {
      await HapticFeedback.selectionClick();
    } catch (e) {
      // Silent fail - haptics might not be supported on all devices
    }
  }
}
