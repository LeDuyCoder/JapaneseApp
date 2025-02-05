import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:japaneseapp/Module/word.dart';
import 'package:japaneseapp/Widget/learnWidget/sortText.dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class dragonCave extends StatefulWidget{

  final List<word> listWords;
  final void Function() plusExp;
  final void Function() reloadScreen;

  @override
  State<StatefulWidget> createState() => _dragonCave();
  Widget? item;

  dragonCave({super.key, required this.listWords, required this.plusExp, required this.reloadScreen});
}

class _dragonCave extends State<dragonCave>{

  int healthDragon = 200;
  int health = 100;
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<double> positionKnight = [];
  List<double> positionDragon = [50, 0];

  // Hàm chạy file MP3 từ đường dẫn
  Future<void> playSound(String filePath) async {
    try {
      await _audioPlayer.play(AssetSource(filePath));
      print("Đang phát âm thanh: $filePath");
    } catch (e) {
      print("Lỗi khi phát âm thanh: $e");
    }
  }

  Future<void> setTimeFinished() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("dragonCaveTime", DateTime.now().millisecondsSinceEpoch);
    print((await prefs.get("dragonCaveTime")));
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
              'Bạn Đã Thất Bại',
              style: TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(Duration(seconds: 3), () async {
      await setTimeFinished();
      overlayEntry.remove();
    });
  }
  void showOverlayWin(BuildContext context) {
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
              'Bạn Được +80 Điểm Kiến Thức',
              style: TextStyle(color: Colors.green, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(Duration(seconds: 3), () async {
      await setTimeFinished();
      overlayEntry.remove();
    });
  }


  Widget itemRandom(String type) {
    return ClipOval(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.red,
          boxShadow: [
            BoxShadow(
              color: Colors.redAccent,
              blurRadius: 5,
              offset: Offset(-4, 4)
            )
          ]
        ),
        width: 50,
        height: 50,
        child: Padding(
          padding: EdgeInsets.all(10), // Tạo khoảng cách giúp ảnh nhỏ lại
          child: Image.asset(
            type == "attack"? "assets/sword.png":"assets/quest.png",
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  void Attack() async {
    await playSound("sound/hit.mp3");
    await playSound("sound/dragonDamage.mp3");
    setState(() {
      positionKnight[0] = positionKnight[0]-50;
      positionKnight[1] = positionKnight[1]+50;
      healthDragon -= 20;
    });

    await Future.delayed(Duration(milliseconds: 500));

    setState(() {
      positionKnight[0] = positionKnight[0]+50;
      positionKnight[1] = positionKnight[1]-50;
    });

    if(healthDragon <= 0){
      showOverlayWin(context);
      await setTimeFinished();
      widget.plusExp();
      Navigator.pop(context);
      widget.reloadScreen();
    }
  }

  void Damaged() async {
    playSound("sound/dragonDamage.mp3");

    setState(() {
      positionDragon[0] = positionDragon[0]+50;
      positionDragon[1] = positionDragon[1]+50;
      health -= 20;
    });

    await Future.delayed(Duration(milliseconds: 500));

    setState(() {
      positionDragon[0] = positionDragon[0]-50;
      positionDragon[1] = positionDragon[1]-50;
    });

    if(health <= 0){
      showOverlay(context);
      await setTimeFinished();
      Navigator.pop(context);
      widget.reloadScreen();
    }
  }

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

  @override
  Widget build(BuildContext context) {
    if(positionKnight.isEmpty){
      positionKnight = [MediaQuery.sizeOf(context).height*0.2, 0];
    }
    return Scaffold(
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/dragonCave.png"),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height*0.2,
              child: Column(
                children: [
                  SizedBox(height: 50,),
                  Stack(
                    children: [
                      Center(
                        child: Container(
                          width: MediaQuery.sizeOf(context).width*0.9,
                          height: MediaQuery.sizeOf(context).width*0.05,
                          child: LinearProgressIndicator(
                            value: healthDragon / 200, // 50% progress
                            backgroundColor: Colors.white,
                            color: Colors.red,
                            minHeight: 10.0,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                      ),
                      Center(
                        child: Text("${healthDragon}/200", style: TextStyle(color: healthDragon<=40?Colors.black:Colors.white, fontFamily: "Itim", fontSize: 15),),
                      )
                    ],
                  )
                ],
              )
            ),
            Container(
              height: MediaQuery.sizeOf(context).height*0.4,
              width: MediaQuery.sizeOf(context).width,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 500), // Thời gian animation
                      curve: Curves.easeInOut, // Hiệu ứng chuyển động mượt mà
                      top: positionDragon[0],
                      left: positionDragon[1], // Đặt ảnh bên phải
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(math.pi), // Lật ảnh theo trục Y
                        child: Image.asset(
                          'assets/character/dragon.png',
                          width: MediaQuery.sizeOf(context).width * 0.4,
                        ),
                      ),
                    ),

                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 500), // Thời gian animation
                      curve: Curves.easeInOut, // Hiệu ứng chuyển động mượt mà
                      top: positionKnight[0],
                      right: positionKnight[1], // Đặt ảnh bên phải
                      child: Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.2,
                            child: LinearProgressIndicator(
                              value: health/100, // 50% progress
                              backgroundColor: Colors.white,
                              color: Colors.green,
                              minHeight: 10.0,
                              borderRadius: const BorderRadius.all(Radius.circular(20)),
                            ),
                          ),
                          Image.asset(
                            'assets/character/character8.png', // Thay bằng link ảnh của bạn
                            width: MediaQuery.sizeOf(context).width * 0.3,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ),
            Container(
              height: 50,
              child: widget.item != null ? widget.item! : Center(),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  int numberRandom = Random().nextInt(10);
                  print(numberRandom);
                  if (numberRandom == 6 || numberRandom == 3) {
                    setState(() {
                      widget.item = itemRandom("attack");
                    });
                    await Future.delayed(Duration(seconds: 1)); // Chờ 10 giây
                    Attack();
                    setState(() {
                      widget.item = null;
                    });
                  }else{
                    setState(() {
                      widget.item = itemRandom("quest");
                    });

                    word WordTest = widget.listWords[Random().nextInt(widget.listWords.length)];

                    typeSort ranType = Random().nextInt(2) == 0
                        ? typeSort.VietNamToJapan
                        : typeSort.JapanToVietNam;

                    Map<String, dynamic> data = {
                      "feture": "sort",
                      "type": "translatte",
                      "typeTranslate": ranType,
                      "listChose": ranType == typeSort.JapanToVietNam
                          ? hanldStringChoseVN("${WordTest.mean} ${generateWrongAwnser("JapToVN", WordTest.mean, widget.listWords)}")
                          : handleJapaneseString("${WordTest.vocabulary} ${generateWrongAwnser("VNToJap", WordTest.mean, widget.listWords)}"),
                      "word": WordTest
                    };

                    Navigator.push(context, MaterialPageRoute(builder: (ctx)=>
                        Scaffold(
                            body: Container(
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    sortText(
                                        WordTest: data["word"],
                                        nextLearned: (isRight){
                                          setState(() {
                                            if(isRight){
                                              // playSound("sound/damage.mp3");
                                              // widget.health -= 20;
                                              // if(widget.health <= 0){
                                              //   playSound("sound/fail.mp3");
                                              //   Navigator.pop(context);
                                              //   showOverlay(context);
                                              // }
                                              Attack();
                                            }else{
                                              Damaged();
                                            }
                                            Navigator.pop(context);
                                            setState(() {
                                              widget.item = null;
                                            });
                                          });
                                        },
                                        wordChose: data["listChose"],
                                        typeTest: data["typeTranslate"],
                                        isRetest: false
                                    ),
                                  ],
                                )
                            )
                        )
                    ));

                  }
                },
                child: Stack(
                  alignment: Alignment.center, // Căn giữa tất cả ảnh trong Stack
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/moutain.png",
                        width: MediaQuery.sizeOf(context).width * 0.62,
                        color: Colors.white,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/moutain.png",
                        width: MediaQuery.sizeOf(context).width * 0.6,
                      ),
                    ),
                  ],
                ),
              )
            )
          ],
        ),
      ),
    );
  }

}