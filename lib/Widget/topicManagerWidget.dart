import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/Screen/listWordScreen.dart';

import '../Module/topic.dart';

class topicManagerWidget extends StatelessWidget{
  final topic dataTopic;
  final void Function() removeTopic;
  final void Function() reloadDashboard;

  const topicManagerWidget({super.key, required this.dataTopic, required this.removeTopic, required this.reloadDashboard});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (ctx) => listWordScreen(id: dataTopic.id, topicName: dataTopic.name, reloadDashboard: () {
          reloadDashboard();
        },)));
      },
      child: Container(
          width: MediaQuery.of(context).size.width-20,
          height: 100,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey,
              ),
              borderRadius: const BorderRadius.all(
                  Radius.circular(15)
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade500,
                  offset: Offset(4, 4)
                )
              ]
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
                    Container(
                      width: MediaQuery.sizeOf(context).width*0.65,
                      child: AutoSizeText(dataTopic.name, style: TextStyle(fontSize: 20, fontFamily: "indieflower"),),
                    )
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