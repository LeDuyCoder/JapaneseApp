import 'package:flutter/cupertino.dart';
import 'package:japaneseapp/core/Theme/colors.dart';

class WordSameWidget extends StatelessWidget{
  final String word;
  final VoidCallback onTap;

  const WordSameWidget({super.key, required this.word, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Giữ padding nhưng điều chỉnh cho phù hợp
        decoration: BoxDecoration(
            color: AppColors.grey.withOpacity(0.4),
            borderRadius: BorderRadius.circular(10)
        ),
        child: Text(
          word,
        ),
      ),
    );
  }

}