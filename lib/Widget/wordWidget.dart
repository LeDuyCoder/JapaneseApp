import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:japaneseapp/Config/dataHelper.dart';
import 'package:japaneseapp/Module/word.dart';

class wordWidget extends StatefulWidget{

  final word wordText;
  final String topicName;
  final void Function() reloadScreenListWord;

  const wordWidget({super.key, required this.wordText, required this.topicName, required this.reloadScreenListWord});

  @override
  State<StatefulWidget> createState() => _wordWidget();

}

class _wordWidget extends State<wordWidget>{

  final FlutterTts _flutterTts = FlutterTts();
  bool isButtonDisabled = false;

  TextEditingController vocabularyEdit = TextEditingController(),
                        wayReadEdit = TextEditingController(),
                        meanEdit = TextEditingController();

  Future<void> readText(String text, double speed) async {
    await _flutterTts.setLanguage("ja-JP");
    await _flutterTts.setSpeechRate(speed);
    await _flutterTts.speak(text);
  }

  void showPopupEditWord() {

    vocabularyEdit.text = widget.wordText.vocabulary;
    wayReadEdit.text = widget.wordText.wayread;
    meanEdit.text = widget.wordText.mean;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color.fromRGBO(20, 195, 142, 1.0),
                      width: 10.0,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Edit Word',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: vocabularyEdit,
                              decoration: InputDecoration(
                                hintText: "Name",
                                hintStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 12.0, // Giảm chiều cao bên trong
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10), // Khoảng cách nhỏ giữa 2 ô
                          Expanded(
                            child: TextField(
                              controller: wayReadEdit,
                              decoration: InputDecoration(
                                hintText: "Way Read",
                                hintStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 12.0, // Giảm chiều cao bên trong
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8), // Khoảng cách nhỏ giữa dòng trên và dòng dưới
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        controller: meanEdit,
                        decoration: InputDecoration(
                          hintText: "Mean",
                          hintStyle: TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 12.0, // Giảm chiều cao bên trong
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10, right: 5),
                            child: Container(
                              width: 100,
                              height: 40, // Giảm chiều cao nút
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(255, 32, 32, 1.0),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: const Center(
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.white, fontSize: 15),
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            DatabaseHelper db = DatabaseHelper.instance;

                            String newWord = vocabularyEdit.text;
                            String newWayRead = wayReadEdit.text;
                            String newMean = meanEdit.text;

                            Map<String, dynamic> newData = {
                              "word": newWord,
                              "mean": newMean,
                              "wayread": newWayRead,
                            };

                            await db.updateDatabase("words", newData, "word = '${widget.wordText.vocabulary}' and topic = '${widget.topicName}'",);
                            widget.reloadScreenListWord();
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              width: 100,
                              height: 40, // Giảm chiều cao nút
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(184, 241, 176, 1),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: const Center(
                                child: Text(
                                  "Save",
                                  style: TextStyle(color: Colors.black, fontSize: 15),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
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

    overlay.insert(overlayEntry);

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
        onLongPress: (){
          showPopupEditWord();
        },
        onTap: () async {
          if(!isButtonDisabled){
            final volume = await FlutterVolumeController.getVolume();

            if(volume != 0){
              readText(widget.wordText.wayread, 0.5);
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
                        child: Text(widget.wordText.vocabulary, style: TextStyle(fontFamily: "aoboshione", fontSize: 20,), textAlign: TextAlign.center,),
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
                      value: widget.wordText.level/28, // 50% progress
                      backgroundColor: Colors.white,
                      color: widget.wordText.level==28?Color.fromRGBO(255, 196, 0, 1.0):Color.fromRGBO(0, 255, 171, 1.0),
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