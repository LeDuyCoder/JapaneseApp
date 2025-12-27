import 'package:flutter/material.dart';
import 'package:japaneseapp/features/community_topic/presentation/widgets/floating_image.dart';

/// `DowloadSucessWidget` là widget dùng để hiển thị
/// **trạng thái download topic thành công**.
///
/// Widget này thường được sử dụng sau khi
/// [DowloadTopicBloc] emit state [DowloadTopicSucces].
///
/// UI bao gồm:
/// - Hình ảnh minh họa thành công
/// - Thông báo tải xuống thành công
/// - Nút hành động để quay lại và xem topic
class DowloadSucessWidget extends StatelessWidget{
  const DowloadSucessWidget({super.key});

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
              pathImage: "assets/character/hinh4.png",
              width: 250,
              height: 250
          ),

          const SizedBox(height: 24),
          const Text(
            "Tải xuống thành công!",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 8),
          Text(
            "Topic đã được lưu vào thiết bị",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 32),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
              decoration: BoxDecoration(
                color: const Color(0xFFE53935), // đỏ đồng bộ
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Text(
                "Xem topic",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}