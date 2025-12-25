import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/features/manager_topic/domain/entities/topic_entity.dart';



class TopicManagerWidget extends StatelessWidget{
  final TopicEntity dataTopic;
  final void Function()? removeTopic;

  const TopicManagerWidget({super.key, required this.dataTopic, this.removeTopic});

  void _showBottomMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // để bo góc đẹp
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white, // màu nền dark
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Thanh kéo ở giữa
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Nút chọn: Học phần
              ListTile(
                leading: const Icon(Icons.remove, color: Colors.red),
                title: const Text("Xóa khỏi thư mục",
                    style: TextStyle(color: Colors.red, fontSize: 18)),
                onTap: () {
                  if(removeTopic != null){
                    removeTopic!();
                  }
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 10,),

              // Nút chọn: Thư mục
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => Container()),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.sticky_note_2_outlined,
                size: 26,
                color: AppColors.primary
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dataTopic.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tác Giả: ${dataTopic.owner} - ${dataTopic.count} từ vựng',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(width: 6),
            IconButton(
              onPressed: () => _showBottomMenu(context),
              icon: const Icon(
                Icons.more_horiz,
                size: 22,
                color: Color(0xFF475569),
              ),
              splashRadius: 20,
            ),
          ],
        ),
      ),
    );
  }
}