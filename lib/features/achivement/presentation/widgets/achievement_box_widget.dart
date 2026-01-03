import 'package:flutter/material.dart';
import 'package:japaneseapp/features/achivement/presentation/pages/achievement_unlock_page.dart';
import 'package:japaneseapp/features/achivement/presentation/widgets/achievement_detail_bottom_sheet.dart';

class AchievementBoxWidget extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final bool isUnlocked;

  const AchievementBoxWidget({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.isUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = isUnlocked
        ? const Color(0xFF4CAF50)
        : Colors.grey.shade400;

    return GestureDetector(
      onTap: (){
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => AchievementDetailBottomSheet(
            title: title,
            imagePath: imagePath,
            isUnlocked: isUnlocked,
            unlockCondition: description,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUnlocked ? Colors.white : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnlocked ? primaryColor : Colors.grey.shade300,
            width: 1,
          ),
          boxShadow: isUnlocked
              ? [
            BoxShadow(
              color: primaryColor.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ]
              : [],
        ),
        child: Row(
          children: [
            // 🔹 IMAGE
            Opacity(
              opacity: isUnlocked ? 1 : 0.4,
              child: Image.asset(
                imagePath,
                width: 48,
                height: 48,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(width: 12),

            // 🔹 TITLE + DESCRIPTION
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isUnlocked ? Colors.black87 : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: isUnlocked
                          ? Colors.black54
                          : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // 🔹 STATUS
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isUnlocked ? Icons.lock_open : Icons.lock,
                  color: primaryColor,
                  size: 22,
                ),
                const SizedBox(height: 4),
                Text(
                  isUnlocked ? "Đã mở" : "Chưa mở",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
