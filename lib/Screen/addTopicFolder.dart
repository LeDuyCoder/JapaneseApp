import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Module/topic.dart';
import '../Service/Local/local_db_service.dart';
import '../generated/app_localizations.dart';

class addTopicFolder extends StatefulWidget{
  final int idFolder;
  final Function reloadScreen;

  const addTopicFolder({super.key, required this.idFolder, required this.reloadScreen});

  @override
  State<StatefulWidget> createState() => _addTopicFolder();
}

class _addTopicFolder extends State<addTopicFolder>{

  Future<bool> checkTopicExistInFolder(String idTopic) async {
    final db = LocalDbService.instance;
    return db.folderDao.hasTopicInFolder(widget.idFolder, idTopic);
  }

  Future<List<topic>> getInfoTopic() async {
    List<topic> topics = [];
    final db = LocalDbService.instance;
    List<Map<String, dynamic>> allTopic = await db.topicDao.getAllTopics();
    if(allTopic.isNotEmpty) {
      for (Map<String, dynamic> topicMap in allTopic) {
        topics.add(topic(id: topicMap["id"], name: topicMap["name"], owner: topicMap["user"], count: (await db.topicDao.getAllWordsByTopic(topicMap["name"])).length));
      }
    }
    return topics;
  }

  Widget topicView(topic Topic, bool ischose, Function() choseItem){
    return GestureDetector(
      onTap: (){
        choseItem();
      },
      child: Container(
        width: MediaQuery.sizeOf(context).width - 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              child: Icon(Icons.sticky_note_2_outlined, size: 30),
            ),
            SizedBox(width: 10,),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Topic.name, style: TextStyle(fontSize: 20),),
                    Text(
                        "${AppLocalizations.of(context)!.folderManager_Screen_addTopic_card_owner(Topic.owner!)} - ${AppLocalizations.of(context)!.folderManager_Screen_addTopic_card_amountWord(Topic.count!)}",
                        style: TextStyle(color: Colors.grey, fontSize: 15,),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )
            ),
            ischose ? Icon(Icons.check_circle, color: Colors.green, size: 30) : Icon(Icons.add_circle_outline_rounded, color: Colors.grey, size: 30),
          ],
        )
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          widget.reloadScreen();
          Navigator.pop(context);
        }, icon: Icon(Icons.close, size: 40,)),
        title: Text(AppLocalizations.of(context)!.folderManager_Screen_addTopic_title, style: TextStyle(fontSize: 20, color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        color: Colors.white,
        child: FutureBuilder(future: getInfoTopic(), builder: (context, dataTopics){
          if(dataTopics.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          if(dataTopics.hasError){
            return Center(child: Text("Lỗi tải dữ liệu: ${dataTopics.error}"));
          }

          if(dataTopics.data == null || (dataTopics.data as List<topic>).isEmpty){
            return Center(child: Text("Không có chủ đề nào"));
          }

          List<topic> topics = dataTopics.data as List<topic>;
          return ListView.builder(
            itemCount: topics.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  SizedBox(height: 30,),
                  FutureBuilder(future: checkTopicExistInFolder(topics[index].id), builder: (context, isExistTopic){
                    if(isExistTopic.connectionState == ConnectionState.waiting){
                      return Center(child: CircularProgressIndicator());
                    }
                    if(isExistTopic.hasError){
                      return Center(child: Text("Lỗi kiểm tra chủ đề: ${isExistTopic.error}"));
                    }

                    bool isChose = isExistTopic.data as bool;
                    return topicView(topics[index], isChose, () async {
                      final db = LocalDbService.instance;
                      if(isChose == false) {
                        await db.folderDao.addTopicToFolder(widget.idFolder, topics[index].id);
                        setState(() {
                        });
                      }else{
                        await db.folderDao.removeTopicFromFolder(widget.idFolder, topics[index].id);
                        setState(() {});
                      }
                    });
                  })
                ],
              );
            });
        })
      )
    );
  }
}