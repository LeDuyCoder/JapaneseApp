import 'package:flutter/material.dart';
import 'package:japaneseapp/features/achivement/presentation/widgets/floating_image.dart';

class SyncSuccessWidget extends StatefulWidget {
  final VoidCallback? onContinue;
  final String message;

  const SyncSuccessWidget({super.key, this.onContinue, required this.message});

  @override
  State<SyncSuccessWidget> createState() => _SyncSuccessScreenState();
}

class _SyncSuccessScreenState extends State<SyncSuccessWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scale = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _opacity,
        child: ScaleTransition(
          scale: _scale,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// 🎉 Success icon / image
                  const FloatingImage(
                      pathImage: "assets/character/hinh4.png",
                      width: 250,
                      height: 250
                  ),

                  const SizedBox(height: 32),

                  /// ✅ Title
                  const Text(
                    "Đồng bộ dữ liệu thành công",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// 📝 Description
                  Text(
                    widget.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// 🚀 Continue button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                      ),
                      onPressed: widget.onContinue ??
                              () {
                            Navigator.pop(context);
                          },
                      child: const Text(
                        "Tiếp tục",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
