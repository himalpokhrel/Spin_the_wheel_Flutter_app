import 'package:flutter/material.dart';

import '../../domain/entities/spin_history.dart';

class SpinHistoryModel extends SpinHistory {
  const SpinHistoryModel({
    required super.id,
    required super.wheelId,
    required super.wheelName,
    required super.winnerTitle,
    required super.winnerColor,
    required super.timestamp,
  });

  factory SpinHistoryModel.fromJson(Map<String, dynamic> json) {
    return SpinHistoryModel(
      id: json['id'] as String,
      wheelId: json['wheelId'] as String,
      wheelName: json['wheelName'] as String,
      winnerTitle: json['winnerTitle'] as String,
      winnerColor: Color(json['winnerColor'] as int),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'wheelId': wheelId,
      'wheelName': wheelName,
      'winnerTitle': winnerTitle,
      'winnerColor': winnerColor.toARGB32(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory SpinHistoryModel.fromEntity(SpinHistory history) {
    return SpinHistoryModel(
      id: history.id,
      wheelId: history.wheelId,
      wheelName: history.wheelName,
      winnerTitle: history.winnerTitle,
      winnerColor: history.winnerColor,
      timestamp: history.timestamp,
    );
  }
}
