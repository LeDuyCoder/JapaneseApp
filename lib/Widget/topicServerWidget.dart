import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class topicServerWidget extends StatefulWidget{

  final bool isDowloaded;
  final String name;
  final String owner;
  final int amount;

  const topicServerWidget({super.key, required this.name, required this.owner, required this.amount, required this.isDowloaded});

  @override
  State<StatefulWidget> createState() => _topicServerWidget();
}

class _topicServerWidget extends State<topicServerWidget>{
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      width: 300,
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        border: Border.all(
          color: Colors.black
        )
      ),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(right: 10, top: 10),
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  widget.isDowloaded ? 
                    Icon(Icons.download_done, color: Colors.green,) :
                      Icon(Icons.public, color: Colors.grey,)
                ],
              )
          ),
          Container(
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 0),
                  child: AutoSizeText(widget.name, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 0),
                  child: AutoSizeText("Người Tạo: ${widget.owner}", style: TextStyle(fontSize: 18, color: Colors.blue),),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 0),
                  child: AutoSizeText("Số Lượng: ${widget.amount} Từ", style: TextStyle(fontSize: 18, color: Colors.red),),
                ),
              ],
            ),
          )
        ],
      )
    );
  }

}