import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/wheel_item.dart';
import 'wheel_editor_state.dart';

class WheelEditorNotifier extends Notifier<WheelEditorState> {
  static const _uuid = Uuid();

  @override
  WheelEditorState build() {
    return WheelEditorState(
      name: '',
      items: [
        WheelItem(
          id: _uuid.v4(),
          title: 'Option 1',
          color: Colors.red,
          createdAt: DateTime.now(),
        ),
        WheelItem(
          id: _uuid.v4(),
          title: 'Option 2',
          color: Colors.blue,
          createdAt: DateTime.now(),
        ),
      ],
    );
  }

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void toggleRemoveWinner() {
    state = state.copyWith(removeWinner: !state.removeWinner);
  }

  void addItem() {
    if (state.items.length >= WheelEditorState.maxItems) {
      return;
    }

    final newItem = WheelItem(
      id: _uuid.v4(),
      title: 'Option ${state.items.length + 1}',
      color: _getNextColor(),
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      items: [...state.items, newItem],
    );
  }

  void addItemWithDetails(String title, Color color) {
    if (state.items.length >= WheelEditorState.maxItems) {
      return;
    }

    final newItem = WheelItem(
      id: _uuid.v4(),
      title: title,
      color: color,
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      items: [...state.items, newItem],
    );
  }

  void removeItem(int index) {
    if (state.items.length <= WheelEditorState.minItems) {
      return;
    }

    final updatedItems = List<WheelItem>.from(state.items);
    updatedItems.removeAt(index);
    state = state.copyWith(items: updatedItems);
  }

  void updateItem(int index, String title) {
    if (index < 0 || index >= state.items.length) return;

    final updatedItems = List<WheelItem>.from(state.items);
    updatedItems[index] = updatedItems[index].copyWith(title: title);
    state = state.copyWith(items: updatedItems);
  }

  void updateItemColor(int index, Color color) {
    if (index < 0 || index >= state.items.length) return;

    final updatedItems = List<WheelItem>.from(state.items);
    updatedItems[index] = updatedItems[index].copyWith(color: color);
    state = state.copyWith(items: updatedItems);
  }

  void reset() {
    state = WheelEditorState(
      name: '',
      items: [
        WheelItem(
          id: _uuid.v4(),
          title: 'Option 1',
          color: Colors.red,
          createdAt: DateTime.now(),
        ),
        WheelItem(
          id: _uuid.v4(),
          title: 'Option 2',
          color: Colors.blue,
          createdAt: DateTime.now(),
        ),
      ],
    );
  }

  void loadWheel(String id, String name, List<WheelItem> items, {bool removeWinner = false}) {
    state = WheelEditorState(
      name: name,
      items: items,
      editingWheelId: id,
      removeWinner: removeWinner,
    );
  }

  Color _getNextColor() {
    final colors = _getPresetColors();
    final usedColors = state.items.map((item) => item.color).toSet();
    
    for (final color in colors) {
      if (!usedColors.contains(color)) {
        return color;
      }
    }
    
    return colors[state.items.length % colors.length];
  }

  List<Color> _getPresetColors() {
    return [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.amber,
      Colors.cyan,
      Colors.indigo,
      Colors.lime,
      Colors.deepOrange,
      const Color(0xFF6750A4), // AppColors.primary
      const Color(0xFF9C27B0), // AppColors.secondary
      const Color(0xFF4CAF50), // AppColors.success
      const Color(0xFFFF9800), // AppColors.warning
    ];
  }
}

final wheelEditorProvider =
    NotifierProvider<WheelEditorNotifier, WheelEditorState>(
  WheelEditorNotifier.new,
);
