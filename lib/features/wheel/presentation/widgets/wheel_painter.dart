import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/wheel_item.dart';

class WheelPainter extends CustomPainter {
  const WheelPainter({required this.items});

  final List<WheelItem> items;

  static const double _borderWidth = 2.0;
  static const double _fontSize = 13.0;
  static const double _textMaxWidthFactor = 0.35;
  static const double _centerHubRadius = 36.0;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    if (items.isEmpty) {
      _drawEmpty(canvas, center, radius);
      return;
    }

    _drawSlices(canvas, center, radius);
    _drawBorders(canvas, center, radius);
    _drawLabels(canvas, center, radius);
    _drawCenterHub(canvas, center);
  }

  void _drawEmpty(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);

    final textStyle = GoogleFonts.poppins(
      color: Colors.grey.shade600,
      fontSize: _fontSize,
      fontWeight: FontWeight.w600,
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: 'No Items',
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      center - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  void _drawSlices(Canvas canvas, Offset center, double radius) {
    final sliceAngle = (2 * math.pi) / items.length;
    final rect = Rect.fromCircle(center: center, radius: radius);

    for (int i = 0; i < items.length; i++) {
      final startAngle = i * sliceAngle - math.pi / 2;
      
      // Flat color from wheelColors array cycling
      final colorIndex = i % AppColors.wheelColors.length;
      final sliceColor = AppColors.wheelColors[colorIndex];

      final paint = Paint()
        ..color = sliceColor
        ..style = PaintingStyle.fill;

      canvas.drawArc(rect, startAngle, sliceAngle, true, paint);
    }
  }

  void _drawBorders(Canvas canvas, Offset center, double radius) {
    final sliceAngle = (2 * math.pi) / items.length;
    
    // Draw white dividing lines between slices
    final dividerPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = _borderWidth
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < items.length; i++) {
      final angle = i * sliceAngle - math.pi / 2;
      canvas.drawLine(
        center,
        Offset(
          center.dx + radius * math.cos(angle),
          center.dy + radius * math.sin(angle),
        ),
        dividerPaint,
      );
    }

    // Draw thick black outer ring
    final outerRingPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, outerRingPaint);
  }

  void _drawLabels(Canvas canvas, Offset center, double radius) {
    final sliceAngle = (2 * math.pi) / items.length;
    final textRadius = radius * _textMaxWidthFactor * 1.8;
    final maxTextWidth = radius * _textMaxWidthFactor * 2;

    for (int i = 0; i < items.length; i++) {
      final midAngle = i * sliceAngle - math.pi / 2 + sliceAngle / 2;

      final textStyle = GoogleFonts.poppins(
        color: Colors.white,
        fontSize: _fontSize,
        fontWeight: FontWeight.bold,
        shadows: [
          const Shadow(
            color: Colors.black45,
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: items[i].title,
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
        maxLines: 1,
        ellipsis: '…',
      )..layout(maxWidth: maxTextWidth);

      final labelCenter = Offset(
        center.dx + textRadius * math.cos(midAngle),
        center.dy + textRadius * math.sin(midAngle),
      );

      canvas.save();
      canvas.translate(labelCenter.dx, labelCenter.dy);

      // Rotate text to follow the slice angle
      double rotation = midAngle;
      if (midAngle > math.pi / 2 && midAngle < 3 * math.pi / 2) {
        rotation += math.pi;
      }
      canvas.rotate(rotation);

      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );

      canvas.restore();
    }
  }

  void _drawCenterHub(Canvas canvas, Offset center) {
    // Draw white filled circle
    final hubPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, _centerHubRadius, hubPaint);

    // Draw black border
    final borderPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, _centerHubRadius, borderPaint);

    // Draw "SPIN" text in center
    final textStyle = GoogleFonts.poppins(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.0,
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: 'SPIN',
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();

    textPainter.paint(
      canvas,
      center - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(WheelPainter oldDelegate) => oldDelegate.items != items;
}
