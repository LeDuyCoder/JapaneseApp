import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:japaneseapp/Config/dataHelper.dart';
import 'package:japaneseapp/Module/word.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Config/FunctionService.dart';

class congraculationScreen extends StatefulWidget{
  final List<word> listWordsTest, listWordsWrong;
  final int timeTest;
  final String topic;

  final void Function() reload;

  congraculationScreen({super.key, required this.listWordsTest, required this.listWordsWrong, required this.timeTest, required this.topic, required this.reload});

  @override
  State<StatefulWidget> createState() => _congraculationScreen();
}

class _congraculationScreen extends State<congraculationScreen>{

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPress = false;


  // Hàm chạy file MP3 từ đường dẫn
  Future<void> playSound(String filePath) async {
    try {
      await _audioPlayer.play(AssetSource(filePath));
      await FunctionService.setDay();
      print("Đang phát âm thanh: $filePath");
    } catch (e) {
      print("Lỗi khi phát âm thanh: $e");
    }
  }

  // Hàm dừng phát âm thanh
  Future<void> stopSound() async {
    try {
      await _audioPlayer.stop();
      print("Đã dừng âm thanh.");
    } catch (e) {
      print("Lỗi khi dừng âm thanh: $e");
    }
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

  @override
  Widget build(BuildContext context) {
    int persentAmazing = 100 - (widget.listWordsWrong.length * 2);
    String formatTime(double timeInSeconds) {
      int minutes = timeInSeconds ~/ 60; // Lấy số phút (chia lấy nguyên)
      int seconds = timeInSeconds % 60 ~/ 1; // Lấy số giây (phần dư của phép chia)

      // Định dạng chuỗi: thêm số 0 vào giây nếu cần
      String formattedTime = "$minutes:${seconds.toString().padLeft(2, '0')}";

      return formattedTime;
    }

    playSound("sound/completed.mp3");

    return Scaffold(
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/character/character2.png", scale: 0.8,),
            SizedBox(height: MediaQuery.sizeOf(context).height*0.02,),
            Text("Hoàn Thành", style: TextStyle(fontFamily: "indieflower", fontSize: MediaQuery.sizeOf(context).height*0.04, color: Color.fromRGBO(20, 195, 142, 1.0)),),
            Text("Bạn Thật Tuyệt Vời", style: TextStyle(fontFamily: "indieflower", fontSize: MediaQuery.sizeOf(context).height*0.02, color: Colors.black),),
            SizedBox(height: MediaQuery.sizeOf(context).height*0.02,),
            Container(
              width: double.infinity,
              child:Padding(
                padding: EdgeInsets.only(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width*0.4,
                      height: MediaQuery.sizeOf(context).width*0.30,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(20, 195, 142, 1.0),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Column(
                        children: [
                          Text("Commited", style: TextStyle(fontFamily: "indieflower", color: Colors.white, fontSize: MediaQuery.sizeOf(context).width*0.04),),
                          Container(
                            constraints: BoxConstraints(
                              minHeight: MediaQuery.sizeOf(context).width * 0.2, // Độ cao tối thiểu
                            ),
                            width: MediaQuery.sizeOf(context).width*0.38,
                            height: MediaQuery.sizeOf(context).width*0.22,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.timer_sharp, color: Color.fromRGBO(20, 195, 142, 1.0), size: 60,),
                                SizedBox(width: 10,),
                                Text(formatTime(widget.timeTest*1.0), style: TextStyle(fontSize: MediaQuery.sizeOf(context).height*0.030, fontFamily: "indieflower", color: Color.fromRGBO(20, 195, 142, 1.0))),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 10,),
                    Container(
                      width: MediaQuery.sizeOf(context).width*0.4,
                      height: MediaQuery.sizeOf(context).width*0.30,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 174, 9, 1.0),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Column(
                        children: [
                          Text("Amazing", style: TextStyle(fontFamily: "indieflower", color: Colors.white, fontSize: MediaQuery.sizeOf(context).width*0.04),),
                          Container(
                            constraints: BoxConstraints(
                              minHeight: MediaQuery.sizeOf(context).width * 0.2, // Độ cao tối thiểu
                            ),
                            width: MediaQuery.sizeOf(context).width*0.38,
                            height: MediaQuery.sizeOf(context).width*0.220,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(MingCute.target_line, color: Color.fromRGBO(255, 174, 9, 1.0), size: 60,),
                                SizedBox(width: 10,),
                                Text("${persentAmazing}%", style: TextStyle(fontSize: MediaQuery.sizeOf(context).height*0.030, fontFamily: "indieflower", color: Color.fromRGBO(255, 174, 9, 1.0))),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height*0.03,),
            GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    isPress = true;
                  });
                },
                onTapUp: (_) async {
                  setState(() {
                    isPress = false;
                  });
                  // Lọc danh sách với điều kiện
                  final List<word> filteredWords = widget.listWordsTest.where((word wordCheck) {
                    final int wrongCount = widget.listWordsWrong.where((wordWrongCheck) => wordWrongCheck == wordCheck).length;
                    return wrongCount < 2; // Chỉ giữ lại những từ sai ít hơn 2 lần
                  }).toList();

                  // Chuẩn bị dữ liệu cập nhật
                  final List<Map<String, dynamic>> dataUpdate = filteredWords.map((word wordUP) {
                    return {
                      "dataUpdate": {"level": wordUP.level < 28 ? wordUP.level + 1 : wordUP.level},
                      "word": wordUP.vocabulary,
                    };
                  }).toList();

                  // Cập nhật cơ sở dữ liệu
                  final DatabaseHelper db = DatabaseHelper.instance;
                  for (final data in dataUpdate) {
                    await db.updateDatabase(
                      "words",
                      data["dataUpdate"],
                      "word = '${data["word"]}' and topic = '${widget.topic}'",
                    );
                  }

                  flusExp(1);

                  widget.reload();

                  // Đóng các màn hình
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                onTapCancel: () {
                  setState(() {
                    isPress = false;
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  curve: Curves.easeInOut,
                  transform: Matrix4.translationValues(0, isPress ? 4 : 0, 0),
                  width: MediaQuery.sizeOf(context).width - 40,
                  height: MediaQuery.sizeOf(context).width * 0.15,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(97, 213, 88, 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: isPress ? [] : [
                        const BoxShadow(
                            color: Colors.green,
                            offset: Offset(6, 6)
                        )
                      ]
                  ),
                  child: Center(
                    child: Text("CONTINUE", style: TextStyle(color: Colors.white, fontSize: MediaQuery.sizeOf(context).width*0.05, fontWeight: FontWeight.bold),),
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}