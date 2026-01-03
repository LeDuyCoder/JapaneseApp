import 'package:flutter/material.dart';

class RankUpScreen extends StatefulWidget {
  final String oldRankImage;
  final String newRankImage;
  final String newRankName;
  final Color glowColor;

  const RankUpScreen({
    super.key,
    required this.oldRankImage,
    required this.newRankImage,
    required this.newRankName,
    required this.glowColor,
  });

  @override
  State<RankUpScreen> createState() => _RankUpScreenState();
}

class _RankUpScreenState extends State<RankUpScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _hintController;

  late Animation<double> oldScale;
  late Animation<double> oldOpacity;

  late Animation<double> newScale;
  late Animation<double> newOpacity;

  late Animation<double> hintOpacity;

  @override
  void initState() {
    super.initState();

    /// Animation chính
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    /// Animation hint "Nhấn để tiếp tục"
    _hintController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    hintOpacity = Tween(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _hintController, curve: Curves.easeInOut),
    );

    /// Rank cũ – zoom + nổ
    oldScale = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: 0.6, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.6)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 25,
      ),
    ]).animate(_controller);

    oldOpacity = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 15),
    ]).animate(_controller);

    /// Rank mới – bật ra
    newScale = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: 0.7, end: 1.15)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.15, end: 1.0),
        weight: 10,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.65, 1),
      ),
    );

    newOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.65, 1),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _hintController.dispose();
    super.dispose();
  }

  Widget _rankImage({
    required String path,
    required double scale,
    required double opacity,
    bool glow = false,
  }) {
    return Opacity(
      opacity: opacity,
      child: Transform.scale(
        scale: scale,
        child: Container(
          decoration: glow
              ? BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: widget.glowColor.withOpacity(0.7),
                blurRadius: 40,
                spreadRadius: 10,
              ),
            ],
          )
              : null,
          child: Image.asset(
            path,
            width: 160,
            height: 160,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.85),
        body: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (_, __) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// 🎉 Text chúc mừng
                  Opacity(
                    opacity: newOpacity.value,
                    child: const Text(
                      "🎉 Chúc mừng bạn!",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Opacity(
                    opacity: newOpacity.value,
                    child: const Text(
                      "Bạn đã lên rank mới",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  /// Stack rank
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      _rankImage(
                        path: widget.oldRankImage,
                        scale: oldScale.value,
                        opacity: oldOpacity.value,
                      ),
                      _rankImage(
                        path: widget.newRankImage,
                        scale: newScale.value,
                        opacity: newOpacity.value,
                        glow: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Tên rank
                  Opacity(
                    opacity: newOpacity.value,
                    child: Text(
                      widget.newRankName,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: widget.glowColor,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// 👆 Nhấn để tiếp tục
                  AnimatedBuilder(
                    animation: hintOpacity,
                    builder: (_, __) => Opacity(
                      opacity: hintOpacity.value,
                      child: const Text(
                        "Nhấn để tiếp tục",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
