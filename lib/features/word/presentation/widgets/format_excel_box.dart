import 'package:flutter/material.dart';
import 'package:japaneseapp/features/word/presentation/widgets/bullet_text.dart';

class FormatExcelBox extends StatelessWidget{
  const FormatExcelBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: 220,
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: const Border(
          left: BorderSide(color: Colors.red, width: 5)
        )
      ),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TITLE
            Row(
              children: [
                Icon(
                  Icons.info,
                  color: Colors.red,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Yêu cầu định dạng',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),

            BulletText('File Excel .xlsx hoặc .xls'),
            BulletText('Cột A: Từ vựng (bắt buộc)'),
            BulletText('Cột B: Nghĩa tiếng Việt (bắt buộc)'),
            BulletText('Cột C: Phát âm (không bắt buộc)'),
            BulletText('Tối đa 500 từ vựng mỗi lần import'),
          ],
        ),
      ),
    );
  }

}