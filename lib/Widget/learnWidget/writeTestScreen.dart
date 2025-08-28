import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:japaneseapp/Widget/learnWidget/rightTab.dart';
import 'package:japaneseapp/Widget/learnWidget/wrongTab.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../../generated/app_localizations.dart';
import '../CustomKeyboard.dart';

class WriteTestScreen extends StatefulWidget {
  final String testData;
  final String? mean;
  final void Function(bool isRight) nextLearned;

  const WriteTestScreen({super.key, required this.testData, required this.nextLearned, this.mean});
  @override

  State<StatefulWidget> createState() => _WriteTestScreenState();
}

class _WriteTestScreenState extends State<WriteTestScreen> {
  bool isPress = false;
  TextEditingController dataInput = TextEditingController();
  static const platform = MethodChannel('keyboard_check');
  static const MethodChannel _channel = MethodChannel('keyboard_check');
  FocusNode textFieldFocusNode = FocusNode();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FocusNode _focusNode = FocusNode();

  List<dynamic> listWord = [];

  Offset keyboardOffset = const Offset(0, 1);

  // Hàm chạy file MP3 từ đường dẫn
  Future<void> playSound(String filePath) async {
    try {
      await _audioPlayer.play(AssetSource(filePath));
      print("Đang phát âm thanh: $filePath");
    } catch (e) {
      print("Lỗi khi phát âm thanh: $e");
    }
  }

  @override
  void initState() {
    super.initState();

    // sau khi build xong + delay 500ms
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          keyboardOffset = const Offset(0, 0); // update xuống dưới
        });
      });
    });
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

  void insertText(String newText) {
    final selection = dataInput.selection;
    if (!selection.isValid) {
      dataInput.text += newText;
      dataInput.selection = TextSelection.collapsed(offset: dataInput.text.length);
      return;
    }

    final oldText = dataInput.text;
    final before = oldText.substring(0, selection.start);
    final after  = oldText.substring(selection.end);

    final updatedText = before + newText + after;
    dataInput.text = updatedText;
    final newOffset = selection.start + newText.length;
    dataInput.selection = TextSelection.collapsed(offset: newOffset);
  }

  void deleteText() {
    final selection = dataInput.selection;
    if (!selection.isValid) return;

    final oldText = dataInput.text;
    if (selection.start != selection.end) {
      final before = oldText.substring(0, selection.start);
      final after  = oldText.substring(selection.end);
      final updatedText = before + after;

      dataInput.text = updatedText;
      dataInput.selection = TextSelection.collapsed(offset: before.length);
      return;
    }
    if (selection.start > 0) {
      final before = oldText.substring(0, selection.start - 1);
      final after  = oldText.substring(selection.end);
      final updatedText = before + after;

      dataInput.text = updatedText;
      dataInput.selection = TextSelection.collapsed(offset: before.length);
    }
  }

  Future<void> sendHandwriting(List<List<Offset>> strokes) async {
    // Chuyển Offset -> ink
    List<List<List<num>>> ink = strokes.map((stroke) {
      List<num> xs = stroke.map((p) => p.dx.round()).toList();
      List<num> ys = stroke.map((p) => p.dy.round()).toList();
      return [xs, ys];
    }).toList();

    final url = Uri.parse(
        "https://inputtools.google.com/request?itc=ja-t-i0-handwrit&app=translate");

    final body = {
      "input_type": 0,
      "requests": [
        {
          "writing_guide": {
            "writing_area_width": 400,
            "writing_area_height": 400
          },
          "ink": ink,
          "language": "ja"
        }
      ]
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print(response.body);
      final data = jsonDecode(response.body);
      setState(() {
        listWord = data[1][0][1];
      });
      print("Kết quả: ${data[1][0][1]}");
    } else {
      print("Lỗi: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: AutoSizeText(
                      widget.testData,
                      style: TextStyle(fontSize: getResponsiveSize(context, widget.testData)),
                    ),
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
                      readOnly: true,
                      controller: dataInput,
                      decoration: InputDecoration(
                        icon: Icon(Icons.draw),
                        border: InputBorder.none,
                        hintText: AppLocalizations.of(context)!.learn_write_input,
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
                              }, isMean: true, mean: widget.mean, context: context,));
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
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.learn_btn_check,
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
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AnimatedSlide(
                    offset: keyboardOffset,
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeOut,
                    child: CustomKeyboard(
                      onStrokeComplete: (points) async {
                        await sendHandwriting(points);
                      },
                      insertText: insertText, listWord: listWord, backSpace: deleteText,
                    ),
                  )
                ],
              )
            ),
          )
        ],
      )
    );
  }


  double getResponsiveSize(BuildContext context, String text) {
    double baseSize = MediaQuery.of(context).size.width * 0.2;
    double scaleFactor = 1 / (1 + text.length * 0.05);
    return baseSize * scaleFactor;
  }
}