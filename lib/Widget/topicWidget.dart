import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/Config/dataHelper.dart';
import 'package:japaneseapp/Screen/listWordScreen.dart';

class topicWidget extends StatefulWidget{
  final String nameTopic;
  final void Function() reloadDashBoard;

  const topicWidget({super.key, required this.nameTopic, required this.reloadDashBoard});

  @override
  State<StatefulWidget> createState() => _topicWidget();
}

class _topicWidget extends State<topicWidget>{

  Future<double> handledComplited () async {
    int sumComplitted = 0;

    DatabaseHelper db = DatabaseHelper.instance;
    List<Map<String, dynamic>> dataWords = await db.getAllWordbyTopic(widget.nameTopic);

    if(dataWords.isNotEmpty) {
      for (Map<String, dynamic> word in dataWords) {
        sumComplitted += word['level'] as int ?? 0;
      }
    }

    return dataWords.isNotEmpty ? sumComplitted / (28*dataWords.length) : 0;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: handledComplited(), builder: (context, snapshot){
      return Padding(
          padding: EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (ctx) => listWordScreen(topicName: widget.nameTopic, reloadDashboard: () {
                widget.reloadDashBoard();
              },)));
            },
            child: Container(
              child: Stack(
                children: [
                  Container(
                      width: 200,
                      height: 120,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey
                          ),
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                      ),
                      child: Center(
                        child: AutoSizeText(widget.nameTopic, style: TextStyle(fontFamily: "indieflower", fontSize: 20),),
                      )
                  ),
                  Container(
                    width: 200,
                    height: 125,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        width: 200,
                        height: 10,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            border: Border.all(
                                color: Colors.grey
                            )
                        ),
                        child: LinearProgressIndicator(
                          value: snapshot.data ?? 0, // 50% progress
                          backgroundColor: Colors.white,
                          color: snapshot.data != null && snapshot.data as double <= 0.95 ? Color.fromRGBO(0, 255, 171, 1.0) : Color.fromRGBO(
                              221, 113, 0, 1.0),
                          minHeight: 10.0,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
      );
    });
  }

}