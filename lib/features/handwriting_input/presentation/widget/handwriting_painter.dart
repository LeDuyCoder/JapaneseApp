import 'package:flutter/material.dart';

class HandwritingPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final List<Offset> currentStroke;

  HandwritingPainter({
    required this.strokes,
    required this.currentStroke,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    for (final stroke in strokes) {
      _drawStroke(canvas, paint, stroke);
    }

    _drawStroke(canvas, paint, currentStroke);
  }

  void _drawStroke(Canvas canvas, Paint paint, List<Offset> stroke) {
    for (int i = 0; i < stroke.length - 1; i++) {
      canvas.drawLine(stroke[i], stroke[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
