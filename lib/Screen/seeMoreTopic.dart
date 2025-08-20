import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/Module/topic.dart';
import 'package:japaneseapp/Widget/topicServerWidget.dart';

import '../Config/dataHelper.dart';
import '../Config/databaseServer.dart';

class seeMoreTopic extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _seeMoreTopic();
}

class _seeMoreTopic extends State<seeMoreTopic>{
  TextEditingController searchTopicInput = new TextEditingController();
  int lenghtInput = 0;
  Timer? _debounce;
  List<topic> topicsSearch = [];

  

  @override
  void initState() {
    searchTopicInput.addListener(() {
      setState(() {
        lenghtInput = searchTopicInput.text.length;
      });

      if (_debounce?.isActive ?? false) _debounce!.cancel();

      // Đợi 300ms sau khi người dùng dừng gõ để gọi API
      _debounce = Timer(const Duration(milliseconds: 300), () async {
        String query = searchTopicInput.text.trim();

        if (query.isNotEmpty) {
          topicsSearch = await getListTopicsSearch(query);
        }
      });
      // if (searchTopicInput.text.isEmpty) {
      //   // Gán lại giá trị mặc định sau 1 frame để tránh lỗi setState trong listener
      //   Future.microtask(() {
      //     searchTopicInput.text = "";
      //     searchTopicInput.selection = TextSelection.fromPosition(
      //       TextPosition(offset: searchTopicInput.text.length),
      //     );
      //   });
      // }
    });
  }

  int limit = 5;

  Future<List<topic>> getListTopic() async {
    DatabaseServer dbServer = new DatabaseServer("http://10.0.2.2:80/backendServer");
    return await dbServer.getAllDataTopic(limit).timeout(Duration(seconds: 10));
  }

  Future<List<topic>> getListTopicsSearch(String keyword) async {
    DatabaseServer dbServer = new DatabaseServer("http://10.0.2.2:80/backendServer");
    return await dbServer.getTopicsSearch(keyword).timeout(Duration(seconds: 10));
  }

  Future<bool> hastTopic(String id) async {
    DatabaseHelper db = DatabaseHelper.instance;
    return await db.hasTopicID(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true, // hoặc false nếu không cần icon back
        foregroundColor: Colors.black,   // Đảm bảo icon/text không bị trắng
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 18),
        iconTheme: const IconThemeData(color: Colors.black), // icon màu đen
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              width: MediaQuery.sizeOf(context).width,
              height: 100,
              child: TextField(
                controller: searchTopicInput,
                decoration: InputDecoration(
                  hintText: "Tên thư mục",
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 20.0,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color.fromRGBO(214, 214, 214, 1), width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color.fromRGBO(214, 214, 214, 1), width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            if(lenghtInput == 0)
              Expanded(
              child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: FutureBuilder(future: getListTopic(), builder: (context, data){
                    if(data.connectionState == ConnectionState.waiting){
                      return Container(
                        child: CircularProgressIndicator(
                          color: CupertinoColors.activeGreen,
                        ),
                      );
                    }

                    if(data.hasData){
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          for(topic Topic in data.data!)
                            Column(
                              children: [
                                FutureBuilder(future: hastTopic(Topic.id), builder: (context, topicData){
                                  if(topicData.connectionState == ConnectionState.waiting) return Container();
                                  return topicServerWidget(name: Topic.name, owner: Topic.owner!, amount: Topic.count!, isDowloaded: topicData.data!, width: MediaQuery.sizeOf(context).width - 30,);
                                }),
                                const SizedBox(height: 10,),
                              ],
                            ),
                          SizedBox(height: 20,),
                          if(data.data!.length >= limit)
                            Container(
                              width: MediaQuery.sizeOf(context).width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        limit += 5;
                                      });
                                    },
                                    child: Text(
                                      "See More",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20
                                      ),
                                    ),
                                  ),
                                  Icon(Icons.arrow_drop_down_outlined)
                                ],
                              ),
                            ),
                          const SizedBox(height: 50,),

                        ],
                      );
                    }

                    return Text(
                        "Lỗi Kết Nối Đến Server"
                    );
                  })
                ),
              ),
            ),

            if(lenghtInput > 0)
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if(topicsSearch.length > 0)
                            for(topic Topic in topicsSearch)
                              Column(
                                children: [
                                  FutureBuilder(future: hastTopic(Topic.id), builder: (context, topicData){
                                    if(topicData.connectionState == ConnectionState.waiting) return Container();
                                    return topicServerWidget(name: Topic.name, owner: Topic.owner!, amount: Topic.count!, isDowloaded: topicData.data!, width: MediaQuery.sizeOf(context).width - 30,);
                                  }),
                                  const SizedBox(height: 10,),
                                ],
                              ),

                            if(topicsSearch.length == 0)
                              Center(
                                child: Text("Không Tìm Thấy Topic",),
                              ),
                          const SizedBox(height: 50,),

                        ],
                      )
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

}