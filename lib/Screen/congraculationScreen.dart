import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:japaneseapp/Config/dataHelper.dart';
import 'package:japaneseapp/Module/word.dart';

class congraculationScreen extends StatelessWidget{
  final List<word> listWordsTest, listWordsWrong;
  final int timeTest;
  final String topic;

  final void Function() reload;

  congraculationScreen({super.key, required this.listWordsTest, required this.listWordsWrong, required this.timeTest, required this.topic, required this.reload});


  final AudioPlayer _audioPlayer = AudioPlayer();

  // Hàm chạy file MP3 từ đường dẫn
  Future<void> playSound(String filePath) async {
    try {
      await _audioPlayer.play(AssetSource(filePath));
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

  @override
  Widget build(BuildContext context) {

    int persentAmazing = 100 - (listWordsWrong.length * 2);

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
            SizedBox(height: 20,),
            Text("Perfect Lesson", style: TextStyle(fontFamily: "indieflower", fontSize: 40, color: Color.fromRGBO(20, 195, 142, 1.0)),),
            Text("You make no mistake in lesson", style: TextStyle(fontFamily: "indieflower", fontSize: 20, color: Colors.black),),
            Container(
              width: double.infinity,
              child:Padding(
                padding: EdgeInsets.only(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 180,
                      height: 130,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(20, 195, 142, 1.0),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Column(
                        children: [
                          Text("Commited", style: TextStyle(fontFamily: "indieflower", color: Colors.white, fontSize: 18),),
                          Container(
                            width: 170,
                            height: 100,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.timer_sharp, color: Color.fromRGBO(20, 195, 142, 1.0), size: 60,),
                                SizedBox(width: 10,),
                                Text(formatTime(timeTest*1.0), style: TextStyle(fontSize: 40, fontFamily: "indieflower", color: Color.fromRGBO(20, 195, 142, 1.0))),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 10,),
                    Container(
                      width: 180,
                      height: 130,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 174, 9, 1.0),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Column(
                        children: [
                          const Text("Amazing", style: TextStyle(fontFamily: "indieflower", color: Colors.white, fontSize: 18),),
                          Container(
                            width: 170,
                            height: 100,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(MingCute.target_line, color: Color.fromRGBO(255, 174, 9, 1.0), size: 60,),
                                SizedBox(width: 10,),
                                Text("${persentAmazing}%", style: TextStyle(fontSize: 40, fontFamily: "indieflower", color: Color.fromRGBO(255, 174, 9, 1.0))),
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
            SizedBox(height: 20,),
            GestureDetector(
                onTap: () async {
                  // Sử dụng Set để tăng hiệu quả kiểm tra
                  final Set<word> wrongWordsSet = listWordsWrong.toSet();

                  // Lọc danh sách với điều kiện
                  final List<word> filteredWords = listWordsTest.where((word wordCheck) {
                    final int wrongCount = listWordsWrong.where((wordWrongCheck) => wordWrongCheck == wordCheck).length;
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
                      "word = '${data["word"]}' and topic = '$topic'",
                    );
                  }

                  reload();

                  // Đóng các màn hình
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Container(
                width: MediaQuery.sizeOf(context).width - 40,
                height: 80,
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(97, 213, 88, 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.green,
                          offset: Offset(6, 6)
                      )
                    ]
                ),
                child: Center(
                  child: Text("CONTINUE", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}