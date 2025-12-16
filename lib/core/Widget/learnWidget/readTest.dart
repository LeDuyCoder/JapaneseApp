import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:kana_kit/kana_kit.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../ResultPopup.dart';


class readTest extends StatefulWidget{

  final String word;
  final String kana;
  final String mean;
  final void Function() nextQuestion;

  const readTest({super.key, required this.word, required this.kana, required this.mean, required this.nextQuestion});

  @override
  State<StatefulWidget> createState() => _readTest();

}

class _readTest extends State<readTest> with SingleTickerProviderStateMixin{

  bool isListening = false;
  late AnimationController _controller;
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  String _timeDisplay = "00:00";
  double _confidence = 1.0;
  late SpeechToText _speech;
  String _answer = "";

  final kanaKit = KanaKit();
  final AudioPlayer _audioPlayer = AudioPlayer();


  @override
  void initState() {
    super.initState();
    _controller =
    AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(); // quay vòng
    _speech = SpeechToText();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> playSound(String filePath) async {
    try {
      await _audioPlayer.play(AssetSource(filePath));
      print("Đang phát âm thanh: $filePath");
    } catch (e) {
      print("Lỗi khi phát âm thanh: $e");
    }
  }

  Future<void> _toggleListening() async {
    if (isListening) {
      await stopListening();
    } else {
      startListening();
    }
  }

  void startListening() {
    setState(() {
      isListening = true;
      _stopwatch
        ..reset()
        ..start();
      _timeDisplay = "00:00";
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final elapsed = _stopwatch.elapsed.inSeconds;
      if (elapsed >= 5) {
        stopListening(handled: true);
      } else {
        setState(() {
          _timeDisplay = _formatTime(_stopwatch.elapsed);
        });
      }
    });

    _listen();
  }

  Future<void> stopListening({bool handled = true}) async {
    _timer?.cancel();
    _stopwatch.stop();

    setState(() {
      isListening = false;
      _timeDisplay = "00:00";
    });

    _speech.stop();

    if (handled) {
      await hanldAnwser();
    }
  }

  void _listen() async {
    bool available = await _speech.initialize(
      onStatus: (val) => print("Status: $val"),
      onError: (val) => print("Error: $val"),
    );

    if (available) {
      _speech.listen(
        onResult: (val) {
          _answer = val.recognizedWords;
          print(val.recognizedWords);
          setState(() {
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          });
        },
        localeId: "ja-JP",
      );
    } else {
      stopListening();
    }
  }

  String toRomaji(String text) {
    return kanaKit.toRomaji(text).trim().toLowerCase();
  }

  Future<void> hanldAnwser() async {
    String userAnswer = toRomaji(_answer);
    String correctKana = toRomaji(widget.kana);
    String correctWord = toRomaji(widget.word);

    bool isCorrect = userAnswer == correctKana || userAnswer == correctWord;

    if (isCorrect) {
      await playSound("sound/correct.mp3");
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => ResultPopup(
          isCorrect: true,
          correctWord: widget.word,
          furigana: widget.kana,
          meaning: widget.mean,
          onPressButton: () {
            widget.nextQuestion();
          }, tryAgain: false,
        ),
      );
    } else {
      await playSound("sound/wrong.mp3");
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => ResultPopup(
          isCorrect: false,
          correctWord: widget.word,
          furigana: widget.kana,
          meaning: widget.mean,
          onPressButton: () {
            
          }, tryAgain: false,
        ),
      );
    }
  }

  String _formatTime(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {

    final double size = MediaQuery.sizeOf(context).width * 0.3;

    return Scaffold(
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        color: AppColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text("Bạn hãy đọc từ bên dưới", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              width: MediaQuery.sizeOf(context).width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.kana, style: TextStyle(fontSize: 25),),
                  AutoSizeText(widget.word, style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),),
                  SizedBox(
                    height: 200,
                  ),

                  if(isListening)
                    Text(
                      _timeDisplay,
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  SizedBox(height: 10,),
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        await _toggleListening();
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // vòng tròn quay khi isListening = true
                          if (isListening)
                            ...[
                              Container(
                                width: size+10,
                                height: size+10,
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                  strokeWidth: 4,
                                ),
                              ),
                            ],


                          // nút chính
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, anim) =>
                                ScaleTransition(scale: anim, child: child),
                            child: Container(
                              key: ValueKey(isListening),
                              height: size,
                              width: size,
                              decoration: isListening
                                  ? const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              )
                                  : BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                isListening ? Icons.pause : Icons.mic_rounded,
                                color: Colors.white,
                                size: 50,
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
          ],
        ),
      ),
    );
  }
}