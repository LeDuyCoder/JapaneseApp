import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:math';
import 'package:flutter/material.dart';

class BoxTextWidget {
  final int index;
  final String text;

  BoxTextWidget({
    required this.index,
    required this.text,
  });

  Widget buildWidget() {
    double textWidth = _calculateTextWidth(text);

    return Container(
      width: textWidth + 20,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  // ===== PRIVATE =====

  double _calculateTextWidth(String text) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(fontSize: 20),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.size.width;
  }
}
