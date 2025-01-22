import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';

class wordWidget extends StatefulWidget{

  final String word, wayread;
  final int level;

  const wordWidget({super.key, required this.word, required this.level, required this.wayread});

  @override
  State<StatefulWidget> createState() => _wordWidget();

}

class _wordWidget extends State<wordWidget>{

  final FlutterTts _flutterTts = FlutterTts();
  bool isButtonDisabled = false;

  Future<void> readText(String text, double speed) async {
    await _flutterTts.setLanguage("ja-JP");
    await _flutterTts.setSpeechRate(speed);
    await _flutterTts.speak(text);
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
            child: Text(
              'Inscrease volume please',
              style: TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    overlay?.insert(overlayEntry);

    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
      isButtonDisabled = !isButtonDisabled;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0),
      child: GestureDetector(
        onTap: () async {
          if(!isButtonDisabled){
            final volume = await FlutterVolumeController.getVolume();

            if(volume != 0){
              readText(widget.wayread, 0.5);
            }else{
              isButtonDisabled = !isButtonDisabled;
              showOverlay(context);
            }
          }


        },
        child: Container(
          child: Stack(
            children: [
              Container(
                  width: 120,
                  height: 100,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey
                      ),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(10))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(widget.word, style: TextStyle(fontFamily: "aoboshione", fontSize: 20,), textAlign: TextAlign.center,),
                      )
                    ],
                  )
              ),
              Container(
                width: 120,
                height: 100,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    width: 200,
                    height: 10,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        border: Border.all(
                            color: Colors.grey
                        )
                    ),
                    child: LinearProgressIndicator(
                      value: widget.level/28, // 50% progress
                      backgroundColor: Colors.white,
                      color: widget.level==28?Color.fromRGBO(255, 196, 0, 1.0):Color.fromRGBO(0, 255, 171, 1.0),
                      minHeight: 10.0,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }

}