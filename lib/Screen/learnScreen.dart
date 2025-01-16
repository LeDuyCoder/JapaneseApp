import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:japaneseapp/Module/word.dart';
import 'package:japaneseapp/Screen/congraculationScreen.dart';
import 'package:japaneseapp/Widget/learnWidget/combinationTest.dart';
import 'package:japaneseapp/Widget/learnWidget/listenTest.dart';
import 'package:japaneseapp/Widget/learnWidget/sortText.dart.dart';

import '../Config/timeService.dart';

class learnScreen extends StatefulWidget {
  final List<word> dataWords;
  final String topic;
  final void Function() reload;
  const learnScreen({super.key, required this.dataWords, required this.topic, required this.reload});

  @override
  State<StatefulWidget> createState() => _learnScreen();
}

class _learnScreen extends State<learnScreen> {
  int numberCount = 0;
  List<Map<String, dynamic>> dataMap = [];
  List<word> wrongWords = [];
  List<word> listWordsTest = [];
  Widget? view;

  late TimerService _timerService;
  int _currentSeconds = 0;

  int maxQuestion = 5;
  int amountRightAwnser = 0;

  @override
  void initState() {
    super.initState();

    _timerService = TimerService(onUpdate: (seconds) {
      _currentSeconds = seconds;
    });

    _timerService.startTimer();

  }
  
  int randomInRange(int min, int max) {
    var random = Random();
    return min + random.nextInt(max - min);
  }

  List<String> hanldStringChoseVN(String mean) {
    List<String> newListString = mean.split(" ");
    newListString.shuffle();
    return newListString;
  }

  List<String> handleJapaneseString(String input) {
    List<String> characters = input.split('');
    characters.shuffle(Random());
    return characters;
  }

  void updateView(String feature) {
    setState(() {
      view = feature == "sort"
          ? sortText(
        WordTest: dataMap[numberCount]["word"],
        wordChose: dataMap[numberCount]["listChose"],
        typeTest: dataMap[numberCount]["typeTranslate"],
        isRetest: amountRightAwnser >= maxQuestion && amountRightAwnser <= (dataMap.length + wrongWords.length),
        nextLearned: (isRight) {
          handleNext(isRight);
        },
      ) : feature == "listen"
          ? listenTest(
        WordTest: dataMap[numberCount]["word"],
        wordChose: dataMap[numberCount]["listChose"],
        typeTest: dataMap[numberCount]["typeTranslate"],
        isRetest: amountRightAwnser >= maxQuestion && amountRightAwnser <= (dataMap.length + wrongWords.length),
        nextLearned: (isRight) {
          handleNext(isRight);
        }
      ) : combinationTest(
          listColumA: dataMap[numberCount]["listColumA"],
          listColumB: dataMap[numberCount]["listColumB"],
          nextQuestion: () {
            handleNext(true);
          }
      );
    });
  }

  void handleNext(bool isRight) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (!isRight) {
          wrongWords.add(dataMap[numberCount]["word"] as word);
        }

        numberCount++;
        if (numberCount < dataMap.length) {
          updateView(dataMap[numberCount]["feture"]);
        } else {
          view = const Text("Finished");
        }
      });
    });
  }

  void generateQuestion(List<word> dataWords) {
    if (dataMap.isEmpty) {
      int i = 0;
      while(i < maxQuestion){
        List<String> feture = ["sort", "listen", "combination"];
        String fetureChose = "";
        // if(dataMap.isNotEmpty){
        //   while (dataMap.last["feture"] == fetureChose){
        //     print("text");
        //     fetureChose = feture[randomInRange(0, feture.length)];
        //     if(fetureChose == "sort" || fetureChose == "listen") {
        //       break;
        //     }
        //   }
        // }else {
        //   fetureChose = feture[randomInRange(0, feture.length)];
        // }

        fetureChose = feture[randomInRange(0, feture.length)];
        if(fetureChose == "sort" || fetureChose == "listen") {
          typeSort ranType = randomInRange(0, 2) == 0
              ? typeSort.VietNamToJapan
              : typeSort.JapanToVietNam;
          word wordRandom = dataWords[randomInRange(
              0, widget.dataWords.length)];
          if(dataMap.isEmpty  || dataMap.last["feture"] != fetureChose) {
            if (dataMap.isEmpty || (dataMap.last[word] != wordRandom)) {
              dataMap.add(
                {
                  "feture": fetureChose,
                  "type": "translate",
                  "typeTranslate": ranType,
                  "word": wordRandom,
                  "listChose": ranType == typeSort.JapanToVietNam
                      ? hanldStringChoseVN(wordRandom.mean)
                      : handleJapaneseString(wordRandom.vocabulary),
                },
              );

              // Kiểm tra nếu từ chưa tồn tại trong listWordsTest mới thêm
              if (!listWordsTest.any((wordCheck) => wordCheck == wordRandom)) {
                listWordsTest.add(wordRandom); // Chỉ thêm nếu từ chưa tồn tại
              }

              i++;
            }
          }
        }else if(fetureChose == "combination"){
          List<word> wordsRandom = [];
          int numberWord = 0;

          if(widget.dataWords.length == 4){
            wordsRandom = List.from(widget.dataWords);
          }else{
            while (numberWord < 4) {
              word wordRandom = widget.dataWords[randomInRange(0, widget.dataWords.length - 1)];
              if (!wordsRandom.contains(wordRandom)) {
                wordsRandom.add(wordRandom);
                numberWord++;
              }
            }
          }


          List<Map<String, dynamic>> dataWordsTest = [];
          List<String> listAwnser = [];
          List<String> dataType = ["JapToVN", "JapToWayRead", "WayReadToJap"];
          String type = dataType[randomInRange(0, 3)];
          for(word wordCheck in wordsRandom){
            dataWordsTest.add(
              type == "JapToVN" ? {
                "word":wordCheck.vocabulary,
                "awnser": wordCheck.mean,
                "wayread": wordCheck.wayread
              }:type == "JapToWayRead" ?{
                "word":wordCheck.vocabulary,
                "awnser": wordCheck.wayread,
                "wayread": wordCheck.wayread
              }:{
                "word":wordCheck.wayread,
                "awnser": wordCheck.vocabulary,
                "wayread": wordCheck.wayread
              },
            );
            if(listWordsTest.any((wordTest) => wordTest != wordCheck)){
              listWordsTest.add(wordCheck);
            }
            type == "JapToVN" ? listAwnser.add(wordCheck.mean) :
            type == "JapToWayRead" ? listAwnser.add(wordCheck.wayread) :
            listAwnser.add(wordCheck.vocabulary);
          }

          dataMap.add(
            {
              "feture": fetureChose,
              "listColumA": dataWordsTest,
              "listColumB": listAwnser,
            },
          );
        }
      }
    }

    if (numberCount < dataMap.length) {
      switch (dataMap[numberCount]["feture"]) {
        case "sort":
          updateView("sort");
          break;
        case "listen":
          updateView("listen");
          break;
        case "combination":
          updateView("combination");
          break;
      }

    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _timerService.stopTimer();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => congraculationScreen(
              listWordsTest: listWordsTest,
              listWordsWrong: wrongWords,
              timeTest: _currentSeconds,
              topic: widget.topic, reload: () {
                widget.reload();
            },
            ),
          ),
        );
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    generateQuestion(widget.dataWords);

    return Scaffold(
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.close, size: 50),
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width - 100,
                  child: LinearProgressIndicator(
                    value: numberCount / (dataMap.length),
                    backgroundColor: Colors.grey[300],
                    color: Colors.greenAccent,
                    minHeight: 15,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
            Container(
              color: Colors.white,
              height: MediaQuery.sizeOf(context).height - AppBar().preferredSize.height - 30,
              child:  Center(
                child: view ?? CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
