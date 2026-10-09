import 'package:flutter/material.dart';

import '../../domain/entities/wheel_item.dart';

class WheelItemModel extends WheelItem {
  const WheelItemModel({
    required super.id,
    required super.title,
    required super.color,
    required super.createdAt,
  });

  factory WheelItemModel.fromJson(Map<String, dynamic> json) {
    return WheelItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      color: Color(json['color'] as int),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'color': color.toARGB32(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory WheelItemModel.fromEntity(WheelItem item) {
    return WheelItemModel(
      id: item.id,
      title: item.title,
      color: item.color,
      createdAt: item.createdAt,
    );
  }
}
