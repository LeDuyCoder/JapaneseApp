import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Theme/colors.dart';

class AnimatedLoadingAdsDialog extends StatefulWidget {
  const AnimatedLoadingAdsDialog({super.key});

  @override
  State<AnimatedLoadingAdsDialog> createState() => _AnimatedLoadingDialogState();
}

class _AnimatedLoadingDialogState extends State<AnimatedLoadingAdsDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Nhân vật floating
            AnimatedBuilder(
              animation: _controller,
              builder: (_, child) {
                return Transform.translate(
                  offset: Offset(0, -12 * _controller.value),
                  child: child,
                );
              },
              child: Image.asset(
                "assets/character/hinh12.png",
                width: 180,
                height: 180,
              ),
            ),

            const SizedBox(height: 12),

            const CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 3,
            ),

            const SizedBox(height: 16),

            Text(
              "Đang xử lý...",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
