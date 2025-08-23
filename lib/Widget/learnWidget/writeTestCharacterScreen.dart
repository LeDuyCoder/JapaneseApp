import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:japaneseapp/Widget/learnWidget/rightTab.dart';
import 'package:japaneseapp/Widget/learnWidget/wrongTab.dart';
import 'package:url_launcher/url_launcher.dart';

class WriteTestCharacterScreen extends StatefulWidget {
  final String testData;
  final String ImageAsset;
  final void Function(bool isRight) nextLearned;

  const WriteTestCharacterScreen({super.key, required this.testData, required this.nextLearned, required this.ImageAsset});
  @override

  State<StatefulWidget> createState() => _WriteTestCharacterScreenState();
}

class _WriteTestCharacterScreenState extends State<WriteTestCharacterScreen> {
  bool isPress = false;
  TextEditingController dataInput = TextEditingController();
  static const platform = MethodChannel('keyboard_check');
  static const MethodChannel _channel = MethodChannel('keyboard_check');
  FocusNode textFieldFocusNode = FocusNode();
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

// Kiểm tra xem Gboard có được cài chưa
  Future<bool> isGboardInstalled() async {
    try {
      final bool? isInstalled = await _channel.invokeMethod('isGboardInstalled');
      return isInstalled ?? false;
    } on PlatformException {
      return false;
    }
  }

// Mở menu chuyển đổi bàn phím
  Future<void> showInputMethodPicker() async {
    try {
      await _channel.invokeMethod('showInputMethodPicker');
    } on PlatformException {
      print("Không thể mở menu chuyển đổi bàn phím");
    }
  }

// Hàm chính: Nếu có Gboard thì mở menu bàn phím
  Future<void> checkAndShowKeyboardPicker() async {
    bool hasGboard = await isGboardInstalled();
    if (hasGboard) {
      showInputMethodPicker();
    }else{
      await launchUrl(Uri.parse("https://play.google.com/store/apps/details?id=com.google.android.inputmethod.latin"));
    }
  }

  static Future<bool> isUsingGboard() async {
    try {
      final bool result = await platform.invokeMethod('isUsingGboard');
      return result;
    } on PlatformException catch (e) {
      print("Lỗi khi kiểm tra bàn phím: ${e.message}");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Container(
          //   width: MediaQuery.of(context).size.width,
          //   child: Center(
          //     child: AutoSizeText(
          //       widget.testData,
          //       style: TextStyle(fontSize: getResponsiveSize(context, widget.testData)),
          //     ),
          //   ),
          // ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Image.asset(widget.ImageAsset, scale: 1.2,)
            ),
          ),
          
          SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.width * 0.10,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                focusNode: textFieldFocusNode,
                onTap: onTapInput,
                controller: dataInput,
                decoration: const InputDecoration(
                  icon: Icon(Icons.draw),
                  border: InputBorder.none,
                  hintText: "Viết",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          SizedBox(height: 50),
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

              if (dataInput.text == widget.testData) {
                await playSound("sound/correct.mp3");
                showModalBottomSheet(
                    context: context,
                    barrierColor: Color.fromRGBO(0, 0, 0, 0.1),
                    isDismissible: false,
                    enableDrag: false,
                    builder: (ctx) =>
                        rightTab(nextQuestion: () {
                          widget.nextLearned(true);
                        }, isMean: false,));
              } else {
                await playSound("sound/wrong.mp3");
                showModalBottomSheet(
                    context: context,
                    barrierColor: Color.fromRGBO(0, 0, 0, 0.1),
                    isDismissible: false,
                    enableDrag: false,
                    builder: (ctx) =>
                        wrongTab(nextQuestion: () {
                          widget.nextLearned(false);
                        }, rightAwnser: widget.testData,));
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
              width: MediaQuery.of(context).size.width - 20,
              height: MediaQuery.of(context).size.width * 0.15,
              decoration: BoxDecoration(
                color: Color.fromRGBO(97, 213, 88, 1.0),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: isPress
                    ? []
                    : [BoxShadow(color: Colors.green, offset: Offset(6, 6))],
              ),
              child: const Center(
                child: Text(
                  "CHECK",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          Text("Khuyến nghị sử dụng Gboard để có trải nghiệm tốt nhất", style: TextStyle(color: Colors.red, fontSize: 15)),
        ],
      ),
    );
  }

  void onTapInput() async {
    if(await isUsingGboard()){
      textFieldFocusNode.requestFocus();
    }else{
      checkAndShowKeyboardPicker();
      // await launchUrl(Uri.parse("https://play.google.com/store/apps/details?id=com.google.android.inputmethod.latin"));
      // print("Use Not Gboard");
    }
  }

  double getResponsiveSize(BuildContext context, String text) {
    double baseSize = MediaQuery.of(context).size.width * 0.2;
    double scaleFactor = 1 / (1 + text.length * 0.05);
    return baseSize * scaleFactor;
  }
}