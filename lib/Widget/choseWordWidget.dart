import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/Theme/colors.dart';

class choseWordWidget extends StatefulWidget {
  final String textShow;
  final bool isChose;
  final void Function() choseItem;

  const choseWordWidget({
    super.key,
    required this.textShow,
    required this.isChose,
    required this.choseItem,
  });

  @override
  State<StatefulWidget> createState() => _choseWordWidgetState();
}

class _choseWordWidgetState extends State<choseWordWidget> {

  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          isPressed = false;
        });
        widget.choseItem();
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
        width: MediaQuery.sizeOf(context).width / 2 - 30,
        height: MediaQuery.sizeOf(context).width / 2 - 30,
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.isChose ? AppColors.primary : Colors.grey,
            width: 2,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: widget.isChose ? Color(0xFFFFD8D8).withOpacity(1) : Colors.white,
          boxShadow: isPressed
              ? [] // Khi nhấn, không có boxShadow
              :[
            BoxShadow(
              color: widget.isChose ? AppColors.primary.withOpacity(0.4) : Colors.grey,
              offset: Offset(3, 3)
            )
          ]
        ),
        child: Center(
          child: AutoSizeText(
            widget.textShow,
            style: TextStyle(
              fontSize: MediaQuery.sizeOf(context).height*0.03,
              color: widget.isChose ? AppColors.primaryDark : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
