import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/Config/dataHelper.dart';
import 'package:japaneseapp/Widget/wordWidget.dart';
import 'package:sqflite/sqflite.dart';

class listWordScreen extends StatefulWidget{
  final String topicName;

  const listWordScreen({super.key, required this.topicName});
  @override
  State<StatefulWidget> createState() => _listWordScreen();
}

class _listWordScreen extends State<listWordScreen>{

  Future<List<Map<String, dynamic>>> hanldeDataWords(String topic) async {
    DatabaseHelper db = DatabaseHelper.instance;
    List<Map<String, dynamic>> dataWords = await db.getAllWordbyTopic(topic);
    return dataWords;
  }

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
      body: FutureBuilder(future: hanldeDataWords(widget.topicName), builder: (ctx, snapshot){
        return Container(
          height: double.infinity,
          child: Column(
            children: [
              Container(
                  height: MediaQuery.sizeOf(context).height - AppBar().preferredSize.height-150,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        SizedBox(height: 20,),
                        GridView.count(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 5,
                          crossAxisCount: 3,
                          childAspectRatio: 3 / 3,
                          children: snapshot.data!.map((word) => wordWidget(word: word["word"], level: word["level"])).toList(),
                        ),
                      ],
                    ),
                  )
              ),
              SizedBox(height: 20,),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 250,
                  height: 80,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(20, 195, 142, 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: Center(
                    child: Text("勉強", style: TextStyle(color: Colors.white, fontSize: 25),),
                  )
                ),
              )
            ],
          ),
        );
      })
    );
  }

}