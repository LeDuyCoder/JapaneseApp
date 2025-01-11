import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class addWordScreen extends StatefulWidget{
  final String topicName;

  const addWordScreen({super.key, required this.topicName});

  @override
  State<StatefulWidget> createState() => _addWordScreen();

}

class _addWordScreen extends State<addWordScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: const Text(
            "日本語",
            style: TextStyle(fontFamily: "aboshione", fontSize: 20, color: Colors.white),
          ),
        ),
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: Text(
                widget.topicName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
        backgroundColor: Color.fromRGBO(20, 195, 142, 1.0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
    );
  }

}