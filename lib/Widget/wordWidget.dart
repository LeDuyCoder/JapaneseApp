import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class wordWidget extends StatefulWidget{

  final String word;
  final int level;

  const wordWidget({super.key, required this.word, required this.level});

  @override
  State<StatefulWidget> createState() => _wordWidget();

}

class _wordWidget extends State<wordWidget>{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0),
      child: Container(
        child: Stack(
          children: [
            Container(
                width: 120,
                height: 100,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey
                    ),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(10))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(widget.word, style: TextStyle(fontFamily: "aoboshione", fontSize: 20,), textAlign: TextAlign.center,),
                    )
                  ],
                )
            ),
            Container(
              width: 120,
              height: 100,
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
                    value: widget.level/28, // 50% progress
                    backgroundColor: Colors.white,
                    color: widget.level==28?Color.fromRGBO(255, 196, 0, 1.0):Color.fromRGBO(0, 255, 171, 1.0),
                    minHeight: 10.0,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}