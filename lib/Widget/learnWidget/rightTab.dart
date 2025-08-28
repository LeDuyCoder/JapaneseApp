import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../../generated/app_localizations.dart';

class rightTab extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _rightTab();
  final void Function() nextQuestion;
  final bool isMean;
  final String? mean;
  final BuildContext context;
  late List<String> motivationalPhrasesVN;
  String? PhrasesVN;
  rightTab({super.key, required this.nextQuestion, required this.isMean, this.mean, required this.context});
}

class _rightTab extends State<rightTab>{
  bool isPressed = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.motivationalPhrasesVN = [
      AppLocalizations.of(widget.context)!.motivationalPhrases_1,
      AppLocalizations.of(widget.context)!.motivationalPhrases_2,
      AppLocalizations.of(widget.context)!.motivationalPhrases_3,
      AppLocalizations.of(widget.context)!.motivationalPhrases_4,
      AppLocalizations.of(widget.context)!.motivationalPhrases_5,
      AppLocalizations.of(widget.context)!.motivationalPhrases_6,
      AppLocalizations.of(widget.context)!.motivationalPhrases_7,
      AppLocalizations.of(widget.context)!.motivationalPhrases_8,
      AppLocalizations.of(widget.context)!.motivationalPhrases_9,
      AppLocalizations.of(widget.context)!.motivationalPhrases_10
    ];
  }

  @override
  Widget build(BuildContext context) {
    widget.PhrasesVN ??= widget.motivationalPhrasesVN[Random().nextInt(widget.motivationalPhrasesVN.length)];
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.sizeOf(context).height * 0.25, // Độ cao tối thiểu
      ),
      height: MediaQuery.sizeOf(context).height*0.3,
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
                    AppLocalizations.of(context)!.learn_bottomsheet_right_title,
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
              widget.isMean ? "Nghĩa của từ là: ${widget.mean}" : widget.PhrasesVN!,
              style: TextStyle(
                color: Colors.green,
                fontSize: MediaQuery.sizeOf(context).width * 0.045,
              ),
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
                  color: Color.fromRGBO(97, 213, 88, 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: isPressed
                      ? [] // Khi nhấn, không có boxShadow
                      :[
                    const BoxShadow(
                      color: Colors.green,
                      offset: Offset(6, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.learn_bottomsheet_right_btn,
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