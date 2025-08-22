import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:japaneseapp/Module/boxText.dart';
import 'package:japaneseapp/Widget/learnWidget/rightTab.dart';
import 'package:japaneseapp/Widget/learnWidget/wrongTab.dart';
import '../../Module/word.dart';

enum typeSort {
  JapanToVietNam,
  VietNamToJapan,
}

class sortText extends StatefulWidget {
  final word WordTest;
  final List<String> wordChose;
  final typeSort typeTest;
  final void Function(bool isRight) nextLearned;
  final bool isRetest;

  const sortText({
    super.key,
    required this.WordTest,
    required this.nextLearned,
    required this.wordChose,
    required this.typeTest,
    required this.isRetest,
  });

  @override
  State<StatefulWidget> createState() => _SortTextState();
}

class _SortTextState extends State<sortText> {
  List<boxText>? dataBoxText;
  List<boxText> dataInput = [];
  final FlutterTts _flutterTts = FlutterTts();
  bool isFirst = true;
  bool loadBoxText = true;
  bool isPress = false;

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

  Future<void> readText(String text) async {
    await _flutterTts.setLanguage("ja-JP");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.speak(text);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    dataBoxText = [];
    dataInput = [];
  }

  @override
  Widget build(BuildContext context) {
    if(loadBoxText) {
      dataBoxText = widget.wordChose.map((text) => boxText(text)).toList();
      loadBoxText = !loadBoxText;

      readText(widget.WordTest.wayread);
    }
    return Stack(
      children: [
        Container(
          color: Colors.white,
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height -
              AppBar().preferredSize.height -
              30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: widget.isRetest ? const Row(
                  children: [
                    Icon(Icons.repeat_outlined, size: 30,),
                    SizedBox(width: 10,),
                    Text("Mistake", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.orange),),
                  ],
                  ) : Row(
                  children: [
                    Icon(Icons.translate, size: MediaQuery.sizeOf(context).width*0.07,),
                    Text("Dịch Câu Bên Dưới", style: TextStyle(fontSize: MediaQuery.sizeOf(context).width*0.05, fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.sizeOf(context).width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width/3,
                      child: Image.asset("assets/character/character1.png", width: 150),
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width/2,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        width: 200,
                        height: 120,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(4, -4),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await readText(widget.WordTest.wayread);
                              },
                              child: const Icon(Icons.volume_down_sharp,
                                  color: Colors.blue),
                            ),
                            SizedBox(
                              width: 150,
                              child: Text(
                                widget.typeTest == typeSort.JapanToVietNam
                                    ? widget.WordTest.vocabulary
                                    : widget.WordTest.mean,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
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
                    height: MediaQuery.sizeOf(context).height*0.2,
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
              SizedBox(height: MediaQuery.sizeOf(context).height*0.01,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Wrap(
                    spacing: 20,
                    runSpacing: 10,
                    children: dataBoxText!
                        .map(
                          (item) => GestureDetector(
                        onTap: () {
                          if (widget.typeTest == typeSort.VietNamToJapan)
                            readText(item.text);
                          setState(() {
                            dataBoxText!.remove(item);
                            dataInput.add(item);
                          });
                        },
                        child: Draggable<boxText>(
                          key: ValueKey(item.text),
                          data: item,
                          feedback: Center(child: Material(
                            type: MaterialType.transparency,
                            child: item.buildWidget(),
                          )),
                          childWhenDragging: item.buildWidget(),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: item.buildWidget(),
                          ),
                        ),
                      ),
                    )
                        .toList(),
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

                      showModalBottomSheet(
                          context: context,
                          barrierColor: Color.fromRGBO(0, 0, 0, 0.1),
                          isDismissible: false,
                          enableDrag: false,
                          builder: (ctx) => rightTab(nextQuestion: (){
                            widget.nextLearned(isAwnserRight);
                            dataInput = [];
                            dataBoxText = [];
                            for(String text in widget.wordChose){
                              dataBoxText!.add(boxText(text));
                            }
                            loadBoxText = true;
                          }, isMean: false,));
                    }else{
                      await playSound("sound/wrong.mp3");

                      showModalBottomSheet(
                          context: context,
                          barrierColor: Color.fromRGBO(0, 0, 0, 0.1),
                          isDismissible: false,
                          enableDrag: false,
                          builder: (ctx) => wrongTab(nextQuestion: (){
                            widget.nextLearned(isAwnserRight);
                            dataInput = [];
                            dataBoxText = [];
                            for(String text in widget.wordChose){
                              dataBoxText!.add(boxText(text));
                            }
                            loadBoxText = true;
                          }, rightAwnser: (widget.typeTest == typeSort.JapanToVietNam
                              ? widget.WordTest.mean
                              : widget.WordTest.vocabulary)
                          )
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
                      :  BoxDecoration(
                    color: Color.fromRGBO(97, 213, 88, 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: isPress ? [] : [
                      const BoxShadow(
                        color: Colors.green,
                        offset: Offset(6, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "CHECK",
                      style: TextStyle(
                        fontSize: MediaQuery.sizeOf(context).height*0.025,
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
