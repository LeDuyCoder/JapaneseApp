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

      margin: const EdgeInsets.only(bottom: 5, right: 5, left: 5),
      width: MediaQuery.sizeOf(widget.context).width,
      height: 100,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 2),
            blurRadius: 5
          )
        ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: MediaQuery.sizeOf(context).width/1.5,
                      child: Row(
                        children: [
                          Text("${widget.word} : ",
                              style: const TextStyle(fontFamily: "itim", fontSize: 20),),
                          Text(
                            widget.wayRead,
                            style: const TextStyle(fontFamily: "itim", fontSize: 20),
                            maxLines: 1, // Chỉ hiển thị 1 dòng
                            overflow: TextOverflow.ellipsis, // Hiển thị "..." nếu vượt quá
                          ),
                        ],
                      )
                    ),
                    SizedBox(width: MediaQuery.sizeOf(context).width/1.5,
                      child: Text(
                        softWrap: true,
                        widget.mean,
                        style: const TextStyle(fontFamily: "itim", fontSize: 15),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis
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