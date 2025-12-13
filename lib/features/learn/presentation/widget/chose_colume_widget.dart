import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Theme/colors.dart';

class ChoseColumeWidget extends StatelessWidget{

  final String text;
  final bool isChoose;
  final bool isCancle;
  final bool isWrong;
  final void Function() functionButton;

  const ChoseColumeWidget({super.key, required this.text, required this.isChoose, required this.isCancle, required this.functionButton, required this.isWrong});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(!isCancle)
          functionButton();
      },
      child: Container(
        height: MediaQuery.sizeOf(context).height*0.2-(MediaQuery.sizeOf(context).width/2 - 20)*0.4,
        width: MediaQuery.sizeOf(context).width/2 - 20,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                color: isCancle ? const Color.fromRGBO(213, 213, 213, 1.0) : isWrong ? const Color.fromRGBO(
                    80, 3, 3, 1.0) : isChoose ? AppColors.primary : Colors.grey,
                width: 2
            ),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: isCancle ? const Color.fromRGBO(197, 197, 197, 1.0) : Colors.grey,
                offset: Offset(2, 2),
              )
            ]
        ),
        child: Center(
          child: AutoSizeText(text, textAlign: TextAlign.center, style: TextStyle(fontSize: MediaQuery.sizeOf(context).width*0.045, color: isCancle ? const Color.fromRGBO(213, 213, 213, 1.0) : isWrong ? const Color.fromRGBO(
              80, 3, 3, 1.0) : isChoose ? AppColors.primary : Colors.grey,),),
        ),
      ),
    );
  }

}
