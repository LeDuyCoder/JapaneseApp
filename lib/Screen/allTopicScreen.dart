import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/Theme/colors.dart';

import '../Config/dataHelper.dart';
import '../Widget/topicWidget.dart';
import '../generated/app_localizations.dart';

class allTopicScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _allTopicScreen();
}

class _allTopicScreen extends State<allTopicScreen>{

  Future<Map<String, dynamic>> hanldeGetData() async {
    final db = await DatabaseHelper.instance;

    Map<String, dynamic> data = {
      "topic": await db.getAllTopic(),
    };

    return data;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.topic_seemore_title,
          style: TextStyle(color: AppColors.primary, fontSize: 25, fontFamily: "Itim", fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.backgroundPrimary,
        scrolledUnderElevation: 0,
      ),
      body: FutureBuilder(future: hanldeGetData(), builder: (data, snapshot){
        if(snapshot.hasData){
          return Container(
              width: MediaQuery.sizeOf(context).height,
              height: MediaQuery.sizeOf(context).height,
              color: AppColors.backgroundPrimary,
              child: Column(
                children: [
                  Container(
                    child: Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            for (Map<String, dynamic> topicLocal in snapshot.data?["topic"])
                              ...[
                                topicWidget(
                                  id: topicLocal["id"],
                                  nameTopic: topicLocal["name"],
                                  reloadDashBoard: () {
                                    setState(() {

                                    });
                                  },
                                ),
                              ]
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )
          );
        }

        return Container();

      }),
    );
  }

}