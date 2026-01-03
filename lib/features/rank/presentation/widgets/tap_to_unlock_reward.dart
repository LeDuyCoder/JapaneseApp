import 'dart:math';
import 'package:flutter/material.dart';

class TapToUnlockReward extends StatefulWidget {
  final ImageProvider image;
  final Widget reward;
  final int requiredTaps;

  const TapToUnlockReward({
    super.key,
    required this.image,
    required this.reward,
    this.requiredTaps = 6,
  });

  @override
  State<TapToUnlockReward> createState() => _TapToUnlockRewardState();
}

class _TapToUnlockRewardState extends State<TapToUnlockReward>
    with TickerProviderStateMixin {

  late AnimationController _shakeController;
  late AnimationController _explodeController;
  late AnimationController _rewardController;

  late Animation<double> _rewardScale;

  int _tapCount = 0;
  bool _showReward = false;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _explodeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _rewardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _rewardScale = CurvedAnimation(
      parent: _rewardController,
      curve: Curves.elasticOut,
    );
  }

  void _onTap() {
    if (_showReward) return;

    _tapCount++;

    _shakeController.forward(from: 0);

    if (_tapCount >= widget.requiredTaps) {
      _explodeController.forward(from: 0).then((_) {
        if (!mounted) return;
        setState(() {
          _showReward = true;
        });
        _rewardController.forward(from: 0);
      });
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _explodeController.dispose();
    _rewardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [

          /// ====== GIFT BOX / IMAGE ======
          if (!_showReward)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: _onTap,
                  child: AnimatedBuilder(
                    animation: Listenable.merge([
                      _shakeController,
                      _explodeController,
                    ]),
                    builder: (context, child) {

                      /// Shake ±8°
                      final rotation =
                          sin(_shakeController.value * pi * 8) * 0.14;

                      /// Explode scale
                      final scale =
                          1 - (_explodeController.value * 0.35);

                      /// Fade out on explode
                      final opacity =
                          1 - _explodeController.value;

                      return Opacity(
                        opacity: opacity,
                        child: Transform.rotate(
                          angle: rotation,
                          child: Transform.scale(
                            scale: scale,
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: 220,
                      height: 220,
                      child: Image(image: widget.image),
                    ),
                  ),
                ),
                Text(
                  "Nhấn để mở quà",
                  style: TextStyle(
                    color: Colors.grey.withOpacity(0.8),
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ],
            ),

          /// ====== REWARD ======
          if (_showReward)
            ScaleTransition(
              scale: _rewardScale,
              child: widget.reward,
            ),
        ],
      ),
    );
  }
}
