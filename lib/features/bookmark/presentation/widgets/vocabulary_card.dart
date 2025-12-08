import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/features/bookmark/domain/entities/word_entity.dart';

class VocabularyCard extends StatelessWidget{
  final WordEntity wordEntity;
  final VoidCallback onDelete;

  VocabularyCard({required this.wordEntity, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width / 1.1,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Từ vựng
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                wordEntity.word,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary
                ),
              ),
              IconButton(onPressed: onDelete, icon: Icon(Icons.delete_outline, color: AppColors.primary,))
            ],
          ),
          const SizedBox(height: 6),
          Text(
            wordEntity.reading,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            wordEntity.meaning,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          if(wordEntity.exampleJP.isNotEmpty)
            Container(
              width: MediaQuery.sizeOf(context).width/1.1,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                wordEntity.exampleJP,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
            ),
          if(wordEntity.exampleVI.isNotEmpty)
            ...[
              const SizedBox(height: 6),
              Text(
                wordEntity.exampleVI,
                style: const TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ]
        ],
      ),
    );
  }
}