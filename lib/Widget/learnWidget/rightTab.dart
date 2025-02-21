import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class rightTab extends StatelessWidget{
  final void Function() nextQuestion;

  List<String> motivationalPhrasesVN = [
    "Tiếp tục cố gắng, bạn đang làm rất tốt!",
    "Lần này bạn đã hoàn hảo, hãy tiếp tục cố gắng!",
    "Mỗi bước tiến lên đều là một sự tiến bộ!",
    "Hãy tin vào bản thân và tiếp tục nỗ lực!",
    "Bạn có thể làm được, đừng bao giờ bỏ cuộc!",
    "Thành công đến với những ai không ngừng cố gắng!",
    "Tiếp tục cải thiện, từng bước một!",
    "Hãy mạnh mẽ, tập trung và tiếp tục tiến lên!",
    "Nỗ lực tuyệt vời! Hãy tiếp tục đặt mục tiêu cao hơn!",
    "Sự chăm chỉ của bạn sẽ sớm được đền đáp!"
  ];


  rightTab({super.key, required this.nextQuestion});


  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.sizeOf(context).height * 0.2, // Độ cao tối thiểu
      ),
      height: MediaQuery.sizeOf(context).height*0.25,
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Giúp cột không chiếm toàn bộ không gian
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 40),
                const SizedBox(width: 10),
                Expanded( // Đảm bảo văn bản không tràn
                  child: AutoSizeText(
                    "Trả Lời Chính Xác",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: MediaQuery.sizeOf(context).width * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10), // Khoảng cách nhỏ để tránh dính
            Text(
              motivationalPhrasesVN[Random().nextInt(motivationalPhrasesVN.length)],
              style: TextStyle(
                color: Colors.green,
                fontSize: MediaQuery.sizeOf(context).width * 0.045,
              ),
            ),
            const Spacer(), // Đẩy nút xuống dưới
            GestureDetector(
              onTap: () {
                nextQuestion();
                Navigator.pop(context);
              },
              child: Container(
                width: MediaQuery.sizeOf(context).width - 40,
                height: MediaQuery.sizeOf(context).width * 0.15,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(97, 213, 88, 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green,
                      offset: Offset(6, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "CONTINUE",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.sizeOf(context).width * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}