import 'package:flutter/material.dart';

class TiltedRankRing extends StatelessWidget {
  final Widget child;

  const TiltedRankRing({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.0030) // perspective
        ..rotateX(-1.32)          // ⭐ độ nghiêng xuống
        ..rotateY(0)
        ..rotateZ(0),        // xoay nhẹ cho giống game
      child: child,
    );
  }
}
