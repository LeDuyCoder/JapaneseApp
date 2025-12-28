import 'package:flutter/material.dart';
import 'package:japaneseapp/features/local_topic/domain/entities/topic_entity.dart';

class TopicInfoBoxWidget extends StatelessWidget{
  final TopicEntity topicEntity;
  final Function() onTap;

  const TopicInfoBoxWidget({super.key, required this.topicEntity, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// TOPIC NAME
            Row(
              children: [
                Expanded(
                  child: Text(
                    topicEntity.topicName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${topicEntity.percent}%',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Divider(color: Colors.grey.withOpacity(0.3)),
            const SizedBox(height: 8),
            /// OWNER + WORD COUNT
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                /// OWNER
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 18,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(width: 6),
                    SizedBox(
                      width: 140,
                      child: Text(
                        topicEntity.owner!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),

                /// WORD COUNT
                Row(
                  children: [
                    const Icon(
                      Icons.book_outlined,
                      size: 18,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${topicEntity.amoutWord}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}