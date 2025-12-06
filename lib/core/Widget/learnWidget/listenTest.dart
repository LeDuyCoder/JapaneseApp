import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:japaneseapp/core/Module/boxText.dart';
import 'package:japaneseapp/core/Service/GoogleTTSService.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/core/Widget/learnWidget/rightTab.dart';
import 'package:japaneseapp/core/Widget/learnWidget/sortText.dart';
import 'package:japaneseapp/core/Widget/learnWidget/wrongTab.dart';
import '../../Module/word.dart';
import '../../generated/app_localizations.dart';
import '../ResultPopup.dart';


class listenTest extends StatefulWidget {
  final word WordTest;
  final List<String> wordChose;
  final typeSort typeTest;
  final void Function(bool isRight) nextLearned;
  final bool isRetest;

  const listenTest({
    super.key,
    required this.WordTest,
    required this.nextLearned,
    required this.wordChose,
    required this.typeTest,
    required this.isRetest,
  });

  @override
  State<StatefulWidget> createState() => _ListenTextState();
}

class _ListenTextState extends State<listenTest> {
  List<boxText>? dataBoxText;
  List<boxText> dataInput = [];
  final FlutterTts _flutterTts = FlutterTts();
  bool isFirst = true;
  bool loadBoxText = true;
  bool isPress = false;

  GoogleTTSService googleTTSService = GoogleTTSService();

  final AudioPlayer _audioPlayer = AudioPlayer();

  // Hàm chạy file MP3 từ đường dẫn
  Future<void> playSound(String filePath) async {
    try {
      await _audioPlayer.play(AssetSource(filePath));
    } catch (e) {
      print("Lỗi khi phát âm thanh: $e");
    }
  }

  // Hàm dừng phát âm thanh
  Future<void> stopSound() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
    }
  }

  Future<void> readText(String text, double speed) async {
    await _flutterTts.setLanguage("ja-JP");
    await _flutterTts.setSpeechRate(speed);
    await _flutterTts.speak(text);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (loadBoxText) {
        setState(() {
          dataBoxText = widget.wordChose.map((text) => boxText(text)).toList();
          loadBoxText = false;
        });

        if(await googleTTSService.speak(widget.WordTest.wayread) == false){
          await readText(widget.WordTest.wayread, 0.5);
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    dataBoxText = [];
    dataInput = [];
  }


  @override
  Widget build(BuildContext context) {


    return Stack(
      children: [
        Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height -
              AppBar().preferredSize.height -
              30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Text(AppLocalizations.of(context)!.learn_listen_title, style: TextStyle(fontSize: MediaQuery.sizeOf(context).height*0.025, fontWeight: FontWeight.bold, fontFamily: "Itim"),),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width*0.5,
                    child: Image.asset("assets/character/hinh2.png", width: MediaQuery.sizeOf(context).height*0.2),
                  ),
                  Container(
                    width: MediaQuery.sizeOf(context).width*0.5,
                    child: Center(
                      child: GestureDetector(
                        onTapUp: (_) async {
                          if(await googleTTSService.speak(widget.WordTest.wayread) == false){
                            await readText(widget.WordTest.wayread, 0.5);
                          }
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 100),
                          curve: Curves.easeInOut,
                          transform: Matrix4.translationValues(0, 0, 0),
                          height: MediaQuery.sizeOf(context).width*0.3,
                          width: MediaQuery.sizeOf(context).width*0.3,
                          decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Icon(Icons.volume_up_rounded, color: Colors.white, size:50,),
                        ),
                      ),
                    ),
                  )

                ],
              ),
              DragTarget<boxText>(
                onWillAccept: (data) => data != null,
                onAccept: (data) {
                  setState(() {
                    dataInput.add(data);
                    dataBoxText!.remove(data);
                  });
                },
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height*0.25,
                    color: Colors.white,
                    child: Center(
                      child: Stack(
                        children: [
                          if (candidateData.isNotEmpty)
                            Container(
                              color: const Color.fromRGBO(0, 0, 0, 0.1),
                            ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Divider(color: Colors.grey),
                              SizedBox(
                                height: dataInput.isEmpty ? 60 : 10,
                              ),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: dataInput
                                    .map(
                                      (item) => GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        dataInput.remove(item);
                                        dataBoxText!.add(item);
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10),
                                      child: item.buildWidget(),
                                    ),
                                  ),
                                )
                                    .toList(),
                              ),
                              const SizedBox(height: 20),
                              const Divider(color: Colors.grey),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: MediaQuery.sizeOf(context).height*0.01),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Wrap(
                    spacing: 20,
                    runSpacing: 10,
                    children: (dataBoxText != null && dataBoxText!.isNotEmpty)
                        ? dataBoxText!
                        .map(
                          (item) => GestureDetector(
                        onTap: () {
                          if (widget.typeTest == typeSort.VietNamToJapan)
                            readText(item.text, 0.5);
                          setState(() {
                            dataBoxText!.remove(item);
                            dataInput.add(item);
                          });
                        },
                        child: Draggable<boxText>(
                          key: ValueKey(item.text),
                          data: item,
                          feedback: Center(
                            child: Material(
                              type: MaterialType.transparency,
                              child: item.buildWidget(),
                            ),
                          ),
                          childWhenDragging: item.buildWidget(),
                          child: item.buildWidget(),
                        ),
                      ),
                    )
                        .toList()
                        : [const CircularProgressIndicator()], // Hiển thị loading tạm thời
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height -
              AppBar().preferredSize.height -
              30,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    isPress = true;
                  });
                },
                onTapUp: (_) async {
                  setState(() {
                    isPress = false;
                  });
                  if(dataInput.isNotEmpty){
                    StringBuffer dataWord = StringBuffer();
                    for (boxText box in dataInput) {
                      dataWord.write(widget.typeTest == typeSort.JapanToVietNam
                          ? "${box.text} "
                          : "${box.text}");
                    }
                    bool isAwnserRight = dataWord.toString().trim() ==
                        (widget.typeTest == typeSort.JapanToVietNam
                            ? widget.WordTest.mean
                            : widget.WordTest.vocabulary);
                    if (isAwnserRight) {
                      await playSound("sound/correct.mp3");

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => ResultPopup(
                          isCorrect: true,
                          correctWord: widget.WordTest.vocabulary,
                          furigana: widget.WordTest.wayread,
                          meaning: widget.WordTest.mean,
                          onPressButton: () {
                            widget.nextLearned(isAwnserRight);
                            dataInput = [];
                            dataBoxText = [];
                            for(String text in widget.wordChose){
                              dataBoxText!.add(boxText(text));
                            }
                            loadBoxText = true;
                          }, tryAgain: false,
                        ),
                      );
                    }else{
                      await playSound("sound/wrong.mp3");

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => ResultPopup(
                          isCorrect: false,
                          correctWord: widget.WordTest.vocabulary,
                          furigana: widget.WordTest.wayread,
                          meaning: widget.WordTest.mean,
                          onPressButton: () {
                            widget.nextLearned(isAwnserRight);
                            dataInput = [];
                            dataBoxText = [];
                            for(String text in widget.wordChose){
                              dataBoxText!.add(boxText(text));
                            }
                            loadBoxText = true;
                          }, tryAgain: false,
                        ),
                      );
                    }
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
                  width: MediaQuery.sizeOf(context).width - 20,
                  height: MediaQuery.sizeOf(context).width*0.15,
                  decoration: dataInput.isEmpty
                      ? const BoxDecoration(
                    color: Color.fromRGBO(223, 223, 223, 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  )
                      : BoxDecoration(
                    color: const Color.fromRGBO(49, 230, 62, 1.0),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    boxShadow: isPress ? [] : [
                      const BoxShadow(
                        color: Colors.green,
                        offset: Offset(6, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.learn_btn_check,
                      style: TextStyle(
                        fontSize: 20,
                        color: dataInput.isEmpty
                            ? const Color.fromRGBO(166, 166, 166, 1.0)
                            : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Tạo bút vẽ
    final paint = Paint()
      ..color = Colors.grey // Màu của đường thẳng
      ..strokeWidth = 1.0 // Độ dày của đường thẳng
      ..style = PaintingStyle.stroke;

    // Vẽ đường thẳng từ điểm (0, 0) đến (size.width, size.height)
    canvas.drawLine(
      Offset(0, 0), // Điểm bắt đầu
      Offset(0, size.height), // Điểm kết thúc
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // Return true nếu cần vẽ lại
    return false;
  }
}
