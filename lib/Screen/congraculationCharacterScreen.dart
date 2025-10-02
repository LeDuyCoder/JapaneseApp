import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:japaneseapp/Config/dataHelper.dart';
import 'package:japaneseapp/Module/character.dart' as charHiKa;
import 'package:japaneseapp/Service/Server/ServiceLocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Service/FunctionService.dart';
import '../Config/config.dart';
import '../Theme/colors.dart';
import 'dashboardScreen.dart';

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

class _congraculationChacterScreen extends State<congraculationChacterScreen>  with TickerProviderStateMixin{

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPress = false;
  String motivationQuotes = "";
  late InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady = false;

  int expRank = 0;
  int coin = 0;

  late AnimationController _controllerProcess;
  late Animation<double> _animationProcess;

  void startProgressAnimation(double endValue) {
    _animationProcess = Tween<double>(begin: 0.0, end: endValue).animate(
      CurvedAnimation(parent: _controllerProcess, curve: Curves.easeInOut),
    );

    _controllerProcess.forward(from: 0); // bắt đầu lại từ 0 mỗi lần gọi
  }

  void randomizeValues() async {
    Random rand = Random();

    setState(() {
      coin = rand.nextInt(8); // random từ 1 đến 10
      expRank = rand.nextInt(20);

    });

    ServiceLocator.userService.addCoin(FirebaseAuth.instance.currentUser!.uid, coin);
    ServiceLocator.scoreService.addScore(FirebaseAuth.instance.currentUser!.uid, expRank);


  }

  @override
  void initState() {
    _loadInterstitialAd();

    _controllerProcess = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: Config.admodId, // <-- ID test
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
      FunctionService fs = FunctionService();
      await fs.setDay(context);
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

  int xpPerTurn(int level, int expNeed) {
    final _random = Random();
    final targetTurns = 5 + (level % 6);
    final xp = expNeed / targetTurns;
    final rounded = (xp / 5).round() * 5;
    final variation = _random.nextInt(5) - 10;
    final result = max(5, rounded + variation);
    return result;
  }

  Future<Map<String, dynamic>> getProfile() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int expAw = xpPerTurn(await prefs.getInt("level")??0, await prefs.getInt("nextExp")??0);
    flusExp(expAw);

    return {
      "expFlus": expAw,
      "level": await prefs.getInt("level")??0,
      "exp": await prefs.getInt("exp")??0,
      "nextExp": await prefs.getInt("nextExp")??0
    };
  }

  @override
  Widget build(BuildContext context) {
    String formatTime(double timeInSeconds) {
      int minutes = timeInSeconds ~/ 60; // Lấy số phút (chia lấy nguyên)
      int seconds = timeInSeconds % 60 ~/ 1; // Lấy số giây (phần dư của phép chia)

      // Định dạng chuỗi: thêm số 0 vào giây nếu cần
      String formattedTime = "$minutes phút ${seconds.toString().padLeft(2, '0')} giây";

      return formattedTime;
    }
    playSound("sound/completed.mp3");
    randomizeValues();
    return Scaffold(
      body: FutureBuilder(future: getProfile(), builder: (ctx, snapshot){
        if(snapshot.hasData){
          startProgressAnimation(snapshot.data!["exp"]/snapshot.data!["nextExp"]);
          return Container(
            color: Colors.white,
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  child: Image.asset("assets/animation/6k2.gif"),
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height,
                  color: Colors.white.withOpacity(0.15),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        SizedBox(height: 60,),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.6), // màu glow
                                spreadRadius: 1, // độ lan của ánh sáng
                                blurRadius: 15,  // độ mờ
                              ),
                            ],
                          ),
                          child: const Icon(
                            HeroIcons.trophy, // icon bên trong
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text("Chúc Mừng", style: TextStyle(color: AppColors.primary, fontSize: 40, fontFamily: "Itim"),),
                        Text("Bạn đã hoàn thành", style: TextStyle(color: AppColors.black, fontSize: 25, fontFamily: "Itim", height: 0.8),),
                        SizedBox(height: 30,),
                        Container(
                          width: MediaQuery.sizeOf(context).width / 1.1,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.grey.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Bài Học",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "itim",
                                  fontSize: 18,
                                ),
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Thời gian hoàn thành: ",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: "itim",
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    formatTime(widget.timeTest * 1.0),
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontFamily: "itim",
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.sizeOf(context).width / 1.1,
                          height: 130,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("+${snapshot.data!["expFlus"]}", style: TextStyle(color: Colors.white, fontSize: 40, fontFamily: "Itim", height: 0.8),),
                              const Text("Điểm Kinh Nghiệm", style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "Itim", height: 1.2),)
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Tiến Trình Level", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                              Text("${snapshot.data!["exp"]}/${snapshot.data!["nextExp"]}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SizedBox(
                            height: 10,
                            child: AnimatedBuilder(
                              animation: _animationProcess,
                              builder: (context, child) {
                                return LinearProgressIndicator(
                                  borderRadius: const BorderRadius.all(Radius.circular(360)),
                                  value: _animationProcess.value,
                                  backgroundColor: Colors.grey.withOpacity(0.2),
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Cấp ${snapshot.data!["level"]}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                              Text("Cấp ${snapshot.data!["level"] + 1}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.grey.withOpacity(0.5))),
                            ],
                          ),
                        ),
                        SizedBox(height: 25,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if(expRank > 0)
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text("+${expRank}", style: TextStyle(color: Colors.black, fontSize: 30, fontFamily: "Itim", height: 0.8),),
                                      SizedBox(width: 5,),
                                      Image.asset("assets/exp.png", width: 50, height: 50,),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text("Điểm Rank", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                                  )
                                ],
                              ),
                            if(expRank > 0 && coin > 0)
                              SizedBox(width: 50,),
                            if(coin > 0)
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text("+${coin}", style: TextStyle(color: Colors.black, fontSize: 30, fontFamily: "Itim", height: 0.8),),
                                      SizedBox(width: 5,),
                                      SizedBox(
                                        width: 40,
                                        height: 50,
                                        child: Transform.scale(
                                          scale: 1,  // tỷ lệ thu nhỏ ảnh bên trong
                                          child: Image.asset("assets/kujicoin.png"),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text("kujicoin", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                                  )
                                ],
                              )
                          ],
                        ),
                        SizedBox(height: 50,),
                        Text("Bài tiếp theo", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),),
                        SizedBox(height: 10,),
                        GestureDetector(
                          onTap: () async {
                            await handleData();
                            widget.reload();
                            if (_isInterstitialAdReady && dashboardScreen.countAdMod >= 2) {
                              _interstitialAd.show();
                              _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
                                onAdDismissedFullScreenContent: (ad) {
                                  ad.dispose();
                                  Navigator.pop(context);
                                  dashboardScreen.countAdMod = 0;
                                },
                                onAdFailedToShowFullScreenContent: (ad, error) {
                                  ad.dispose();
                                  Navigator.pop(context);
                                  dashboardScreen.countAdMod = 0;
                                },
                              );
                            } else {
                              Navigator.pop(context);
                            }
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
                              child: Text("Bắt Đầu Lượt Học Tiếp", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }

        return Container();
      }),
    );
  }

}