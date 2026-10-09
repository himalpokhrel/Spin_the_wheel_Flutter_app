import 'package:flutter/material.dart';

class WheelItem {
  const WheelItem({
    required this.id,
    required this.title,
    required this.color,
    required this.createdAt,
  });

  final String id;
  final String title;
  final Color color;
  final DateTime createdAt;

  WheelItem copyWith({
    String? id,
    String? title,
    Color? color,
    DateTime? createdAt,
  }) {
    return WheelItem(
      id: id ?? this.id,
      title: title ?? this.title,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WheelItem &&
        other.id == id &&
        other.title == title &&
        other.color == color &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode => Object.hash(id, title, color, createdAt);
}