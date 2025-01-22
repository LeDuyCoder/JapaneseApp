import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.choseItem();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300), // Thời gian chuyển đổi
        curve: Curves.easeInOutSine, // Hiệu ứng mượt mà
        width: MediaQuery.sizeOf(context).width / 2 - 30,
        height: MediaQuery.sizeOf(context).width / 2 - 30,
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.isChose ? Colors.blue : Colors.grey,
            width: 2,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: widget.isChose ? Colors.blue[100] : Colors.white,
        ),
        child: Center(
          child: AutoSizeText(
            widget.textShow,
            style: TextStyle(
              fontFamily: "indieflower",
              fontSize: 40,
              color: widget.isChose ? Colors.blue : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
