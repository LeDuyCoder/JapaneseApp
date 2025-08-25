import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../generated/app_localizations.dart';

class topicServerWidget extends StatefulWidget{

  final bool isDowloaded;
  final String name;
  final String owner;
  final int amount;
  final double? width;

  const topicServerWidget({super.key, required this.name, required this.owner, required this.amount, required this.isDowloaded, this.width});

  @override
  State<StatefulWidget> createState() => _topicServerWidget();
}

class _topicServerWidget extends State<topicServerWidget>{
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: widget.width == null ? 10 : 0),
      width: widget.width ?? 300,
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
                  child: AutoSizeText(widget.name, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 0),
                  child: AutoSizeText(AppLocalizations.of(context)!.course_owner(widget.owner), style: TextStyle(fontSize: 18, color: Colors.blue),),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 0),
                  child: AutoSizeText(AppLocalizations.of(context)!.amount_word("${widget.amount}"), style: TextStyle(fontSize: 18, color: Colors.red),),
                ),
              ],
            ),
          )
        ],
      )
    );
  }

}