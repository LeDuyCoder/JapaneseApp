import 'dart:math';

import 'package:flutter/material.dart';

class UpRankScreen extends StatefulWidget {

  final String imgRankOld;
  final String imgRankNow;
  final Color oldRankColor, newRankColor;
  final String nameRank;

  const UpRankScreen({super.key, required this.imgRankOld, required this.imgRankNow, required this.nameRank, required this.oldRankColor, required this.newRankColor});

  @override
  State<UpRankScreen> createState() => _UpRankScreenState();
}

class _UpRankScreenState extends State<UpRankScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _particleOpacityAnimation;
  late Animation<double> _rankSwitchAnimation;


  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );

    // Scale animation for the rank image
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.4, curve: Curves.elasticOut),
    ));

    // Animation for switching between rank A and rank B
    _rankSwitchAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.5, 0.8, curve: Curves.easeInOut),
    ));

    // Fade animation for text
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.6, 1.0, curve: Curves.easeIn),
    ));

    // Slide animation for text
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.6, 1.0, curve: Curves.easeOut),
    ));

    // Color animation for background glow
    _colorAnimation = ColorTween(
      begin: widget.oldRankColor.withOpacity(0.1),
      end: widget.newRankColor.withOpacity(0.3),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Particle opacity animation - fade out at the end
    _particleOpacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.7, 1.0, curve: Curves.easeOut),
    ));

    // Start animation once
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.white],
          ),
        ),
        child: Stack(
          children: [
            // Background glow effect
            AnimatedBuilder(
              animation: _colorAnimation,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.0,
                      colors: [
                        _colorAnimation.value!,
                        Colors.transparent,
                      ],
                    ),
                  ),
                );
              },
            ),

            // Confetti/particles effect with fade out
            AnimatedBuilder(
              animation: _particleOpacityAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _particleOpacityAnimation.value,
                  child: _buildParticles(),
                );
              },
            ),

            // Main content
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final screenSize = MediaQuery.sizeOf(context);

                final double horizontalOffset = _controller.value > 0.7
                    ? (screenSize.width / 2 - 120) * ((_controller.value - 0.7) / 0.3) // Move to horizontal center
                    : 0.0;

                final double verticalOffset = _controller.value > 0.7
                    ? -50.0 * (_controller.value - 0.7) / 0.3 // Move up 50px gradually
                    : 0.0;

                return Transform.translate(
                  offset: Offset(horizontalOffset, verticalOffset),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Rank image with switch animation
                      _buildRankSwitchAnimation(),

                      SizedBox(height: 30),

                      // Text with fade and slide animation
                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            children: [
                              Text(
                                widget.nameRank,
                                style: TextStyle(
                                  fontFamily: "Itim",
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: widget.newRankColor,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10,
                                      color: widget.newRankColor.withOpacity(0.7),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Chúc mừng bạn đã thăng hạng!",
                                style: TextStyle(
                                  fontFamily: "Itim",
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 40),

                      // Continue button with delay
                      _buildContinueButton(),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRankSwitchAnimation() {
    return AnimatedBuilder(
      animation: _rankSwitchAnimation,
      builder: (context, child) {
        // Show rank A (old rank) at the beginning
        if (_rankSwitchAnimation.value < 0.5) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _scaleAnimation.value * 0.1,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.oldRankColor.withOpacity(0.5),
                      blurRadius: 20 * _scaleAnimation.value,
                      spreadRadius: 5 * _scaleAnimation.value,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Image.asset(widget.imgRankOld), // Rank A image
                    if (_scaleAnimation.value > 0.8)
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              widget.oldRankColor.withOpacity(0.3),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }
        // Transition to rank B (new rank)
        else {
          final transitionValue = (_rankSwitchAnimation.value - 0.5) * 2;

          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _scaleAnimation.value * 0.1,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.newRankColor.withOpacity(0.5 * transitionValue),
                      blurRadius: 20 * _scaleAnimation.value,
                      spreadRadius: 5 * _scaleAnimation.value,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Fade out old rank and fade in new rank
                    Opacity(
                      opacity: 1 - transitionValue,
                      child: Image.asset(widget.imgRankOld),
                    ),
                    Opacity(
                      opacity: transitionValue,
                      child: Image.asset(widget.imgRankNow),
                    ),
                    if (_scaleAnimation.value > 0.8)
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              widget.oldRankColor.withOpacity(0.3 * transitionValue),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildParticles() {
    return IgnorePointer(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: CustomPaint(
          painter: _ParticlesPainter(_controller, widget.oldRankColor),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return DelayedAnimation(
      delay: Duration(milliseconds: 2000),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            elevation: 5,
          ),
          child: Text(
            "Tiếp tục",
            style: TextStyle(
              fontFamily: "Itim",
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _ParticlesPainter extends CustomPainter {
  final Color oldRankColor;
  final Animation<double> animation;

  _ParticlesPainter(this.animation, this.oldRankColor) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Blue particles for old rank (first half of animation)
    if (animation.value < 0.5) {
      final paint = Paint()
        ..color = oldRankColor.withOpacity(0.6)
        ..style = PaintingStyle.fill;

      for (int i = 0; i < 8; i++) {
        final angle = 2 * pi * i / 8 + animation.value * 2 * pi;
        final distance = 150.0 + sin(animation.value * pi * 2 + i) * 20;
        final x = center.dx + cos(angle) * distance;
        final y = center.dy + sin(angle) * distance;
        final particleSize = 3.0 + sin(animation.value * pi * 2 + i) * 2;

        canvas.drawCircle(Offset(x, y), particleSize, paint);
      }
    }
    // Red particles for new rank (second half of animation)
    else {
      final paint = Paint()
        ..color = Colors.red.withOpacity(0.6)
        ..style = PaintingStyle.fill;

      for (int i = 0; i < 8; i++) {
        final angle = 2 * pi * i / 8 + animation.value * 2 * pi;
        final distance = 150.0 + sin(animation.value * pi * 2 + i) * 20;
        final x = center.dx + cos(angle) * distance;
        final y = center.dy + sin(angle) * distance;
        final particleSize = 3.0 + sin(animation.value * pi * 2 + i) * 2;

        canvas.drawCircle(Offset(x, y), particleSize, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Helper widget for delayed animations
class DelayedAnimation extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const DelayedAnimation({
    Key? key,
    required this.child,
    required this.delay,
  }) : super(key: key);

  @override
  _DelayedAnimationState createState() => _DelayedAnimationState();
}

class _DelayedAnimationState extends State<DelayedAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}