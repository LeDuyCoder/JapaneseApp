import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Theme/colors.dart';

class NoInternetBottomSheetWidget extends StatelessWidget {
  const NoInternetBottomSheetWidget({super.key});

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
          const Icon(
            Icons.wifi_off_rounded,
            size: 64,
            color: Colors.redAccent,
          ),

          const SizedBox(height: 16),

          // Title
          const Text(
            'Không có kết nói internet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Content
          const Text(
            'Hãy kiểm tra lại kết nối mạng và thử lại.',
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
