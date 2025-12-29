import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/features/manager_topic/domain/entities/topic_entity.dart';

class TopicWidget extends StatelessWidget{
  final TopicEntity topicEntity;
  final void Function()? onTap;

  const TopicWidget({super.key, required this.topicEntity, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.sizeOf(context).width / 2.2,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC), // nền trắng xanh nhẹ
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFE2E8F0), // viền xám rất nhạt
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2), // xanh nhạt
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.sticky_note_2_outlined,
                    size: 22,
                    color: Colors.grey.withOpacity(0.7), // xanh đậm
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    topicEntity.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                      color: Color(0xFF0F172A), // chữ đậm
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Meta
            Text(
              "Tác giả: ${topicEntity.owner}",
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Số từ: ${topicEntity.count}",
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}