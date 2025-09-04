import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/Theme/colors.dart';

import '../Config/dataHelper.dart';
import '../Widget/topicWidget.dart';

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
            "Chủ Đề Của Tôi",
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
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.sizeOf(context).width/1.2,
                    decoration: const BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.grey,
                              offset: Offset(0, 2),
                              blurRadius: 10
                          )
                        ],
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.sizeOf(context).height / 1.5,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Chủ Đề", style: TextStyle(fontSize: 20, fontFamily: "Itim"),),
                            Divider(
                              height: 4,
                              color: AppColors.primary,
                            ),
                            SizedBox(height: 10,),
                            Container(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: [
                                    for (Map<String, dynamic> topicLocal in snapshot.data?["topic"])
                                      topicWidget(
                                        id: topicLocal["id"],
                                        nameTopic: topicLocal["name"],
                                        reloadDashBoard: () {
                                          setState(() {

                                          });
                                        },
                                      ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ), // table hoặc column của bạn
                      ),
                    ),
                  ),
                ],
              )
          );
        }

        return Container();

      }),
    );
  }

}