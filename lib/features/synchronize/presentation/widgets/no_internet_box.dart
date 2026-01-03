import 'package:flutter/material.dart';
import 'package:japaneseapp/features/synchronize/presentation/widgets/floating_image.dart';

class NoInternetBox extends StatelessWidget {
  final VoidCallback? onRetry;

  const NoInternetBox({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// 🌐 Character / Illustration
          const FloatingImage(
            pathImage: "assets/character/hinh17.png",
            width: 220,
            height: 220,
          ),

          const SizedBox(height: 24),

          /// ❌ Title
          const Text(
            "Không có kết nối Internet",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 12),

          /// 📝 Description
          Text(
            "Vui lòng kiểm tra lại kết nối mạng\nvà thử lại sau.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 32),

          /// 🔁 Retry button
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
              ),
              onPressed: onRetry,
              child: const Text(
                "Thử lại",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
