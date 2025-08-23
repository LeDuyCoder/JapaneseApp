import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class addWordWidget extends StatefulWidget{

  final BuildContext context;
  final String word, wayRead, mean;
  final void Function() removeVocabulary;

  const addWordWidget({super.key, required this.context, required this.word, required this.wayRead, required this.mean, required this.removeVocabulary});

  @override
  State<StatefulWidget> createState() => _addWordWidget();

}

class _addWordWidget extends State<addWordWidget>{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(widget.context).width - 20,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey
        ),
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: MediaQuery.sizeOf(context).width-80,
                      child: Row(
                        children: [
                          Text("${widget.word} : ", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                          Text(
                            widget.wayRead,
                            style: const TextStyle(fontSize: 15),
                            maxLines: 1, // Chỉ hiển thị 1 dòng
                            overflow: TextOverflow.ellipsis, // Hiển thị "..." nếu vượt quá
                          ),
                        ],
                      )
                    ),
                    SizedBox(width: MediaQuery.sizeOf(context).width-80,
                      child: Text(
                        softWrap: true,
                        widget.mean,
                        style: const TextStyle(fontFamily: "indieflower"),
                        maxLines: 2, // Chỉ hiển thị tối đa 2 dòng
                      ),
                    )
                  ],
                ),
              ),
              IconButton(onPressed: (){
                widget.removeVocabulary();
              }, icon: Icon(Icons.restore_from_trash, color: Colors.red, size: 30,),)
            ],
          ),
        ],
      )
    );
  }

}