import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/Config/dataHelper.dart';
import 'package:japaneseapp/Module/topic.dart';
import 'package:japaneseapp/Widget/topicManagerWidget.dart';

class folderManagerScreen extends StatefulWidget{
  final String nameFolder;
  final void Function() reloadDashBoard;

  const folderManagerScreen({super.key, required this.nameFolder, required this.reloadDashBoard});

  @override
  State<StatefulWidget> createState() => _folderMangerScreen();
}

class _folderMangerScreen extends State<folderManagerScreen>{

  List<topic>? dataTopics;
  topic? topicChose;
  List<topic> dataTopicOut = [];

  Future<List<topic>> hanldTopicAdd() async {
    List<topic> topics = [];
    DatabaseHelper db = DatabaseHelper.instance;
    List<Map<String, dynamic>> allTopic = await db.getAllTopic();
    if(allTopic.isNotEmpty) {
      for (Map<String, dynamic> topicMap in allTopic) {
        topics.add(topic(id: topicMap["id"], name: topicMap["name"]));
      }
    }
    return topics;
  }

  Future<List<topic>> hanldeDataTopic() async {
    final db = DatabaseHelper.instance;
    List<Map<String, dynamic>> dataTopicinFolder = await db.getDataTopicbyNameFolder(widget.nameFolder);
    List<topic> dataRult = [];

    if (!dataTopicinFolder.isEmpty) {
      Map<String, dynamic> data = dataTopicinFolder[0];
      String? dataTopic = data["topics"];
      if(dataTopic != null) {
        try {
          List<dynamic> dataDecodeMap = jsonDecode(dataTopic);
          dataDecodeMap.forEach((data) {
            dataRult.add(topic(id: (data as Map<String, dynamic>).keys.first,
                name: (data as Map<String, dynamic>).values.first));
          });
        } catch (e) {
          print("Lỗi khi decode JSON: $e");
        }
      }
    }


    if (dataTopics == null || dataTopics!.isEmpty) {
      dataTopics = dataRult;
    }

    return dataRult;
  }

  Future<void> updateDataBase() async {
    DatabaseHelper db = DatabaseHelper.instance;
    List<Map<String, dynamic>> dataCoverMap = [];

    for(topic TopicHanlde in dataTopics!){
      dataCoverMap.add(
          {TopicHanlde.id:TopicHanlde.name}
      );
    }

    await db.updateDatabase("folders", {"topics":jsonEncode(dataCoverMap)}, "namefolder = '${widget.nameFolder}'");
  }

  void removeTopic(topic Topic) async {
    setState(() {
      dataTopics?.remove(Topic);
    });

    await updateDataBase();
  }

  void reload(){
    setState(() {});
  }


  Widget topicView(topic Topic, bool ischose, Function() choseItem){
    return GestureDetector(
      onTap: (){
        choseItem();
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
            border: Border.all(
              color: ischose ? Colors.blue : Colors.grey,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child: Center(
          child: Text(Topic.name, style: TextStyle(fontFamily: "indieflower", fontSize: 20),),
        ),
      ),
    );
  }

  void showDialogAddTopic(){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ), // Bo góc popup
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color.fromRGBO(20, 195, 142, 1.0), // Màu xanh cạnh trên ngoài cùng
                      width: 10.0, // Độ dày của cạnh trên
                    ),
                  ),
                ),
                child: FutureBuilder(future: hanldTopicAdd(), builder: (ctx, snapshot){

                  if(snapshot.hasData){
                    dataTopicOut.clear();

                    for(topic dataTopicHanlde in snapshot.data!){
                      if(!dataTopics!.any((topic) => dataTopicHanlde.id == topic.id)){
                        dataTopicOut.add(dataTopicHanlde);
                      }
                    }

                    return Stack(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'Add Topic',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              height: 300,
                              child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: GridView.count(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        crossAxisSpacing: 5,
                                        mainAxisSpacing: 5,
                                        crossAxisCount: 2,
                                        childAspectRatio: 4 / 3,
                                        children: [
                                          for(topic topicInList in dataTopicOut)
                                            topicView(
                                              topicInList,
                                              topicChose?.id == topicInList.id,
                                                  () {
                                                setState(() {
                                                  if (topicChose?.id == topicInList.id) {
                                                    // Nếu phần tử đã được chọn, thì bỏ chọn
                                                    topicChose = null;
                                                  } else {
                                                    // Nếu chưa được chọn, thì chọn phần tử này
                                                    topicChose = topicInList;
                                                  }
                                                });
                                              },
                                            )
                                        ]
                                    ),
                                  )
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10, bottom: 10, right: 5),
                                      child: Container(
                                        width: 100,
                                        height: 50,
                                        decoration: const BoxDecoration(
                                          color: Color.fromRGBO(255, 32, 32, 1.0),
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(color: Colors.white, fontSize: 15),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      if(topicChose!=null){
                                        setState((){
                                          dataTopics?.add(topicChose!);
                                          topicChose = null;
                                          reload();
                                        });
                                      }

                                      //insert new data into database
                                      await updateDataBase();
                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Container(
                                        width: 100,
                                        height: 50,
                                        decoration: const BoxDecoration(
                                          color: Color.fromRGBO(184, 241, 176, 1),
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "Confirm",
                                            style: TextStyle(color: Colors.black, fontSize: 15),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }

                  return Center();
                }),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: const Text(
            "Vocabulary N5",
            style: TextStyle(fontFamily: "indieflower", fontSize: 20, color: Colors.white),
          ),
        ),
        actions: [
          IconButton(onPressed: (){
            showDialogAddTopic();
          }, icon: Icon(Icons.create_new_folder_outlined, color: Colors.black, size: 30,))
        ],
        backgroundColor: Color.fromRGBO(20, 195, 142, 1.0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: FutureBuilder(future: hanldeDataTopic(), builder: (ctx, snapshot){
        if(snapshot.hasData){
          return Container(
            color: Colors.white,
            width: MediaQuery.sizeOf(context).width,
            height: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10,),
                  if(dataTopics!.isNotEmpty ) 
                    for(topic dataTopic in dataTopics!)
                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: topicManagerWidget(dataTopic: dataTopic, removeTopic: () {
                          removeTopic(dataTopic);
                        }, reloadDashboard: () {
                          widget.reloadDashBoard();
                        },),
                      )
                  else
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).height - AppBar().preferredSize.height - 100,
                      child: const Center(
                        child: Text("No Data", style: TextStyle(fontFamily: "indieflower", fontSize: 30),),
                      ),
                    )
                ],
              ),
            ),
          );
        }

        return const Center();
      }),
    );
  }

}