import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class boxText{
  final String text;

  boxText(this.text);

  Widget buildWidget() {
    double textWidth = _calculateTextWidth(text);

    return Container(
      width: textWidth + 20, // Cộng thêm padding ngang (10 bên trái + 10 bên phải)
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: Colors.grey
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }

// Hàm tính chiều dài chữ
  double _calculateTextWidth(String text) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(fontSize: 20), // Phải khớp với style trong Text
      ),
      textDirection: TextDirection.ltr,
    )..layout(); // Bắt buộc phải gọi layout() để lấy kích thước
    return textPainter.size.width;
  }
}