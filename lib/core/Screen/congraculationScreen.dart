import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:japaneseapp/core/Config/rank_manager.dart';
import 'package:japaneseapp/core/Module/word.dart';
import 'package:japaneseapp/core/Screen/dashboardScreen.dart';
import 'package:japaneseapp/core/Screen/upRankScreen.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/core/Utilities/WeekUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Service/FunctionService.dart';
import '../Config/config.dart';
import '../Service/Local/local_db_service.dart';
import '../Service/Server/ServiceLocator.dart';

class congraculationScreen extends StatefulWidget{
  final List<word> listWordsTest, listWordsWrong;
  final int timeTest;
  final String topic;

  final void Function() reload;

  congraculationScreen({super.key, required this.listWordsTest, required this.listWordsWrong, required this.timeTest, required this.topic, required this.reload});

  @override
  State<StatefulWidget> createState() => _congraculationScreen();
}

class _congraculationScreen extends State<congraculationScreen> with TickerProviderStateMixin{

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPress = false;
  late InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady = false;
  bool _didRandomize = false;

  int expRank = 0;
  int coin = 0;

  late AnimationController _controllerProcess;
  late Animation<double> _animationProcess;

  Map<String, dynamic> rankMap = RankManager.rankMap;


  void startProgressAnimation(double endValue) {
    _animationProcess = Tween<double>(begin: 0.0, end: endValue).animate(
      CurvedAnimation(parent: _controllerProcess, curve: Curves.easeInOut),
    );

    _controllerProcess.forward(from: 0); // bắt đầu lại từ 0 mỗi lần gọi
  }



  String getRankFromScore(int score) {
    for (var rank in rankMap.entries) {
      if (score >= rank.value['min'] && score <= rank.value['max']) {
        return rank.key;
      }
    }
    return "Bronze"; // fallback
  }

  Future<void> randomizeValues() async {
    final rand = Random();

    final userId = FirebaseAuth.instance.currentUser!.uid;

    final currentScoreData = await ServiceLocator.scoreService
        .getScore(WeekUtils.getCurrentWeekString(), userId);
    final currentScore = currentScoreData["score"] ?? 0;

    // Xác định rank hiện tại
    final oldRankKey = getRankFromScore(currentScore);
    final oldRankData = rankMap[oldRankKey]!;

    final totalQuestions = 10;
    final wrongAnswers = widget.listWordsTest.length;
    final correctAnswers = totalQuestions - wrongAnswers;

    int expRank = 0;
    for (int i = 0; i < correctAnswers; i++) {
      expRank += 10 + rand.nextInt(6);
    }

    if (wrongAnswers > totalQuestions / 2) {
      expRank = (expRank * 0.8).round();
    }

    double accuracy = correctAnswers / totalQuestions;
    int coin = (accuracy * 10).clamp(1, 10).round();

    // Cập nhật dữ liệu
    await ServiceLocator.userService.addCoin(userId, coin);
    await ServiceLocator.scoreService.addScore(userId, expRank);

    // Lấy lại tổng điểm sau khi cộng
    final newTotalScoreData = await ServiceLocator.scoreService
        .getScore(WeekUtils.getCurrentWeekString(), userId);
    final newScore = newTotalScoreData["score"] ?? 0;

    // Xác định rank mới
    final newRankKey = getRankFromScore(newScore);
    final newRankData = rankMap[newRankKey]!;

    // Nếu rank mới khác rank cũ thì hiển thị màn hình UpRankScreen
    if (newRankKey != oldRankKey) {
      Future.delayed(Duration(milliseconds: 300), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => UpRankScreen(
              imgRankOld: oldRankData['image'],
              imgRankNow: newRankData['image'],
              nameRank: newRankData['name'],
              oldRankColor: oldRankData['color'],
              newRankColor: newRankData['color'],
            ),
          ),
        );
      });
    }

    setState(() {
      this.expRank = expRank;
      this.coin = coin;
    });
  }



  @override
  void initState() {
    super.initState();
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

  // Hàm chạy file MP3 từ đường dẫn
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

    return Scaffold(
      body: FutureBuilder(future: getProfile(), builder: (ctx, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          if (!_didRandomize) {
            randomizeValues();
            startProgressAnimation(snapshot.data!["exp"] / snapshot.data!["nextExp"]);
            _didRandomize = true;
          }
        }

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
                            // 1️⃣ Hiển thị popup hỏi người dùng
                            bool watchAd = await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white, // nền sáng
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20), // bo tròn
                                  ),
                                  title: Row(
                                    children: const [
                                      Text("🎉 X2 Kujicoin?"),
                                    ],
                                  ),
                                  content: const Text(
                                    "Bạn có muốn xem quảng cáo để x2 số Kujicoin nhận được không? 💰",
                                    style: TextStyle(fontSize: 16, height: 1.4),
                                  ),
                                  actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  actions: [
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey.shade300,
                                        foregroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                      ),
                                      onPressed: () {
                                        if (_isInterstitialAdReady && dashboardScreen.countAdMod >= 2) {
                                          dashboardScreen.countAdMod = 0;
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
                                          dashboardScreen.countAdMod++;
                                          Navigator.pop(context);
                                        }// không xem quảng cáo
                                      },
                                      icon: const Icon(Icons.close),
                                      label: const Text("Hủy"),
                                    ),
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.amber.shade700,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context, true); // đồng ý xem quảng cáo
                                      },
                                      icon: const Icon(Icons.play_circle_fill),
                                      label: const Text("Xem Quảng Cáo"),
                                    ),
                                  ],
                                );
                              },
                            ) ?? false;

                            // 2️⃣ Nếu đồng ý xem quảng cáo
                            if (watchAd) {
                              if (_isInterstitialAdReady) {
                                _interstitialAd.show();
                                _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
                                  onAdDismissedFullScreenContent: (ad) {
                                    ad.dispose();
                                    _loadInterstitialAd(); // tải lại cho lần sau

                                    // Nhân đôi tiền hoặc exp sau khi xem xong quảng cáo
                                    setState(() {
                                      coin *= 2;
                                      expRank *= 2;
                                    });
                                  },
                                  onAdFailedToShowFullScreenContent: (ad, error) {
                                    ad.dispose();
                                  },
                                );
                              } else {
                                // Quảng cáo chưa sẵn sàng → thông báo
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Quảng cáo chưa sẵn sàng!")),
                                );
                              }
                            }

                            // 3️⃣ Tiếp tục logic bình thường
                            final List<word> filteredWords = widget.listWordsTest.where((word wordCheck) {
                              final int wrongCount = widget.listWordsWrong.where((wordWrongCheck) => wordWrongCheck == wordCheck).length;
                              return wrongCount < 2;
                            }).toList();

                            final List<Map<String, dynamic>> dataUpdate = filteredWords.map((word wordUP) {
                              return {
                                "dataUpdate": {"level": wordUP.level < 28 ? wordUP.level + 1 : wordUP.level},
                                "word": wordUP.vocabulary,
                              };
                            }).toList();

                            final db = LocalDbService.instance;
                            for (final data in dataUpdate) {
                              await db.vocabularyDao.update(
                                "words",
                                data["dataUpdate"],
                                "word = '${data["word"]}' and topic = '${widget.topic}'",
                              );
                            }

                            // Điều hướng tiếp theo
                            Navigator.pop(context);
                            widget.reload();
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
                        )

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