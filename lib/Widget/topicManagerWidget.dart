import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/Screen/listWordScreen.dart';

import '../Module/topic.dart';

class topicManagerWidget extends StatelessWidget{
  final topic dataTopic;
  final void Function() removeTopic;

  const topicManagerWidget({super.key, required this.dataTopic, required this.removeTopic});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (ctx) => listWordScreen(topicName: dataTopic.name)));
      },
      child: Container(
          width: MediaQuery.of(context).size.width-20,
          height: 100,
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.all(
                  Radius.circular(15)
              )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Icon(Icons.topic_outlined, size: 30),
                    SizedBox(width: 20,),
                    Text(dataTopic.name, style: TextStyle(fontSize: 20, fontFamily: "indieflower"),)
                  ],
                ),
              ),
              IconButton(onPressed: (){
                removeTopic();
              }, icon: Icon(Icons.restore_from_trash, color: Colors.red, size: 30,))
            ],
          )
      ),
    );
  }
}