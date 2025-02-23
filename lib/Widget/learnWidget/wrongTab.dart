import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class wrongTab extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _wrongTab();

  final void Function() nextQuestion;
  final String rightAwnser;

  const wrongTab({super.key, required this.nextQuestion, required this.rightAwnser});
}

class _wrongTab extends State<wrongTab>{

  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.sizeOf(context).height * 0.25, // Độ cao tối thiểu
      ),
      height: MediaQuery.sizeOf(context).height * 0.3,
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: Colors.red[100],
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Đảm bảo không chiếm hết không gian
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.cancel, color: Colors.red, size: 40),
                const SizedBox(width: 10),
                Expanded(
                  child: AutoSizeText(
                    "Không Chính Xác",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: MediaQuery.sizeOf(context).width * 0.07,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10), // Khoảng cách nhỏ
            Row(
              children: [
                Text(
                  "Câu trả lời đúng là: ",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: MediaQuery.sizeOf(context).width * 0.045,
                  ),
                ),
                Text(
                  widget.rightAwnser,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(), // Đẩy nút xuống dưới
            GestureDetector(
              onTapDown: (_) {
                setState(() {
                  isPressed = true;
                });
              },
              onTapUp: (_) {
                setState(() {
                  isPressed = false;
                });
                widget.nextQuestion();
                Navigator.pop(context);
              },
              onTapCancel: () {
                setState(() {
                  isPressed = false;
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 100),
                curve: Curves.easeInOut,
                transform: Matrix4.translationValues(0, isPressed ? 4 : 0, 0),
                width: MediaQuery.sizeOf(context).width - 40,
                height: MediaQuery.sizeOf(context).width * 0.15,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 103, 103, 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: isPressed
                      ? []
                      : [
                        BoxShadow(
                          color: Colors.red,
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
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }


}