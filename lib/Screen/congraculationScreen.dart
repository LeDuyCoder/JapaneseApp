import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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

class _congraculationScreen extends State<congraculationScreen> with TickerProviderStateMixin{

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPress = false;
  late InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady = false;

  late AnimationController _controller;
  late Animation<double> _animation;
  late AnimationController _controllerProcess;
  late Animation<double> _animationProcess;

  void startProgressAnimation(double endValue) {
    _animationProcess = Tween<double>(begin: 0.0, end: endValue).animate(
      CurvedAnimation(parent: _controllerProcess, curve: Curves.easeInOut),
    );

    _controllerProcess.forward(from: 0); // bắt đầu lại từ 0 mỗi lần gọi
  }


  @override
  void initState() {
    _loadInterstitialAd();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Thời gian zoom in/out
    )..repeat(reverse: true); // Lặp lại và đảo ngược

    _controllerProcess = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0.8, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    startProgressAnimation(0.5);
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

    exp += await prefs.getInt("level")??1 * expplus;

    while(exp >= nextExp){
      level++;
      exp -= nextExp;
      nextExp = 10*(level*level)+50*level+100;
    }

    await prefs.setInt("level", level);
    await prefs.setInt("exp", exp);
    await prefs.setInt("nextExp", nextExp);
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
      body:  Container(
        color: Color(0xFF43B648),
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
              child: Column(
                children: [
                  SizedBox(height: 80,),
                  ScaleTransition(
                    scale: _animation,
                    child: Image.asset(
                      "assets/trophy.png",
                      scale: 0.7,
                    ),
                  ),
                  const Text("Chúc Mừng", style: TextStyle(color: Colors.white, fontSize: 45, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                  SizedBox(height: 10,),
                  const Text("Bạn Đã Hoàn Thành", style: TextStyle(color: Color(0xFFFFD700), fontSize: 35), textAlign: TextAlign.center,),
                  SizedBox(height: 20,),
                  Container(
                    width: MediaQuery.sizeOf(context).width - 40,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white.withOpacity(0.15)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.menu_book_outlined, color: Colors.white, size: 25,),
                              SizedBox(width: 10,),
                              Text("Bài Học", style: TextStyle(color: Colors.white, fontSize: 20),)
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Thời gian hoàn thành bài 3 phút 14 giây", style: TextStyle(color: Colors.white, fontSize: 15),)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star, color: Color(0xFFFFD700), size: 30,),
                        Text("+ 150 Điểm Kinh Nghiệm", style: TextStyle(color:  Color(0xFFFFD700), fontSize: 18),)
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    width: MediaQuery.sizeOf(context).width - 40,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white.withOpacity(0.15)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width / 1.25,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Tiến Trình Level", style: TextStyle(color: Colors.white, fontSize: 20),),
                              SizedBox(width: 10,),
                              Text("50/100", style: TextStyle(color: Colors.white, fontSize: 20),)
                            ],
                          ),
                        ),
                        SizedBox(height: 5,),
                        Container(
                          width: MediaQuery.sizeOf(context).width / 1.25,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return const LinearGradient(
                                  colors: [Color(0xFFFFD700), Color(0xFFFF7B00)],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ).createShader(bounds);
                              },
                              child: AnimatedBuilder(
                                animation: _controllerProcess,
                                builder: (context, child) {
                                  return LinearProgressIndicator(
                                    value: _animationProcess.value,
                                    backgroundColor: Colors.transparent,
                                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Column(
                    children: [
                      SizedBox(height: 20,),
                      Text("25", style: TextStyle(color: Color(0xFFFFD700), fontSize: 50, fontWeight: FontWeight.bold, height: 1),),
                      Text("Cấp Bậc", style: TextStyle(color: Colors.white),)
                    ],
                  ),

                  SizedBox(height: 50,),
                  Container(
                    width: MediaQuery.sizeOf(context).width/2,
                    height: 60,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          offset: Offset(1, 1),
                          blurRadius: 2,
                          spreadRadius: 2,
                        )
                      ],
                      color:  Color(0xFFFFD700),
                      borderRadius: BorderRadius.all(Radius.circular(15))
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Tiếp Tục", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 20),),
                      ],
                    )
                    
                  )
                ],

              ),
            )
          ],
        ),
      ),
    );

    // return Scaffold(
    //   body: Container(
    //     width: MediaQuery.sizeOf(context).width,
    //     height: MediaQuery.sizeOf(context).height,
    //     color: Colors.white,
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Image.asset("assets/character/character2.png", scale: 0.8,),
    //         SizedBox(height: MediaQuery.sizeOf(context).height*0.02,),
    //         Text("Hoàn Thành", style: TextStyle(fontSize: MediaQuery.sizeOf(context).height*0.04, color: Color.fromRGBO(20, 195, 142, 1.0)),),
    //         Text("Bạn Thật Tuyệt Vời", style: TextStyle(fontSize: MediaQuery.sizeOf(context).height*0.02, color: Colors.black),),
    //         SizedBox(height: MediaQuery.sizeOf(context).height*0.02,),
    //         Container(
    //           width: double.infinity,
    //           child:Padding(
    //             padding: EdgeInsets.only(),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 Container(
    //                   width: MediaQuery.sizeOf(context).width*0.4,
    //                   height: MediaQuery.sizeOf(context).width*0.30,
    //                   decoration: BoxDecoration(
    //                       color: Color.fromRGBO(20, 195, 142, 1.0),
    //                       borderRadius: BorderRadius.circular(20)
    //                   ),
    //                   child: Column(
    //                     children: [
    //                       Text("Commited", style: TextStyle(color: Colors.white, fontSize: MediaQuery.sizeOf(context).width*0.04),),
    //                       Container(
    //                         constraints: BoxConstraints(
    //                           minHeight: MediaQuery.sizeOf(context).width * 0.2, // Độ cao tối thiểu
    //                         ),
    //                         width: MediaQuery.sizeOf(context).width*0.38,
    //                         height: MediaQuery.sizeOf(context).width*0.22,
    //                         decoration: BoxDecoration(
    //                             color: Colors.white,
    //                             borderRadius: BorderRadius.circular(20)
    //                         ),
    //                         child: Row(
    //                           mainAxisAlignment: MainAxisAlignment.center,
    //                           children: [
    //                             Icon(Icons.timer_sharp, color: Color.fromRGBO(20, 195, 142, 1.0), size: 60,),
    //                             SizedBox(width: 10,),
    //                             Text(formatTime(widget.timeTest*1.0), style: TextStyle(fontSize: MediaQuery.sizeOf(context).height*0.030, color: Color.fromRGBO(20, 195, 142, 1.0))),
    //                           ],
    //                         ),
    //                       )
    //                     ],
    //                   ),
    //                 ),
    //                 SizedBox(width: 10,),
    //                 Container(
    //                   width: MediaQuery.sizeOf(context).width*0.4,
    //                   height: MediaQuery.sizeOf(context).width*0.30,
    //                   decoration: BoxDecoration(
    //                       color: Color.fromRGBO(255, 174, 9, 1.0),
    //                       borderRadius: BorderRadius.circular(20)
    //                   ),
    //                   child: Column(
    //                     children: [
    //                       Text("Amazing", style: TextStyle(color: Colors.white, fontSize: MediaQuery.sizeOf(context).width*0.04),),
    //                       Container(
    //                         constraints: BoxConstraints(
    //                           minHeight: MediaQuery.sizeOf(context).width * 0.2, // Độ cao tối thiểu
    //                         ),
    //                         width: MediaQuery.sizeOf(context).width*0.38,
    //                         height: MediaQuery.sizeOf(context).width*0.220,
    //                         decoration: BoxDecoration(
    //                             color: Colors.white,
    //                             borderRadius: BorderRadius.circular(20)
    //                         ),
    //                         child: Row(
    //                           mainAxisAlignment: MainAxisAlignment.center,
    //                           children: [
    //                             const Icon(MingCute.target_line, color: Color.fromRGBO(255, 174, 9, 1.0), size: 60,),
    //                             SizedBox(width: 10,),
    //                             Text("${persentAmazing}%", style: TextStyle(fontSize: MediaQuery.sizeOf(context).height*0.030, color: Color.fromRGBO(255, 174, 9, 1.0))),
    //                           ],
    //                         ),
    //                       )
    //                     ],
    //                   ),
    //                 )
    //               ],
    //             ),
    //           ),
    //         ),
    //         SizedBox(height: MediaQuery.sizeOf(context).height*0.03,),
    //         GestureDetector(
    //             onTapDown: (_) {
    //               setState(() {
    //                 isPress = true;
    //               });
    //             },
    //             onTapUp: (_) async {
    //               setState(() {
    //                 isPress = false;
    //               });
    //               // Lọc danh sách với điều kiện
    //               final List<word> filteredWords = widget.listWordsTest.where((word wordCheck) {
    //                 final int wrongCount = widget.listWordsWrong.where((wordWrongCheck) => wordWrongCheck == wordCheck).length;
    //                 return wrongCount < 2; // Chỉ giữ lại những từ sai ít hơn 2 lần
    //               }).toList();
    //
    //               // Chuẩn bị dữ liệu cập nhật
    //               final List<Map<String, dynamic>> dataUpdate = filteredWords.map((word wordUP) {
    //                 return {
    //                   "dataUpdate": {"level": wordUP.level < 28 ? wordUP.level + 1 : wordUP.level},
    //                   "word": wordUP.vocabulary,
    //                 };
    //               }).toList();
    //
    //               // Cập nhật cơ sở dữ liệu
    //               final DatabaseHelper db = DatabaseHelper.instance;
    //               for (final data in dataUpdate) {
    //                 await db.updateDatabase(
    //                   "words",
    //                   data["dataUpdate"],
    //                   "word = '${data["word"]}' and topic = '${widget.topic}'",
    //                 );
    //               }
    //
    //               flusExp(5);
    //
    //               widget.reload();
    //               if (_isInterstitialAdReady) {
    //                 _interstitialAd.show();
    //
    //                 // Sau khi hiển thị, xử lý chuyển tiếp màn hình ở callback:
    //                 _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
    //                   onAdDismissedFullScreenContent: (ad) {
    //                     ad.dispose();
    //                     _loadInterstitialAd(); // tải lại cho lần sau
    //
    //                     // 👉 Chuyển tiếp màn sau khi quảng cáo đóng
    //                     _popTwoScreens(context);
    //                   },
    //                   onAdFailedToShowFullScreenContent: (ad, error) {
    //                     ad.dispose();
    //                     // Đóng các màn hình
    //                     _popTwoScreens(context);
    //                   },
    //                 );
    //               } else {
    //                 // Đóng các màn hình
    //                 _popTwoScreens(context);
    //               }
    //
    //             },
    //             onTapCancel: () {
    //               setState(() {
    //                 isPress = false;
    //               });
    //             },
    //             child: AnimatedContainer(
    //               duration: Duration(milliseconds: 100),
    //               curve: Curves.easeInOut,
    //               transform: Matrix4.translationValues(0, isPress ? 4 : 0, 0),
    //               width: MediaQuery.sizeOf(context).width - 40,
    //               height: MediaQuery.sizeOf(context).width * 0.15,
    //               decoration: BoxDecoration(
    //                   color: const Color.fromRGBO(97, 213, 88, 1.0),
    //                   borderRadius: BorderRadius.all(Radius.circular(20)),
    //                   boxShadow: isPress ? [] : [
    //                     const BoxShadow(
    //                         color: Colors.green,
    //                         offset: Offset(6, 6)
    //                     )
    //                   ]
    //               ),
    //               child: Center(
    //                 child: Text("CONTINUE", style: TextStyle(color: Colors.white, fontSize: MediaQuery.sizeOf(context).width*0.05, fontWeight: FontWeight.bold),),
    //               ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

}