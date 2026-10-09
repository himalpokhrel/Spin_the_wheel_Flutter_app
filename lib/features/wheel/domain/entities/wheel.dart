import 'package:flutter/foundation.dart';

import 'wheel_item.dart';

class Wheel {
  const Wheel({
    required this.id,
    required this.name,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
    this.removeWinner = false,
  });

  final String id;
  final String name;
  final List<WheelItem> items;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool removeWinner;

  Wheel copyWith({
    String? id,
    String? name,
    List<WheelItem>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? removeWinner,
  }) {
    return Wheel(
      id: id ?? this.id,
      name: name ?? this.name,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      removeWinner: removeWinner ?? this.removeWinner,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Wheel &&
        other.id == id &&
        other.name == name &&
        listEquals(other.items, items) &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.removeWinner == removeWinner;
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        Object.hashAll(items),
        createdAt,
        updatedAt,
        removeWinner,
      );
}