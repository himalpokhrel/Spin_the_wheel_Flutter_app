import 'package:flutter/material.dart';

class SpinHistory {
  const SpinHistory({
    required this.id,
    required this.wheelId,
    required this.wheelName,
    required this.winnerTitle,
    required this.winnerColor,
    required this.timestamp,
  });

  final String id;
  final String wheelId;
  final String wheelName;
  final String winnerTitle;
  final Color winnerColor;
  final DateTime timestamp;

  SpinHistory copyWith({
    String? id,
    String? wheelId,
    String? wheelName,
    String? winnerTitle,
    Color? winnerColor,
    DateTime? timestamp,
  }) {
    return SpinHistory(
      id: id ?? this.id,
      wheelId: wheelId ?? this.wheelId,
      wheelName: wheelName ?? this.wheelName,
      winnerTitle: winnerTitle ?? this.winnerTitle,
      winnerColor: winnerColor ?? this.winnerColor,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SpinHistory &&
        other.id == id &&
        other.wheelId == wheelId &&
        other.wheelName == wheelName &&
        other.winnerTitle == winnerTitle &&
        other.winnerColor == winnerColor &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode => Object.hash(
        id,
        wheelId,
        wheelName,
        winnerTitle,
        winnerColor,
        timestamp,
      );
}
