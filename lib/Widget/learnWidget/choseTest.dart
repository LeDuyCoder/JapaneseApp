import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:japaneseapp/Widget/choseWordWidget.dart';
import 'package:japaneseapp/Widget/learnWidget/rightTab.dart';
import 'package:japaneseapp/Widget/learnWidget/wrongTab.dart';

class choseTest extends StatefulWidget {
  final Map<String, dynamic> data;
  final void Function() nextQuestion;
  final bool readText;

  const choseTest({super.key, required this.data, required this.nextQuestion, required this.readText});

  @override
  State<StatefulWidget> createState() => _choseTestState();
}

class _choseTestState extends State<choseTest> {
  late Map<int, String> positionAnswer; // Biến lưu trữ vị trí đáp án cố định
  int positionChose = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterTts _flutterTts = FlutterTts();
  bool isPress = false;

  @override
  void initState() {
    super.initState();
    positionAnswer = _generateQuestion();
  }

  Future<void> readText(String text, double speed) async {
    await _flutterTts.setLanguage("ja-JP");
    await _flutterTts.setSpeechRate(speed);
    await _flutterTts.speak(text);
  }

  Future<void> playSound(String filePath) async {
    try {
      await _audioPlayer.play(AssetSource(filePath));
      print("Đang phát âm thanh: $filePath");
    } catch (e) {
      print("Lỗi khi phát âm thanh: $e");
    }
  }

  Map<int, String> _generateQuestion() {
    // Tạo danh sách mới từ widget.data["listAnwserWrong"] và kiểm tra độ dài
    List<String> listAnswerWrong = List.of(widget.data["listAnwserWrong"]);
    if (listAnswerWrong.length < 3) {
      throw Exception("listAnwserWrong must have at least 3 elements");
    }
    listAnswerWrong.shuffle();

    // Đảm bảo numberRight nằm trong khoảng từ 1 đến 4
    int numberRight = widget.data["numberRight"];
    if (numberRight < 1 || numberRight > 4) {
      throw Exception("numberRight must be between 1 and 4");
    }

    // Khởi tạo positionAnswer với đáp án đúng
    Map<int, String> positionAnswer = {numberRight: widget.data["anwser"]};

    // Thêm các đáp án sai vào vị trí còn lại
    int wrongIndex = 0; // Chỉ số cho listAnswerWrong
    for (int i = 1; i <= 4; i++) {
      if (!positionAnswer.containsKey(i)) {
        positionAnswer[i] = listAnswerWrong[wrongIndex];
        wrongIndex++;
      }
    }

    return positionAnswer;
  }

  void choseItem(int position, String text){

    if(widget.readText == true){
      readText(text, 1.0);
    }

    setState(() {
      if(position == positionChose){
        positionChose = 0;
      }else{
        positionChose = position;
      }
    });

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width*0.9,
                      child: AutoSizeText(
                        "Nghĩa của từ ${widget.data["word"]}",
                        style: TextStyle(fontSize: MediaQuery.sizeOf(context).height*0.03, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              // Image.asset(
              //   "assets/character/character4.png",
              //   width: MediaQuery.sizeOf(context).width * 0.4,
              // ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    choseWordWidget(textShow: positionAnswer[1] ?? "", isChose: positionChose == 1, choseItem: () { choseItem(1, positionAnswer[1]!); },),
                    choseWordWidget(textShow: positionAnswer[2] ?? "", isChose:  positionChose == 2, choseItem: () { choseItem(2, positionAnswer[2]!); },),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    choseWordWidget(textShow: positionAnswer[3] ?? "", isChose:  positionChose == 3, choseItem: () { choseItem(3, positionAnswer[3]!); },),
                    choseWordWidget(textShow: positionAnswer[4] ?? "", isChose:  positionChose == 4, choseItem: () { choseItem(4, positionAnswer[4]!); },),
                  ],
                ),
              ),

              SizedBox(height: MediaQuery.sizeOf(context).height*0.05,),

              AnimatedContainer(
                duration: const Duration(milliseconds: 1000), // Thời gian chuyển đổi
                curve: Curves.easeInOutSine, // Hiệu ứng mượt mà
                width: MediaQuery.sizeOf(context).width - 40,
                height: MediaQuery.sizeOf(context).width*0.15,
                child: GestureDetector(
                  onTapDown: (_) {
                    setState(() {
                      isPress = true;
                    });
                  },
                  onTapUp: (_) {
                    setState(() {
                      isPress = false;
                    });
                    if (positionChose != 0) {
                      if (positionChose == widget.data["numberRight"]) {
                        playSound("sound/correct.mp3");
                        showModalBottomSheet(enableDrag: false,
                            isDismissible: false,
                            context: context,
                            builder: (ctx) =>
                                rightTab(nextQuestion: () {
                                  widget.nextQuestion();
                                }, isMean: false,));
                      } else {
                        playSound("sound/wrong.mp3");
                        showModalBottomSheet(enableDrag: false,
                            isDismissible: false,
                            context: context,
                            builder: (ctx) =>
                                wrongTab(nextQuestion: () {
                                  widget.nextQuestion();
                                }, rightAwnser: widget.data["anwser"]));
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
                        height: MediaQuery.sizeOf(context).width*0.15,
                        decoration: BoxDecoration(
                            color: positionChose == 0 ? const Color.fromRGBO(
                                209, 209, 209, 1.0) : const Color.fromRGBO(97, 213, 88, 1.0),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            boxShadow: isPress ? [] : [
                              BoxShadow(
                                  color: positionChose == 0 ? const Color.fromRGBO(
                                      204, 204, 204, 1.0) : Colors.green,
                                  offset: Offset(6, 6)
                              )
                            ]
                        ),
                        child: Center(
                          child: Text("CHECK", style: TextStyle(color: positionChose == 0 ? Colors.grey: Colors.white, fontSize: MediaQuery.sizeOf(context).height*0.025, fontWeight: FontWeight.bold),),
                        ),
                    ),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
