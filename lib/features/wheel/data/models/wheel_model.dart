import '../../domain/entities/wheel.dart';
import 'wheel_item_model.dart';

class WheelModel extends Wheel {
  const WheelModel({
    required super.id,
    required super.name,
    required super.items,
    required super.createdAt,
    required super.updatedAt,
    super.removeWinner,
  });

  factory WheelModel.fromJson(Map<String, dynamic> json) {
    final itemsList = (json['items'] as List<dynamic>)
        .map((item) => WheelItemModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return WheelModel(
      id: json['id'] as String,
      name: json['name'] as String,
      items: itemsList,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      removeWinner: json['removeWinner'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'items': items
          .map((item) => WheelItemModel.fromEntity(item).toJson())
          .toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'removeWinner': removeWinner,
    };
  }

  factory WheelModel.fromEntity(Wheel wheel) {
    return WheelModel(
      id: wheel.id,
      name: wheel.name,
      items: wheel.items,
      createdAt: wheel.createdAt,
      updatedAt: wheel.updatedAt,
      removeWinner: wheel.removeWinner,
    );
  }
}
