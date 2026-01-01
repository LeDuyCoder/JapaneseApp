import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Theme/colors.dart';

class ErrorBottomSheetWidget extends StatelessWidget {
  const ErrorBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Icon
          Container(
            width: 150,
            height: 150,
            child: Image.asset("assets/character/hinh6.png"),
          ),
          const SizedBox(height: 16),

          // Title
          const Text(
            'Có lỗi xảy ra',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Content
          const Text(
            'Tạm thời không để đăng xuất, báo cáo cho admin',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          // Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('OK', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),
            ),
          ),
        ],
      ),
    );
  }
}
