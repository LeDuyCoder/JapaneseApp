import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:japaneseapp/Widget/choseColumeWidget.dart';
import 'package:japaneseapp/Widget/learnWidget/listenTest.dart';
import 'package:japaneseapp/Widget/learnWidget/rightTab.dart';
import 'package:japaneseapp/Widget/learnWidget/wrongTab.dart';

class combinationTest extends StatefulWidget{
  final List<Map<String, dynamic>> listColumA;
  final List<String> listColumB;
  final void Function() nextQuestion;

  const combinationTest({super.key, required this.listColumA, required this.listColumB, required this.nextQuestion});
  @override
  State<StatefulWidget> createState() => _combinationTest();
}

class _combinationTest extends State<combinationTest>{

  List<Map<String, dynamic>> listColumA_State = [];
  List<String> listColumB_State = [];

   Map<String, dynamic>? columeA_Chose;
   String? columeB_Chose;

   String? choseWrongA, choseWrongB;

   List<Map<String, dynamic>> listComplete = [];

  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterTts _flutterTts = FlutterTts();

  // Hàm chạy file MP3 từ đường dẫn
  Future<void> playSound(String filePath) async {
    try {
      await _audioPlayer.play(AssetSource(filePath));
      print("Đang phát âm thanh: $filePath");
    } catch (e) {
      print("Lỗi khi phát âm thanh: $e");
    }
  }

  Future<void> readText(String text, double speed) async {
    await _flutterTts.setLanguage("ja-JP");
    await _flutterTts.setSpeechRate(speed);
    await _flutterTts.speak(text);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    listColumA_State = List.from(widget.listColumA); // Tạo bản sao có thể thay đổi
    listColumB_State = List.from(widget.listColumB);

    listColumA_State.shuffle();
    listColumB_State.shuffle();

    print(listColumB_State);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color:  Colors.white,
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height - AppBar().preferredSize.height - 30,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [

              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Text("Match Colume A To Colume B", style: TextStyle(fontSize: MediaQuery.sizeOf(context).width*0.05, fontWeight: FontWeight.bold),),
                  ],
                ),
              ),

              for(int i = 0; i<4; i++)
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      choseColumeWidget(text: listColumA_State[i]["word"], isChoose: columeA_Chose == listColumA_State[i], isCancle: (listComplete.any((element) => element["columeA"]["word"] == listColumA_State[i]["word"])), functionButton: () {
                              readText(listColumA_State[i]["wayread"], 0.5);
                              setState(() {
                                  if(columeB_Chose != null){
                                    columeB_Chose = null;
                                  }

                                  if(columeA_Chose != null && columeA_Chose == listColumA_State[i]){
                                    columeA_Chose = null;
                                  }else {
                                    columeA_Chose = listColumA_State[i];
                                  }
                                });
                              }, isWrong: choseWrongA != null && columeA_Chose!["awnser"] == choseWrongA && listColumA_State[i] == columeA_Chose
                      ),
                      choseColumeWidget(text: listColumB_State[i], isChoose: columeB_Chose == listColumB_State[i], isCancle: (listComplete.any((element) =>
                      element["columeB"] == listColumB_State[i])), functionButton: () {
                            setState(() {
                              if(choseWrongB == listColumB_State[i]){
                                columeB_Chose = null;
                              } else {
                                columeB_Chose = listColumB_State[i];
                              }
                            });
                            if(columeA_Chose != null){
                              if(columeA_Chose!["awnser"] == columeB_Chose){
                                setState(() {
                                  Map<String, dynamic> dataWordRight = {
                                    "columeA": {
                                      "word": columeA_Chose!["word"],
                                      "anwser": columeA_Chose!["awnser"]
                                    },
                                    "columeB": columeA_Chose!["awnser"]
                                  };

                                  setState(() {
                                    listComplete.add(dataWordRight);
                                    columeB_Chose = null;
                                    columeA_Chose = null;
                                  });
                                });
                              }else{
                                choseWrongA = columeA_Chose!["awnser"];
                                choseWrongB = columeB_Chose;

                                playSound("sound/wrong.mp3");
                                showModalBottomSheet(enableDrag: false, isDismissible: false, context: context, builder: (context)=>wrongTab(nextQuestion: (){
                                  setState(() {
                                    columeB_Chose = null;
                                    columeA_Chose = null;
                                    choseWrongA = null;
                                    choseWrongB = null;
                                  });
                                }, rightAwnser: columeA_Chose!["awnser"]));
                              }
                            }
                          }, isWrong: choseWrongB != null && choseWrongB == listColumB_State[i]
                      ,)
                    ],
                  ),
                ),

              SizedBox(height: 50,),
              GestureDetector(
                onTap: (){
                  if(listComplete.length == 4){
                    if(listComplete.length >= 4){
                      playSound("sound/correct.mp3");
                      showModalBottomSheet(enableDrag: false,isDismissible: false, context: context, builder: (ctx) => rightTab(nextQuestion: (){
                        widget.nextQuestion();
                      }));
                    }
                  }
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width - 40,
                  height: MediaQuery.sizeOf(context).width * 0.15,
                  decoration: BoxDecoration(
                      color: listComplete.length == 4 ? const Color.fromRGBO(97, 213, 88, 1.0) : Color.fromRGBO(
                          195, 195, 195, 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                            color: listComplete.length == 4 ? Colors.green : const Color.fromRGBO(
                                177, 177, 177, 1.0),
                            offset: Offset(6, 6)
                        )
                      ]
                  ),
                  child: Center(
                    child: Text("CHECK", style: TextStyle(color: listComplete.length == 4 ? Colors.white : Colors.grey, fontSize: MediaQuery.sizeOf(context).width*0.045, fontWeight: FontWeight.bold),),
                  ),
                ),
              ),
            ],
          ),
        )

      ),
    );
  }

}
