import 'dart:async';
import 'package:flutter/material.dart';
import 'package:japaneseapp/features/synchronize/presentation/widgets/floating_image.dart';

class LoadingCharacterWidget extends StatefulWidget {
  final String imagePath;

  const LoadingCharacterWidget({super.key, required this.imagePath});

  @override
  State<LoadingCharacterWidget> createState() => _LoadingCharacterWidgetState();
}

class _LoadingCharacterWidgetState extends State<LoadingCharacterWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progress;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _progress = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final barWidth = constraints.maxWidth;

          return AnimatedBuilder(
            animation: _progress,
            builder: (context, _) {
              final progress = _progress.value.clamp(0.0, 1.0);
              final indicatorX = (barWidth - 40) * progress;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingImage(
                      pathImage: widget.imagePath,
                      width: 280,
                      height: 280
                  ),

                  const SizedBox(height: 50,),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      /// Progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 16,
                          backgroundColor: Colors.grey.shade200,
                          valueColor:
                          const AlwaysStoppedAnimation(Colors.red),
                        ),
                      ),

                      /// 🚀 Floating image indicator
                      Positioned(
                        left: indicatorX,
                        child: Column(
                          children: [
                            Text(
                              "${(progress * 100).toInt()}%",
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  /// Text status
                  Text(
                    "Đang đồng bộ dữ liệu...",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
