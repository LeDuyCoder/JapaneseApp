import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/Widget/learnWidget/sortText.dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class findBeach extends StatefulWidget{

  int coin = 0;
  double health = 100;
  List<int> listFinished = [];

  final int numberGift;
  final void Function(int exp) plusExp;
  final Map<int, Map<String, dynamic>> dataMiniGame;
  final void Function() reloadScreen;

  findBeach({super.key, required this.dataMiniGame, required this.numberGift, required this.plusExp, required this.reloadScreen});

  @override
  State<StatefulWidget> createState() => _findBeach();
}

class _findBeach extends State<findBeach>{
  String imageGift = "assets/chest.png";
  String image = "assets/chest.png";
  final AudioPlayer _audioPlayer = AudioPlayer();

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
    await prefs.setInt("findbeachTime", DateTime.now().millisecondsSinceEpoch);
    print((await prefs.get("findbeachTime")));
    widget.reloadScreen();
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
              'Bạn Được +30 Điểm Kiến Thức',
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

  @override
  Widget build(BuildContext context) {
    print(widget.numberGift);
    return WillPopScope(
        child: Scaffold(
          body: Container(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.sizeOf(context).height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/backgroundbeach.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("${widget.coin}/1", style: TextStyle(fontFamily: "Itim", fontSize: 30, color: Colors.white),),
                          Image.asset("assets/gold.png", width: MediaQuery.sizeOf(context).width*0.18,)
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemCount: 16,
                            itemBuilder: (context, index) {
                              return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: widget.listFinished.contains(index) ? Center() : GestureDetector(
                                    onTap: () async {
                                      Map<String, dynamic>? data = widget.dataMiniGame[index];
                                      String typeGift = data!["feture"];
                                      if(typeGift == "gift"){
                                        setState(() {
                                          imageGift = "assets/gold.png";
                                          widget.coin = 1;
                                          playSound("sound/coin.mp3");
                                          showOverlayWin(context);
                                        });
                                        await setTimeFinished();
                                        await Future.delayed(const Duration(seconds: 2));
                                        widget.plusExp(30);
                                        Navigator.pop(context);
                                      }else if(typeGift == "sort"){
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
                                                                if(!isRight){
                                                                  playSound("sound/damage.mp3");
                                                                  widget.health -= 20;
                                                                  if(widget.health <= 0){
                                                                    playSound("sound/fail.mp3");
                                                                    Navigator.pop(context);
                                                                    showOverlay(context);
                                                                  }
                                                                }
                                                                widget.listFinished.add(index);
                                                                Navigator.pop(context);
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
                                    child: Center(
                                      child: Image.asset(
                                        widget.numberGift == index ? imageGift : image,
                                        width: MediaQuery.sizeOf(context).width * 0.18,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                              );
                            },
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width*0.5,
                        child: LinearProgressIndicator(
                          value: widget.health / 100, // 50% progress
                          backgroundColor: Colors.white,
                          color: Colors.green,
                          minHeight: 10.0,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                      Image.asset("assets/character/character7.png", width: MediaQuery.sizeOf(context).width * 0.55)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        onWillPop: () async {
          // Trả về false để chặn nút back
          return false;
        },
    );
  }
}