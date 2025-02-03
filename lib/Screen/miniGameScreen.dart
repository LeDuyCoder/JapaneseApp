import 'dart:core';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/Config/dataHelper.dart';
import 'package:japaneseapp/Module/word.dart';
import 'package:japaneseapp/Widget/miniGame/dragonCave.dart';
import 'package:japaneseapp/Widget/miniGame/findBeach.dart';
import 'package:japaneseapp/Widget/miniGameWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Widget/learnWidget/sortText.dart.dart';

class miniGameScreen extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _miniGameScreen();
}

class _miniGameScreen extends State<miniGameScreen>{

  List<String> hanldStringChoseVN(String mean) {
    List<String> newListString = mean.split(" ")
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    newListString.shuffle();
    return newListString;
  }

  List<String> handleJapaneseString(String input) {
    List<String> characters = input.split('')
        .where((e) => e.trim().isNotEmpty)
        .toList();
    characters.shuffle(Random());
    return characters;
  }

  void reloadScreen(){
    setState(() {});
  }

  Future<void> flusExp(int expplus) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int level = await prefs.getInt("level")??0;
    int exp = await prefs.getInt("exp")??0;
    int nextExp = prefs.getInt("nextExp")??0;

    exp += expplus;

    while(exp >= nextExp){
      level++;
      exp -= nextExp;
      nextExp = 10*(level*level)+50*level+100;
    }

    await prefs.setInt("level", level);
    await prefs.setInt("exp", exp);
    await prefs.setInt("nextExp", nextExp);
  }

  String generateWrongAwnser(String typeAwnser, String rightAwnser, List<word> dataWords){
    word RanWord;

    do{
      RanWord = dataWords[Random().nextInt(dataWords.length)];
    }while(rightAwnser == RanWord.mean || rightAwnser == RanWord.vocabulary);
    if(typeAwnser == "JapToVN"){
      return RanWord.mean;
    }
    return RanWord.vocabulary;
  }

  void showOverlay(BuildContext context) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: 20,
        right: 20,
        top: 50,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(12),
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.grey,
                      blurRadius: 20,
                      offset: Offset(4, -4)
                  )
                ]
            ),
            child: const Text(
              'Có Ít Nhất 1 Topic Mới Có Thể Vào',
              style: TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(Duration(seconds: 3), () async {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          child: const Text(
            "Mini Game",
            style: TextStyle(fontFamily: "aboshione", fontSize: 20, color: Colors.white),
          ),
        ),
        backgroundColor: Color.fromRGBO(20, 195, 142, 1.0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Container(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(height: 20,),
              miniGameWidget(accessImage: 'assets/seaBackground.png', title: 'Khám Phá Bải Biển', descrition: 'Điểm Kinh Nghiệm: 30 Kiến Thức', lock: false, executeCommand: ()async{
                DatabaseHelper db = DatabaseHelper.instance;
                List<Map<String, dynamic>> topics = await db.getAllTopic();
                if(topics.length >= 1) {
                  String topic = (topics[Random().nextInt(
                      topics.length)])["name"];
                  List<Map<String, dynamic>> dataWords = await db
                      .getAllWordbyTopic(topic);

                  List<word> words = [];

                  for (Map<String, dynamic> wordCheck in dataWords) {
                    words.add(
                        word(
                            wordCheck["word"],
                            wordCheck["wayread"],
                            wordCheck["mean"],
                            wordCheck["topic"],
                            wordCheck["level"]
                        )
                    );
                  }

                  Map<int, Map<String, dynamic>> listChest = {};
                  int chestSlotLucky = Random().nextInt(16);
                  listChest.putIfAbsent(
                      chestSlotLucky, () => {"feture": "gift"});

                  for (int i = 0; i <= 15; i++) {
                    if (!listChest.containsKey(i)) {
                      word WordTest = words[Random().nextInt(words.length)];

                      typeSort ranType = Random().nextInt(2) == 0
                          ? typeSort.VietNamToJapan
                          : typeSort.JapanToVietNam;

                      listChest.putIfAbsent(i, () =>
                      {
                        "feture": "sort",
                        "type": "translatte",
                        "typeTranslate": ranType,
                        "listChose": ranType == typeSort.JapanToVietNam
                            ? hanldStringChoseVN("${WordTest
                            .mean} ${generateWrongAwnser(
                            "JapToVN", WordTest.mean, words)}")
                            : handleJapaneseString("${WordTest
                            .vocabulary} ${generateWrongAwnser(
                            "VNToJap", WordTest.mean, words)}"),
                        "word": WordTest
                      });
                    }
                  }

                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>
                          findBeach(dataMiniGame: listChest,
                            numberGift: chestSlotLucky,
                            plusExp: (int exp) {
                              flusExp(exp);
                            },
                            reloadScreen: () {
                              reloadScreen();
                            },)));
                }else{
                 showOverlay(context);
                }}, dbTimeName: 'findbeachTime',),
              const SizedBox(height: 20,),
              miniGameWidget(accessImage: 'assets/dragonCave.png', title: 'Khám Phá Hang Rồng', descrition: 'Điểm Kinh Nghiệm: 80 Kiến Thức', lock: false, executeCommand: () async {
                DatabaseHelper db = DatabaseHelper.instance;
                List<Map<String, dynamic>> topics = await db.getAllTopic();
                print(topics);
                String topic = (topics[Random().nextInt(topics.length)])["name"];
                List<Map<String, dynamic>> dataWords = await db.getAllWordbyTopic(topic);

                List<word> words = [];

                for(Map<String, dynamic> wordCheck in dataWords){
                  words.add(
                      word(
                          wordCheck["word"],
                          wordCheck["wayread"],
                          wordCheck["mean"],
                          wordCheck["topic"],
                          wordCheck["level"]
                      )
                  );
                }

                Navigator.push(context, MaterialPageRoute(builder: (context)=>dragonCave(listWords: words, plusExp: () { flusExp(80); }, reloadScreen: () { reloadScreen(); },)));
              }, dbTimeName: 'dragonCaveTime',),
              const SizedBox(height: 20,),
              miniGameWidget(accessImage: 'assets/seaBeachBackground.png', title: 'Báu Vật Đại Dương', descrition: 'Điểm Kinh Nghiệm: 50 Kiến Thức', lock: true, executeCommand: (){}, dbTimeName: 'treasureOfSeaTime',)
            ],
          )
      ),
    );
  }

}