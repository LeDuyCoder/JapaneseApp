import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/features/topicdetail/data/models/word_model.dart';


class CardWordWidget extends StatefulWidget{
  final WordModel wordModel;
  final bool chosen;
  final Function() onChange;

  const CardWordWidget({super.key, this.chosen = false, required this.wordModel, required this.onChange});

  @override
  State<StatefulWidget> createState() => _CardWordWidget();
}

class _CardWordWidget extends State<CardWordWidget>{
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onChange,
      child: Container(
          width: MediaQuery.sizeOf(context).width * 0.95,
          height: 80,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 15,
                spreadRadius: 2,
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(widget.wordModel.word, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                            const Text(" - "),
                            Text(widget.wordModel.wayread, style: const TextStyle(fontSize: 15)),
                          ],
                        ),
                        Text(widget.wordModel.mean, style: const TextStyle(fontSize: 15),),
                      ],
                    ),
                    widget.chosen ? const Icon(Icons.expand_circle_down, color: Colors.green, size: 30,) : const Icon(CupertinoIcons.circle, size: 25,)
                  ],
                ),
              )
            ],
          )
      ),
    );
  }

}