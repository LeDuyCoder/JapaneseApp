import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:japaneseapp/Screen/learnCharactersScreen.dart';
import 'package:japaneseapp/Widget/choseColumeWidget.dart';
import 'package:japaneseapp/Widget/learnWidget/listenTest.dart';
import 'package:japaneseapp/Widget/learnWidget/rightTab.dart';
import 'package:japaneseapp/Widget/learnWidget/wrongTab.dart';
import 'package:uuid/uuid.dart';

import '../ResultPopup.dart';

class combinationTest extends StatefulWidget {
  final List<NodeColum> listColumA;
  final List<NodeColum> listColumB;
  final void Function() nextQuestion;

  const combinationTest(
      {super.key,
      required this.listColumA,
      required this.listColumB,
      required this.nextQuestion});
  @override
  State<StatefulWidget> createState() => _combinationTest();
}

class _combinationTest extends State<combinationTest> {
  List<NodeColum> listColumA_State = [];
  List<NodeColum> listColumB_State = [];
  NodeColum? columeA_Chose;
  NodeColum? columeB_Chose;
  NodeColum? choseWrongA, choseWrongB;
  List<String> listComplete = [];
  bool isPress = false;

  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterTts _flutterTts = FlutterTts();

  // Hàm chạy file MP3 từ đường dẫn
  Future<void> playSound(String filePath) async {
    try {
      await _audioPlayer.play(AssetSource(filePath));
      print("Đang phát âm thanh: $filePath");
    } catch (e) {
      print("Lỗi khi phát âm thanh: $e");
    }
  }

  Future<void> readText(String text, double speed) async {
    await _flutterTts.setLanguage("ja-JP");
    await _flutterTts.setSpeechRate(speed);
    await _flutterTts.speak(text);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    listColumA_State =
        List.from(widget.listColumA); // Tạo bản sao có thể thay đổi
    listColumB_State = List.from(widget.listColumB);

    listColumA_State.shuffle();
    listColumB_State.shuffle();

    print(listColumB_State);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.white,
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height -
              AppBar().preferredSize.height -
              30,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Text(
                        "Match Colume A To Colume B",
                        style: TextStyle(
                            fontSize: MediaQuery.sizeOf(context).width * 0.05,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                for (int i = 0; i < 4; i++)
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        choseColumeWidget(
                            text: listColumA_State[i].word,
                            isChoose: columeA_Chose == listColumA_State[i],
                            isCancle: listComplete.contains(listColumA_State[i].uuid),
                            functionButton: () {
                              readText(listColumA_State[i].wayread, 0.5);
                              setState(() {
                                if (columeB_Chose != null) {
                                  columeB_Chose = null;
                                }

                                if (columeA_Chose != null &&
                                    columeA_Chose == listColumA_State[i]) {
                                  columeA_Chose = null;
                                } else {
                                  columeA_Chose = listColumA_State[i];
                                }
                              });
                            },
                            isWrong: choseWrongA != null &&
                                columeA_Chose!.awnser == choseWrongA &&
                                listColumA_State[i] == columeA_Chose),
                        choseColumeWidget(
                          text: listColumB_State[i].awnser,
                          isChoose: columeB_Chose == listColumB_State[i],
                          isCancle: listComplete.contains(listColumB_State[i].uuid),
                          functionButton: () {
                            setState(() {
                              if (choseWrongB == listColumB_State[i]) {
                                columeB_Chose = null;
                              } else {
                                columeB_Chose = listColumB_State[i];
                              }
                            });
                            if (columeA_Chose != null) {
                              if (columeA_Chose!.uuid == columeB_Chose!.uuid) {
                                setState(() {
                                  listComplete.add(columeB_Chose!.uuid);
                                  columeB_Chose = null;
                                  columeA_Chose = null;
                                });
                              } else {
                                choseWrongA = columeA_Chose;
                                choseWrongB = columeB_Chose;

                                playSound("sound/wrong.mp3");
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) => ResultPopup(
                                    isCorrect: false,
                                    correctWord: columeA_Chose?.wordObject?.vocabulary??"",
                                    furigana: columeA_Chose?.wordObject?.wayread??"",
                                    meaning: columeA_Chose?.wordObject?.mean??"",
                                    onPressButton: () {
                                      print("demo");
                                      setState(() {
                                        columeB_Chose = null;
                                        columeA_Chose = null;
                                        choseWrongA = null;
                                        choseWrongB = null;
                                      });
                                    }, tryAgain: true,
                                  ),
                                );
                                // showModalBottomSheet(
                                //     enableDrag: false,
                                //     isDismissible: false,
                                //     context: context,
                                //     builder: (context) => wrongTab(
                                //         nextQuestion: () {
                                //           setState(() {
                                //             columeB_Chose = null;
                                //             columeA_Chose = null;
                                //             choseWrongA = null;
                                //             choseWrongB = null;
                                //           });
                                //         },
                                //         rightAwnser: columeA_Chose!.awnser));
                              }
                            }
                          },
                          isWrong: choseWrongB != null &&
                              choseWrongB == listColumB_State[i],
                        )
                      ],
                    ),
                  ),
                SizedBox(
                  height: 50,
                ),
                GestureDetector(
                  onTapDown: (_) {
                    setState(() {
                      isPress = true;
                    });
                  },
                  onTapUp: (_) {
                    setState(() {
                      isPress = false;
                    });
                    if (listComplete.length == 4) {
                      if (listComplete.length >= 4) {
                        playSound("sound/correct.mp3");
                        showModalBottomSheet(
                            enableDrag: false,
                            isDismissible: false,
                            context: context,
                            builder: (ctx) => rightTab(
                                  nextQuestion: () {
                                    widget.nextQuestion();
                                  },
                                  isMean: false,
                                  context: context,
                                ));
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
                    width: MediaQuery.sizeOf(context).width - 40,
                    height: MediaQuery.sizeOf(context).width * 0.15,
                    decoration: BoxDecoration(
                        color: listComplete.length == 4
                            ? const Color.fromRGBO(97, 213, 88, 1.0)
                            : Color.fromRGBO(195, 195, 195, 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: isPress
                            ? [] // Khi nhấn, không có boxShadow
                            : [
                                BoxShadow(
                                    color: listComplete.length == 4
                                        ? Colors.green
                                        : const Color.fromRGBO(
                                            177, 177, 177, 1.0),
                                    offset: Offset(6, 6))
                              ]),
                    child: Center(
                      child: Text(
                        "CHECK",
                        style: TextStyle(
                            color: listComplete.length == 4
                                ? Colors.white
                                : Colors.grey,
                            fontSize: MediaQuery.sizeOf(context).width * 0.045,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
