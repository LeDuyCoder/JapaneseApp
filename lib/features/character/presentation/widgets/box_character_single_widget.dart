import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Theme/colors.dart';

class BoxCharaterSingleWidget extends StatelessWidget{
  final String word;
  final String romaji;
  final bool isFull;
  final int level;

  const BoxCharaterSingleWidget({super.key, required this.word, required this.romaji, required this.isFull, required this.level});

  @override
  Widget build(BuildContext context) {
    return word.isNotEmpty
        ? SizedBox(
      // Đặt chiều cao cố định
      child: Container(
        decoration: BoxDecoration(
          color: isFull ? const Color.fromRGBO(255, 224, 224, 1.0) : Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border.all(
              color: isFull ? Color.fromRGBO(238, 0, 0, 1.0) : Colors.grey),
          boxShadow: [
            BoxShadow(
                color: isFull
                    ? AppColors.primary.withOpacity(0.8)
                    : Colors.grey.shade400,
                offset: Offset(4, 4))
          ],
        ),
        // Thêm padding để căn chỉnh đẹp hơn
        child: Column(
          mainAxisSize: MainAxisSize.min, // Tránh chiếm toàn bộ không gian
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AutoSizeText(
              word,
              style: TextStyle(
                fontSize: MediaQuery.sizeOf(context).height * 0.02,
                fontFamily: "Itim",
                color: isFull
                    ? AppColors.primary
                    : Colors.black,
              ),
              minFontSize: 10, // Giảm để tránh mất chữ
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
            AutoSizeText(
              romaji,
              style: TextStyle(
                fontSize: MediaQuery.sizeOf(context).height * 0.015,
                fontFamily: "Itim",
                color: isFull
                    ? AppColors.primary
                    : Colors.black,
              ),
              minFontSize: 5,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
            Container(
              width: MediaQuery.sizeOf(context).width * 0.1, // Tăng kích thước thanh tiến trình
              height: MediaQuery.sizeOf(context).width * 0.015,
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey.shade300,
                color: isFull
                    ? AppColors.primary
                    : Colors.green,
                value: level / 27,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                minHeight: 10,
              ),
            ),
          ],
        ),
      ),
    )
        : SizedBox(
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * 0.15, // Đặt chiều cao cố định
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }
}