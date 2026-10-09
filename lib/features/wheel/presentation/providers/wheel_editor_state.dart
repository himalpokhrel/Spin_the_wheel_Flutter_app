import 'package:flutter/foundation.dart';

import '../../domain/entities/wheel_item.dart';

@immutable
class WheelEditorState {
  const WheelEditorState({
    required this.name,
    required this.items,
    this.editingWheelId,
    this.removeWinner = false,
  });

  final String name;
  final List<WheelItem> items;
  final String? editingWheelId;
  final bool removeWinner;

  static const int maxWheelNameLength = 40;
  static const int maxItemLabelLength = 30;
  static const int minItems = 2;
  static const int maxItems = 20;

  bool get isValid {
    if (name.trim().isEmpty) return false;
    if (name.length > maxWheelNameLength) return false;
    if (items.length < minItems || items.length > maxItems) return false;

    for (final item in items) {
      if (item.title.trim().isEmpty) return false;
      if (item.title.length > maxItemLabelLength) return false;
    }

    return true;
  }

  String? get nameError {
    if (name.trim().isEmpty) {
      return 'Wheel name is required';
    }
    if (name.length > maxWheelNameLength) {
      return 'Wheel name must be $maxWheelNameLength characters or less';
    }
    return null;
  }

  String? get itemsError {
    if (items.length < minItems) {
      return 'At least $minItems items are required';
    }
    if (items.length > maxItems) {
      return 'Maximum $maxItems items allowed';
    }
    return null;
  }

  String? getItemError(int index) {
    if (index < 0 || index >= items.length) return null;
    
    final item = items[index];
    if (item.title.trim().isEmpty) {
      return 'Item title is required';
    }
    if (item.title.length > maxItemLabelLength) {
      return 'Max $maxItemLabelLength characters';
    }
    return null;
  }

  WheelEditorState copyWith({
    String? name,
    List<WheelItem>? items,
    String? editingWheelId,
    bool? removeWinner,
  }) {
    return WheelEditorState(
      name: name ?? this.name,
      items: items ?? this.items,
      editingWheelId: editingWheelId ?? this.editingWheelId,
      removeWinner: removeWinner ?? this.removeWinner,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WheelEditorState &&
        other.name == name &&
        listEquals(other.items, items) &&
        other.editingWheelId == editingWheelId &&
        other.removeWinner == removeWinner;
  }

  @override
  int get hashCode => Object.hash(
        name,
        Object.hashAll(items),
        editingWheelId,
        removeWinner,
      );
}
