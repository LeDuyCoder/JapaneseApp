import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Service/Server/ServiceLocator.dart';

import '../Service/FunctionService.dart';
import '../Theme/colors.dart';

class rewardRankScreen extends StatefulWidget{
  final int rank;

  const rewardRankScreen({super.key, required this.rank});

  @override
  State<StatefulWidget> createState() => _rewardRankScreen();
}

class _rewardRankScreen extends State<rewardRankScreen>{

  final AudioPlayer _audioPlayer = AudioPlayer();

  Map<String, Color> mapColor = {
    "1": Colors.amber,
    "2": Colors.grey,
    "3": Color(0xFFcd7f32)
  };

  Map<String, int> mapCoin = {
    "1": 500,
    "2": 300,
    "3": 100
  };

  Future<void> playSound(String filePath) async {
    try {
      await _audioPlayer.play(AssetSource(filePath));
      FunctionService fs = FunctionService();
      await fs.setDay(context);
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
    playSound("sound/congraculation.mp3");
    return WillPopScope(
        child: Scaffold(
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: 220,
                    decoration: BoxDecoration(
                        color: AppColors.primary
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Chúc Mừng", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),),
                        Text("Bạn đã đạt thành tích xuất sắc", style: TextStyle(color: Colors.white, fontSize: 20),)
                      ],
                    )
                ),

                SizedBox(height: 50,),
                Text("#${widget.rank}", style: TextStyle(color: mapColor["${widget.rank}"], fontSize: 45, fontWeight: FontWeight.bold,),),
                Text("TOP PLAYER", style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold,),),
                SizedBox(height: 20,),
                Text("Phần Thường Của Bạn", style: TextStyle(color: Colors.black, fontSize: 25,),),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("+${mapCoin["${widget.rank}"]}", style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),),
                    SizedBox(width: 10,),
                    Container(
                      height: 40,
                      width: 40,
                      child: Image.asset("assets/kujicoin.png"),
                    )
                  ],
                ),
                SizedBox(height: 60,),
                GestureDetector(
                  onTap: (){
                    ServiceLocator.userService.addCoin(FirebaseAuth.instance.currentUser!.uid, mapCoin["${widget.rank}"]!);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: MediaQuery.sizeOf(context).width / 1.1,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: const Center(
                      child: Text("Nhận Quà", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                    ),
                  ),
                ),
              ],
            ),
            Image.asset("assets/animation/6k2.gif")
          ],
        ),
      ),
    ),
        onWillPop: (){
          return Future.value(false);
        }
    );
  }
}