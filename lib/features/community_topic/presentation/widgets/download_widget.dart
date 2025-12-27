import 'package:flutter/material.dart';
import 'package:japaneseapp/features/community_topic/presentation/widgets/floating_image.dart';

/// `DownloadWidget` là widget dùng để hiển thị
/// **màn hình download topic**.
///
/// Widget này quản lý trạng thái thông qua
/// [_DownloadWidgetState], nơi xử lý animation
/// và tiến trình download.
class DownloadWidget extends StatefulWidget {
  const DownloadWidget({super.key});

  @override
  State<DownloadWidget> createState() => _DownloadWidgetState();
}

/// State của [DownloadWidget], chịu trách nhiệm
/// hiển thị **màn hình đang download topic**
/// với animation tiến trình (progress).
///
/// State này sử dụng [SingleTickerProviderStateMixin]
/// để cung cấp `vsync` cho [AnimationController].
class _DownloadWidgetState extends State<DownloadWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
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
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const FloatingImage(
            pathImage: "assets/character/hinh8.png",
            width: 350,
            height: 350,
          ),

          const SizedBox(height: 24),

          const Text(
            "Đang tải topic...",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "Vui lòng đợi trong giây lát",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 24),

          /// LOADING BAR + %
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AnimatedBuilder(
                    animation: _progressAnimation,
                    builder: (context, child) {
                      return LinearProgressIndicator(
                        value: _progressAnimation.value,
                        minHeight: 8,
                        backgroundColor: const Color(0xFFF0F0F0),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFFE53935),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 8),

                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return Text(
                      "${(_progressAnimation.value * 100).toInt()}%",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

