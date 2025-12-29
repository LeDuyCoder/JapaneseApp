import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/features/manager_topic/domain/entities/topic_entity.dart';

class TopicInfolderWidget extends StatelessWidget{
  final TopicEntity topic;
  final void Function()? onTap;

  const TopicInfolderWidget({super.key, required this.topic, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.sizeOf(context).width / 2.2,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FDF4), // xanh lá rất nhạt
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFF86EFAC), // viền xanh
          ),
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
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.check_circle_outline,
                    size: 22,
                    color: Color(0xFF16A34A), // xanh đậm
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    topic.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                      color: Color(0xFF065F46),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Text(
              "Tác giả: ${topic.owner}",
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF047857),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Số từ: ${topic.count}",
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF047857),
              ),
            ),
          ],
        ),
      ),
    );
  }

}