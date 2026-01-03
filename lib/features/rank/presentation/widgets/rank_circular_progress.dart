import 'dart:math';

import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Theme/colors.dart';

class RankCircularProgress extends StatelessWidget {
  final double percent; // 0.0 -> 1.0
  final double size;

  const RankCircularProgress({
    super.key,
    required this.percent,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _RankRingPainter(percent: percent),
    );
  }
}

class _RankRingPainter extends CustomPainter {
  final double percent; // 0.0 -> 1.0

  _RankRingPainter({required this.percent});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2 - 20;

    /// bán nguyệt 180°
    const totalAngle = -pi;
    final startAngle = pi;

    /// 1️⃣ Vẽ nền (inactive – cả bán nguyệt)
    _drawFlatArc(canvas, center, radius, startAngle, totalAngle);

    /// 2️⃣ Vẽ tiến trình (active – theo %)
    final activeSweep = totalAngle * percent.clamp(0.0, 1.0);
    if (activeSweep != 0) {
      _draw3DArc(canvas, center, radius, startAngle, activeSweep);
    }
  }

  /// 🔥 ARC 3D (active)
  void _draw3DArc(
      Canvas canvas,
      Offset center,
      double radius,
      double start,
      double sweep,
      ) {
    final rect = Rect.fromCircle(center: center, radius: radius);

    /// Shadow
    final shadowPaint = Paint()
      ..color = const Color(0xFF6B3F00).withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.butt
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    canvas.drawArc(
      rect.translate(0, 4),
      start,
      sweep,
      false,
      shadowPaint,
    );

    /// Main gradient
    final mainPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFFA0A0),
          Color(0xFFFF6060),
          Color(0xFFF86D6D),
        ],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.butt;

    canvas.drawArc(rect, start, sweep, false, mainPaint);

    /// Highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.butt
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    canvas.drawArc(
      rect.translate(0, -2),
      start,
      sweep,
      false,
      highlightPaint,
    );
  }

  /// nền trắng/xám
  void _drawFlatArc(
      Canvas canvas,
      Offset center,
      double radius,
      double start,
      double sweep,
      ) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.butt;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      start,
      sweep,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _RankRingPainter oldDelegate) =>
      oldDelegate.percent != percent;
}


