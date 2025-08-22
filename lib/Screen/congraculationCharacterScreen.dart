import 'dart:convert';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:japaneseapp/Config/dataHelper.dart';
import 'package:japaneseapp/Module/character.dart' as charHiKa;
import 'package:shared_preferences/shared_preferences.dart';

import '../Config/FunctionService.dart';

class congraculationChacterScreen extends StatefulWidget{
  final List<String> listWordsTest, listWordsWrong;
  final int timeTest;
  final String topic;
  final dynamic dataJson;

  final void Function() reload;

  const congraculationChacterScreen({super.key, required this.listWordsTest, required this.listWordsWrong, required this.timeTest, required this.topic, required this.reload, required this.dataJson});

  @override
  State<StatefulWidget> createState() => _congraculationChacterScreen();
}

class _congraculationChacterScreen extends State<congraculationChacterScreen>{

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPress = false;
  List<String> motivationalQuotes = [
    "Chẳng có gì ngăn cản bạn.",
    "Bạn mạnh mẽ vượt qua mọi thử thách.",
    "Không điều gì làm bạn nao núng.",
    "Mỗi bước đi đều là chiến thắng.",
    "Hãy tự tin với chính mình.",
    "Đam mê dẫn lối thành công.",
    "Niềm tin mở ra cánh cửa tương lai.",
    "Tiến lên, đừng chùn bước.",
    "Bền bỉ tạo nên thành công.",
    "Nỗ lực không bao giờ phản bội bạn."
  ];
  String motivationQuotes = "";
  late InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    motivationQuotes = motivationalQuotes[Random().nextInt(motivationalQuotes.length)];
    _loadInterstitialAd();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712', // <-- ID test
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;

          _interstitialAd.setImmersiveMode(true);
        },
        onAdFailedToLoad: (error) {
          print('InterstitialAd failed to load: $error');
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  charHiKa.character? findCharacter(dynamic dataCharacter, String type, String targetSearch) {
    try {
      int index = (type == "hiragana") ? 0 : 1;
      List<dynamic> sectionList = dataCharacter[index];
      for (var section in sectionList) {
        if (section is Map && section.containsKey(targetSearch)) {
          var data = section[targetSearch];
          return charHiKa.character(
            data["level"],
            text: data["text"] ?? "",
            romaji: data["romaji"] ?? "",
            image: data["image"] ?? "",
            example: data["example"] ?? "",
          );
        }
      }
      return null;
    } catch (e) {
      print("Error finding character: $e");
      return null;
    }
  }



  // Hàm chạy file MP3 từ đường dẫn
  Future<void> playSound(String filePath) async {
    try {
      await _audioPlayer.play(AssetSource(filePath));
      await FunctionService.setDay();
    } catch (e) {
      print(e);
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



  Future<void> IncreaseLevelUser() async {
    SharedPreferences perf = await SharedPreferences.getInstance();
    Map<String, dynamic> data = jsonDecode(perf.getString(widget.topic)!);
    int levelSet = data["levelSet"];
    int level = (data["level"] as int) + 1;
    if(level == 7){
      level = 0;
      levelSet++;
    }

    Map<String, dynamic> dataNew = {
      "levelSet": levelSet,
      "level": level,
    };
    perf.setString(widget.topic, jsonEncode(dataNew));
  }

  Future<void> handleData() async {
    DatabaseHelper db = DatabaseHelper.instance;
    var batch = await db.getBatch(); // Chờ batch được khởi tạo


    for (String char in widget.listWordsTest) {
      print(char);
      if(await db.isCharacterExist(char)){
        batch.rawUpdate(
            'UPDATE characterjp SET level = level + 1 WHERE charName = ? AND typeword = ?',
            [char, widget.topic]
        );
      }else{
        charHiKa.character charJP = findCharacter(widget.dataJson, widget.topic, char)!;
        await db.increaseCharacterLevel(char, 1, charJP.level!, widget.topic);
      }
    }

    await batch.commit(noResult: true);
    await IncreaseLevelUser();// Thực hiện batch
  }


  void _popTwoScreens(BuildContext context) {
    Navigator.pop(context); // pop màn hiện tại
    Navigator.pop(context); // pop màn trước đó
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
            Image.asset("assets/character/character9.png", scale: 1.8,),
            SizedBox(height: MediaQuery.sizeOf(context).height*0.02,),
            Text("Hoàn Thành", style: TextStyle(fontFamily: "indieflower", fontSize: MediaQuery.sizeOf(context).height*0.04, color: Color.fromRGBO(20, 195, 142, 1.0)),),
            Text(motivationQuotes, style: TextStyle(fontFamily: "indieflower", fontSize: MediaQuery.sizeOf(context).height*0.02, color: Colors.black),),
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
                  await handleData();
                  flusExp(5);
                  // Đóng các màn hình
                  if (_isInterstitialAdReady) {
                    _interstitialAd.show();

                    _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
                      onAdDismissedFullScreenContent: (ad) {
                        ad.dispose();
                        _loadInterstitialAd();
                        _popTwoScreens(context);
                      },
                      onAdFailedToShowFullScreenContent: (ad, error) {
                        ad.dispose();
                        _popTwoScreens(context);
                        widget.reload();
                      },
                    );
                  } else {
                    _popTwoScreens(context);
                    widget.reload();
                  }


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