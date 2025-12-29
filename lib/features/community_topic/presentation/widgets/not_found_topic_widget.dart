import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Theme/colors.dart';

/// `NotFoundTopicWidget` là widget dùng để hiển thị
/// trạng thái **không tìm thấy topic**.
///
/// Widget này thường được sử dụng khi:
/// - Kết quả tìm kiếm rỗng
/// - Không có dữ liệu topic để hiển thị
///
/// UI có thể bao gồm icon, text thông báo
/// hoặc nút hành động (retry, quay lại, v.v.).
class NotFoundTopicWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: AppColors.primary.withOpacity(0.6),
          ),
          const SizedBox(height: 16),
          const Text(
            "Không tìm thấy topic",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Hãy thử từ khóa khác nhé 👀",
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecond.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}