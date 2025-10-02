import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/Theme/colors.dart';


class readTest extends StatefulWidget{
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
  // late SpeechToText _speech;

  @override
  void initState() {
    super.initState();
    _controller =
    AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(); // quay vòng
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleListening() {
    setState(() {
      if (isListening) {
        // stop
        isListening = false;
        _stopwatch.stop();
        _timer?.cancel();
        setState(() {
          _timeDisplay = "00:00";
        });
      } else {
        // start
        isListening = true;
        _stopwatch.reset();
        _stopwatch.start();
        _timer = Timer.periodic(const Duration(seconds: 1), (_) {
          if(_stopwatch.elapsed.inSeconds >= 5){
            hanldAfterRecord();
            _toggleListening();
          }
          setState(() {
            _timeDisplay = _formatTime(_stopwatch.elapsed);
          });
        });
      }
    });
  }

  void hanldAfterRecord(){
    setState(() {
      _timeDisplay = "00:00";
    });
    print("Xử lí thành công");
  }

  // void _listen() async {
  //   if (!isListening) {
  //     bool available = await _speech.initialize(
  //       onStatus: (val) => print("Status: $val"),
  //       onError: (val) => print("Error: $val"),
  //     );
  //     if (available) {
  //       setState(() => isListening = true);
  //       _speech.listen(
  //         onResult: (val) => setState(() {
  //           print(val.recognizedWords);
  //           if (val.hasConfidenceRating && val.confidence > 0) {
  //             _confidence = val.confidence;
  //           }
  //         }),
  //         localeId: "ja-JP", // hoặc "ja-JP" nếu bạn muốn nhận diện tiếng Nhật
  //       );
  //     }
  //   } else {
  //     setState(() => isListening = false);
  //     _speech.stop();
  //   }
  // }


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
                  Text("りょこう", style: TextStyle(fontSize: 25),),
                  AutoSizeText("旅行", style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),),
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
                      onTap: _toggleListening,
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