import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Theme/colors.dart';

class BoxCharaterComboWidget extends StatelessWidget{
  final String word;
  final String romaji;
  final bool isFull;
  final int level;

  const BoxCharaterComboWidget({super.key, required this.word, required this.romaji, required this.isFull, required this.level});

  @override
  Widget build(BuildContext context) {
    return word.isNotEmpty
        ? SizedBox(
      child: Container(
        decoration: BoxDecoration(
          color: isFull ? Color.fromRGBO(255, 255, 224, 1.0) : Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border.all(
            color: isFull ? Color.fromRGBO(238, 230, 0, 1.0) : Colors.grey,
          ),
          boxShadow: [
            BoxShadow(
              color: isFull ? Color.fromRGBO(238, 230, 0, 1.0) : Colors.grey.shade400,
              offset: Offset(4, 4),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AutoSizeText(
              word,
              style: TextStyle(
                fontSize: MediaQuery.sizeOf(context).height * 0.015,
                fontFamily: "Itim",
                color: isFull ? const Color.fromRGBO(255, 196, 0, 1.0) : Colors.black,
              ),
              minFontSize: 10,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
            AutoSizeText(
              romaji,
              style: TextStyle(
                fontSize: MediaQuery.sizeOf(context).height * 0.015,
                fontFamily: "Itim",
                color: isFull ? const Color.fromRGBO(255, 196, 0, 1.0) : Colors.black,
              ),
              minFontSize: 5,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.2,
              height: MediaQuery.sizeOf(context).width * 0.015,
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey.shade300,
                color: isFull ? const Color.fromRGBO(255, 216, 0, 1.0) : Colors.green,
                value: level / 27,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                minHeight: 8,
              ),
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
          ],
        ),
      ),
    )
        : SizedBox(
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * 0.15,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }
}