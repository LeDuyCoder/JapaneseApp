import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/Module/topic.dart';
import 'package:japaneseapp/Widget/topicServerWidget.dart';

import '../Config/dataHelper.dart';
import '../Config/databaseServer.dart';
import '../Module/WordModule.dart';
import '../Module/word.dart';

class seeMoreTopic extends StatefulWidget{
  final Function() reloadScreen;

  const seeMoreTopic({super.key, required this.reloadScreen});

  @override
  State<StatefulWidget> createState() => _seeMoreTopic();
}

class _seeMoreTopic extends State<seeMoreTopic>{
  TextEditingController searchTopicInput = new TextEditingController();
  int lenghtInput = 0;
  Timer? _debounce;
  List<topic> topicsSearch = [];
  String nameTopic = "";

  TextEditingController renameTopicInput = TextEditingController();
  String? textErrorName;
  String? textErrorTopicName;

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
    DatabaseServer dbServer = new DatabaseServer();
    return await dbServer.getAllDataTopic(limit).timeout(Duration(seconds: 10));
  }

  Future<List<topic>> getListTopicsSearch(String keyword) async {
    DatabaseServer dbServer = new DatabaseServer();
    return await dbServer.getTopicsSearch(keyword).timeout(Duration(seconds: 10));
  }

  Future<bool> hastTopic(String id) async {
    DatabaseHelper db = DatabaseHelper.instance;
    return await db.hasTopicID(id);
  }

  Future<void> dowloadTopic(String id) async{
    DatabaseServer dbServer = new DatabaseServer();
    DatabaseHelper db = DatabaseHelper.instance;

    topic Topic = await dbServer.getDataTopicbyID(id);
    nameTopic = Topic.name;
    List<Map<String, dynamic>> dataWords = [];

    if(await db.hasTopicName(nameTopic)){
      await showDialogRenameTopic();
    }

    if(!await db.hasTopicName(nameTopic)){
      List<Word> listWord = await dbServer.fetchWordsByTopicID(id);
      for(Word wordDB in listWord){
        dataWords.add(
            new word(wordDB.word, wordDB.wayread, wordDB.mean, nameTopic==""?Topic.name:nameTopic, 0).toMap()
        );
      }

      await db.insertTopicID(Topic.id, nameTopic==""?Topic.name:nameTopic, Topic.owner!);
      await db.insertDataTopic(dataWords);
    }

    Navigator.pop(context);
    setState(() {
    });
  }

  Future<bool> showDialogRenameTopic() async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Barrier",
      barrierColor: Colors.black.withOpacity(0.5), // Màu nền tối mờ
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return const SizedBox(); // Trả về rỗng vì dùng transitionBuilder
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedValue = Curves.easeInOut.transform(animation.value);

        return Transform.translate(
          offset: Offset(0, -300 + (300 * curvedValue)),
          child: Opacity(
            opacity: animation.value,
            child: Center(
              child: Dialog(
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: StatefulBuilder(
                  builder: (BuildContext context, setState) {
                    return Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Color.fromRGBO(195, 20, 20, 1.0), // Màu xanh cạnh trên ngoài cùng
                              width: 10.0, // Độ dày của cạnh trên
                            ),
                          ),
                        ),
                        child: Container(
                          height: 350,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset("assets/character/character6.png", width: MediaQuery.sizeOf(context).width*0.3,),
                              Column(
                                children: [
                                  SizedBox(height: 20),
                                  const AutoSizeText(
                                    "Tên Topic Đã Tồn Tại Vui Lòng Đổi Tên",
                                    style: TextStyle(fontFamily: "indieflower", fontSize: 15),
                                  ),

                                  Container(
                                    padding: const EdgeInsets.all(16.0),
                                    width: MediaQuery.sizeOf(context).width - 100,
                                    height: 100,
                                    child: TextField(
                                      controller: renameTopicInput,
                                      decoration: InputDecoration(
                                        hintText: "Tên topic mới",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 12.0,
                                          vertical: 20.0,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Colors.red, width: 3.0),
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        errorText: textErrorTopicName,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      DatabaseHelper db = DatabaseHelper.instance;
                                      if(await db.hasTopicName(renameTopicInput.text)){
                                        setState((){
                                          textErrorTopicName = "Tên mới đã tồn tại";
                                        });
                                      }else{
                                        setState((){
                                          nameTopic = renameTopicInput.text;
                                          Navigator.pop(context);
                                          textErrorTopicName = null;
                                          renameTopicInput.text = "";
                                        });
                                      }
                                    },
                                    child: Container(
                                      width: MediaQuery.sizeOf(context).width * 0.3,
                                      height: MediaQuery.sizeOf(context).height * 0.05,
                                      decoration: const BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "Đổi Tên",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );

    return true;
  }

  void showDialogDowloadPulic(String id) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Barrier",
      barrierColor: Colors.black.withOpacity(0.5), // Màu nền tối mờ
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return const SizedBox(); // Trả về rỗng vì dùng transitionBuilder
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedValue = Curves.easeInOut.transform(animation.value);

        return Transform.translate(
          offset: Offset(0, -300 + (300 * curvedValue)),
          child: Opacity(
            opacity: animation.value,
            child: Center(
              child: Dialog(
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: StatefulBuilder(
                  builder: (BuildContext context, setState) {
                    return Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Color.fromRGBO(20, 195, 142, 1.0), // Màu xanh cạnh trên ngoài cùng
                              width: 10.0, // Độ dày của cạnh trên
                            ),
                          ),
                        ),
                        child: Container(
                          height: 300,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset("assets/character/character6.png", width: MediaQuery.sizeOf(context).width*0.3,),
                              const Column(
                                children: [
                                  SizedBox(height: 20),
                                  AutoSizeText(
                                    "Bạn có muốn tải xuống không ?",
                                    style: TextStyle(fontFamily: "indieflower", fontSize: 15),
                                  ),
                                  SizedBox(height: 20),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      width: MediaQuery.sizeOf(context).width*0.3,
                                      height: MediaQuery.sizeOf(context).height*0.05,
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                          boxShadow: [
                                          ]
                                      ),
                                      child: const Center(
                                        child: Text("Hủy", style: TextStyle(color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),),
                                      ),
                                    ),

                                  ),
                                  SizedBox(width:10,),
                                  GestureDetector(
                                    onTap: () async {
                                      dowloadTopic(id);
                                    },
                                    child: Container(
                                      width: MediaQuery.sizeOf(context).width * 0.3,
                                      height: MediaQuery.sizeOf(context).height * 0.05,
                                      decoration: const BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "Tải",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
          widget.reloadScreen();
        }, icon: Icon(Icons.arrow_back)),
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
                            GestureDetector(
                              onTap: () async {
                                if(await hastTopic(Topic.id) == false){
                                  showDialogDowloadPulic(Topic.id);
                                }
                              },
                              child: Column(
                                children: [
                                  FutureBuilder(future: hastTopic(Topic.id), builder: (context, topicData){
                                    if(topicData.connectionState == ConnectionState.waiting) return Container();
                                    return topicServerWidget(name: Topic.name, owner: Topic.owner!, amount: Topic.count!, isDowloaded: topicData.data!, width: MediaQuery.sizeOf(context).width - 30,);
                                  }),
                                  const SizedBox(height: 10,),
                                ],
                              ),
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
                              GestureDetector(
                                onTap: () async {
                                  if(await hastTopic(Topic.id) == false){
                                    showDialogDowloadPulic(Topic.id);
                                  }
                                },
                                child: Column(
                                  children: [
                                    FutureBuilder(future: hastTopic(Topic.id), builder: (context, topicData){
                                      if(topicData.connectionState == ConnectionState.waiting) return Container();
                                      return topicServerWidget(name: Topic.name, owner: Topic.owner!, amount: Topic.count!, isDowloaded: topicData.data!, width: MediaQuery.sizeOf(context).width - 30,);
                                    }),
                                    const SizedBox(height: 10,),
                                  ],
                                ),
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