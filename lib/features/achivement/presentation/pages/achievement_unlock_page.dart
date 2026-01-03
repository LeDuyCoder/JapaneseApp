import 'dart:ui';
import 'package:flutter/material.dart';

class AchievementUnlockPage extends StatefulWidget {
  final String imagePath;
  final String title;
  final String description;

  const AchievementUnlockPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  State<AchievementUnlockPage> createState() =>
      _AchievementUnlockPageState();
}

class _AchievementUnlockPageState extends State<AchievementUnlockPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _scale;
  late Animation<double> _flash;
  late Animation<double> _color;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textOffset;

  late AnimationController _hintController;
  late Animation<double> _hintOpacity;
  late Animation<Offset> _hintOffset;

  bool _canTap = false;

  @override
  void initState() {
    super.initState();

    _hintController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _hintOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _hintController, curve: Curves.easeOut),
    );

    _hintOffset = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _hintController, curve: Curves.easeOut),
    );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _canTap = true);
        _hintController.forward();
      }
    });

    _scale = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: 0.8, end: 1.25)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.25, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 60,
      ),
    ]).animate(_controller);

    _flash = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.45),
      ),
    );

    _color = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 1.0),
      ),
    );

    _textOpacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.55, 1.0, curve: Curves.easeOut),
      ),
    );

    _textOffset = Tween(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.55, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  ColorFilter _grayscale(double value) {
    return ColorFilter.matrix(<double>[
      0.2126 + 0.7874 * value,
      0.7152 - 0.7152 * value,
      0.0722 - 0.0722 * value,
      0, 0,
      0.2126 - 0.2126 * value,
      0.7152 + 0.2848 * value,
      0.0722 - 0.0722 * value,
      0, 0,
      0.2126 - 0.2126 * value,
      0.7152 - 0.7152 * value,
      0.0722 + 0.9278 * value,
      0, 0,
      0, 0, 0, 1, 0,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: (){
            if(_canTap){
              Navigator.pop(context);
            }
          },
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, __) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// ICON + FLASH
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Opacity(
                          opacity: _flash.value,
                          child: Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.amber.withOpacity(0.6),
                            ),
                          ),
                        ),
                        Transform.scale(
                          scale: _scale.value,
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                if (_color.value > 0.6)
                                  BoxShadow(
                                    color: Colors.amber.withOpacity(0.7),
                                    blurRadius: 32,
                                  ),
                              ],
                            ),
                            child: ColorFiltered(
                              colorFilter: _grayscale(_color.value),
                              child: Image.asset(
                                widget.imagePath,
                                width: 196,
                                height: 196,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    /// TEXT INFO
                    FadeTransition(
                      opacity: _textOpacity,
                      child: SlideTransition(
                        position: _textOffset,
                        child: Column(
                          children: [
                            Text(
                              widget.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),

                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.greenAccent,
                                  size: 22,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  "Đã mở khóa thành tựu",
                                  style: TextStyle(
                                    color: Colors.greenAccent,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            Text(
                              widget.description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 100,),

                    if (_canTap)
                      FadeTransition(
                        opacity: _hintOpacity,
                        child: SlideTransition(
                          position: _hintOffset,
                          child: Text(
                            "Nhấn để tiếp tục",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        )
      )
    );
  }
}