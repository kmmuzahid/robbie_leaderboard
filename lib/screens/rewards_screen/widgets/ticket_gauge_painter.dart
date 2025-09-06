import 'dart:math' as math;

import 'package:flutter/material.dart';

class TicketGaugePainter extends CustomPainter {
  final int currentTickets;
  final int dayIndex;

  TicketGaugePainter({required this.currentTickets, required this.dayIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Parameters for the horizontal arc (left to right)
    const startAngle = math.pi; // 180 degrees (left side)
    const sweepAngle = math.pi; // 180 degrees (to right side)

    // Background arc (darker gray)
    final bgPaint = Paint()
      ..color = Colors.grey.shade700.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.butt; // Changed from round to butt

    // canvas.drawArc(
    //   Rect.fromCircle(center: center, radius: radius),
    //   startAngle,
    //   sweepAngle,
    //   false,
    //   bgPaint,
    // );

    // Calculate progress - we'll hardcode the gauge to show approximately 75% filled
    // based on your screenshot
    var progress = dayIndex / 7;
    var progressAngle = sweepAngle * progress;

    // Progress arc (white)
    final progressPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.butt; // Changed from round to butt

    // canvas.drawArc(
    //   Rect.fromCircle(center: center, radius: radius),
    //   startAngle,
    //   progressAngle,
    //   false,
    //   progressPaint,
    // );

    // Draw tick marks
    for (int i = 0; i <= 40; i++) {
      final angle = startAngle + (sweepAngle * i / 40);
      final bool isLit = i <= (40 * progress);

      final tickPaint = Paint()
        ..color = isLit ? Colors.white : Colors.grey.shade700.withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      // Draw tick marks as short lines
      final outerPoint = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );

      final innerPoint = Offset(
        center.dx + (radius - 12) * math.cos(angle),
        center.dy + (radius - 12) * math.sin(angle),
      );

      canvas.drawLine(innerPoint, outerPoint, tickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
