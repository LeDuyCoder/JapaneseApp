import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Theme/colors.dart';

class AchievementDetailBottomSheet extends StatelessWidget {
  final String title;
  final String imagePath;
  final bool isUnlocked;
  final String? unlockCondition;

  const AchievementDetailBottomSheet({
    super.key,
    required this.title,
    required this.imagePath,
    required this.isUnlocked,
    this.unlockCondition,
  });

  @override
  Widget build(BuildContext context) {
    final Color statusColor =
    isUnlocked ? const Color(0xFF4CAF50) : Colors.grey;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ===== HANDLE =====
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          const SizedBox(height: 20),

          // ===== ICON =====
          Opacity(
            opacity: isUnlocked ? 1 : 0.4,
            child: Image.asset(
              imagePath,
              width: 150,
              height: 150,
            ),
          ),

          const SizedBox(height: 16),

          // ===== TITLE =====
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          // ===== STATUS =====
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isUnlocked ? Icons.lock_open : Icons.lock,
                color: statusColor,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                isUnlocked ? "Đã mở" : "Chưa mở",
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ===== CONDITION =====
          if (!isUnlocked && unlockCondition != null) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      unlockCondition!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),

          // ===== CLOSE BUTTON =====
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Đóng",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
