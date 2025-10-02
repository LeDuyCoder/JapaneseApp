import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/Module/word.dart';
import 'package:japaneseapp/Screen/congraculationScreen.dart';
import 'package:japaneseapp/Screen/splashScreen.dart';
import 'package:japaneseapp/Theme/colors.dart';
import 'package:japaneseapp/Widget/learnWidget/choseTest.dart';
import 'package:japaneseapp/Widget/learnWidget/combinationTest.dart';
import 'package:japaneseapp/Widget/learnWidget/listenTest.dart';
import 'package:japaneseapp/Widget/learnWidget/readTest.dart';
import 'package:japaneseapp/Widget/learnWidget/sortText.dart';
import 'package:japaneseapp/Widget/learnWidget/writeTestScreen.dart';
import 'package:japaneseapp/Widget/quitTab.dart';

import '../Service/timeService.dart';

class learnScreen extends StatefulWidget {
  final List<word> dataWords;
  final String topic;
  final void Function() reload;
  const learnScreen(
      {super.key,
        required this.dataWords,
        required this.topic,
        required this.reload});

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

  int maxQuestion = 5; //5
  int amountRightAwnser = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await _initialize();
    });
  }

  Future<void> _initialize() async {
    _timerService = TimerService(onUpdate: (seconds) {
      _currentSeconds = seconds;
    });
    _timerService.startTimer();
    await generateQuestion(widget.dataWords);
  }

  int randomInRange(int min, int max) {
    if (max <= min) return min; // tránh nextInt(0) lỗi
    return min + Random().nextInt(max - min);
  }

  List<String> hanldStringChoseVN(String mean) {
    List<String> newListString = mean
        .split(" ")
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    newListString.shuffle();
    return newListString;
  }

  List<String> handleJapaneseString(String input) {
    List<String> characters =
    input.split('').where((e) => e.trim().isNotEmpty).toList();
    characters.shuffle(Random());
    return characters;
  }

  void updateView(String feature) {
    print("feature: ${feature}");
    setState(() {
      view = feature == "sort"
          ? sortText(
        WordTest: dataMap[numberCount]["word"],
        wordChose: dataMap[numberCount]["listChose"],
        typeTest: dataMap[numberCount]["typeTranslate"],
        isRetest: amountRightAwnser >= maxQuestion &&
            amountRightAwnser <= (dataMap.length + wrongWords.length),
        nextLearned: (isRight) {
          handleNext(isRight);
        },
      )
          : feature == "listen"
          ? listenTest(
          WordTest: dataMap[numberCount]["word"],
          wordChose: dataMap[numberCount]["listChose"],
          typeTest: dataMap[numberCount]["typeTranslate"],
          isRetest: amountRightAwnser >= maxQuestion &&
              amountRightAwnser <= (dataMap.length + wrongWords.length),
          nextLearned: (isRight) {
            handleNext(isRight);
          })
          : feature == "combination"
          ? combinationTest(
          listColumA: dataMap[numberCount]["listColumA"],
          listColumB: dataMap[numberCount]["listColumB"],
          nextQuestion: () {
            handleNext(true);
          })
          : feature == "write"
          ? WriteTestScreen(
            testData: dataMap[numberCount]["word"],
            nextLearned: (bool isRight) {
              handleNext(true);
            },
            mean: dataMap[numberCount]["mean"],
          )
          : feature == "chose" ? choseTest(
              data: {
                "word": dataMap[numberCount]["word"],
                "anwser": dataMap[numberCount]["anwser"],
                "listAnwserWrong": dataMap[numberCount]
                ["listAnwserWrong"],
                "numberRight": dataMap[numberCount]["numberRight"],
              },
              nextQuestion: () {
                handleNext(true);
              },
              readText: false,
            )
          : readTest(
              word: dataMap[numberCount]["word"],
              kana: dataMap[numberCount]["kana"],
              mean: dataMap[numberCount]["mean"],
              nextQuestion: () {
                handleNext(true);
              },
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
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => congraculationScreen(
                listWordsTest: listWordsTest,
                listWordsWrong: wrongWords,
                timeTest: _currentSeconds,
                topic: widget.topic,
                reload: () {
                  widget.reload();
                },
              ),
            ),
          );
        }
      });
    });
  }

  String generateWrongAwnser(
      String typeAwnser, String rightAwnser, List<word> dataWords) {
    if (dataWords.isEmpty) return "";

    // nếu chỉ có 1 từ thì không có đáp án sai -> trả luôn chính nó
    if (dataWords.length == 1) {
      return typeAwnser == "JapToVN"
          ? dataWords.first.mean
          : dataWords.first.vocabulary;
    }

    word ranWord = dataWords[randomInRange(0, dataWords.length)];
    int tries = 0;

    // tránh chọn trùng với đáp án đúng
    while ((ranWord.mean == rightAwnser || ranWord.vocabulary == rightAwnser) &&
        tries < 50) {
      ranWord = dataWords[randomInRange(0, dataWords.length)];
      tries++;
    }

    // fallback nếu vẫn trùng
    if (ranWord.mean == rightAwnser || ranWord.vocabulary == rightAwnser) {
      ranWord = dataWords.firstWhere(
            (w) => w.mean != rightAwnser && w.vocabulary != rightAwnser,
        orElse: () => dataWords.first,
      );
    }

    return typeAwnser == "JapToVN" ? ranWord.mean : ranWord.vocabulary;
  }

  Future<void> generateQuestion(List<word> dataWords) async {
    if (dataMap.isEmpty) {
      int i = 0;
      String fetureChose = "";
      while (i < maxQuestion) {
        List<String> feture = [
          "sort",
          "listen",
          "combination",
          "chose",
          "write",
        ];
        if(splashScreen.featureState.readTesting){
          feture.add("read");
        }
        String newQuestion = feture[randomInRange(0, feture.length)];
        print(feture);
        print(newQuestion);
        if (fetureChose != newQuestion) {
          fetureChose = newQuestion;
          if (fetureChose == "sort" || fetureChose == "listen") {
            typeSort ranType = randomInRange(0, 2) == 0
                ? typeSort.VietNamToJapan
                : typeSort.JapanToVietNam;
            word wordRandom =
            dataWords[randomInRange(0, widget.dataWords.length)];
            if (dataMap.isEmpty || dataMap.last["feture"] != fetureChose) {
              if (dataMap.isEmpty || (dataMap.last["word"] != wordRandom)) {
                dataMap.add(
                  {
                    "feture": fetureChose,
                    "type": "translate",
                    "typeTranslate": ranType,
                    "word": wordRandom,
                    "listChose": ranType == typeSort.JapanToVietNam
                        ? hanldStringChoseVN(
                        "${wordRandom.mean} ${generateWrongAwnser("JapToVN", wordRandom.mean, dataWords)}")
                        : handleJapaneseString(
                        "${wordRandom.vocabulary} ${generateWrongAwnser("VNToJap", wordRandom.mean, dataWords)}"),
                  },
                );

                if (!listWordsTest
                    .any((wordCheck) => wordCheck == wordRandom)) {
                  listWordsTest.add(wordRandom);
                }

                i++;
              }
            }
          }
          else if (fetureChose == "combination") {
            List<word> wordsRandom = [];
            int numberWord = 0;

            if (widget.dataWords.length == 4) {
              wordsRandom = List.from(widget.dataWords);
            } else {
              while (numberWord < 4) {
                word wordRandom = widget
                    .dataWords[randomInRange(0, widget.dataWords.length - 1)];
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
            for (word wordCheck in wordsRandom) {
              dataWordsTest.add(
                type == "JapToVN"
                    ? {
                  "word": wordCheck.vocabulary,
                  "awnser": wordCheck.mean,
                  "wayread": wordCheck.wayread
                }
                    : type == "JapToWayRead"
                    ? {
                  "word": wordCheck.vocabulary,
                  "awnser": wordCheck.wayread,
                  "wayread": wordCheck.wayread
                }
                    : {
                  "word": wordCheck.wayread,
                  "awnser": wordCheck.vocabulary,
                  "wayread": wordCheck.wayread
                },
              );
              if (!listWordsTest.contains(wordCheck)) {
                listWordsTest.add(wordCheck);
              }
              type == "JapToVN"
                  ? listAwnser.add(wordCheck.mean)
                  : type == "JapToWayRead"
                  ? listAwnser.add(wordCheck.wayread)
                  : listAwnser.add(wordCheck.vocabulary);
            }

            dataMap.add(
              {
                "feture": fetureChose,
                "listColumA": dataWordsTest,
                "listColumB": listAwnser,
              },
            );
          }
          else if (fetureChose == "chose") {
            word wordCheckRandom =
            widget.dataWords[randomInRange(0, widget.dataWords.length)];

            List<String> wordsWrong = [];
            List<String> dataType = ["JapToVN", "JapToWayRead", "WayReadToJap"];
            String type = dataType[randomInRange(0, 3)];

            Set<String> usedWords = {wordCheckRandom.vocabulary};

            while (wordsWrong.length < 3) {
              word wordRandom =
              widget.dataWords[randomInRange(0, widget.dataWords.length)];

              if (!usedWords.contains(wordRandom.vocabulary)) {
                usedWords.add(wordRandom.vocabulary);

                if (type == "JapToVN") {
                  wordsWrong.add(wordRandom.mean);
                } else if (type == "JapToWayRead") {
                  wordsWrong.add(wordRandom.wayread);
                } else {
                  wordsWrong.add(wordRandom.vocabulary);
                }
              }
            }

            dataMap.add(
              type == "JapToVN"
                  ? {
                "feture": fetureChose,
                "word": wordCheckRandom.vocabulary,
                "anwser": wordCheckRandom.mean,
                "listAnwserWrong": wordsWrong,
                "numberRight": randomInRange(1, 5),
              }
                  : type == "JapToWayRead"
                  ? {
                "feture": fetureChose,
                "word": wordCheckRandom.vocabulary,
                "anwser": wordCheckRandom.wayread,
                "listAnwserWrong": wordsWrong,
                "numberRight": randomInRange(1, 5),
              }
                  : {
                "feture": fetureChose,
                "word": wordCheckRandom.wayread,
                "anwser": wordCheckRandom.vocabulary,
                "listAnwserWrong": wordsWrong,
                "numberRight": randomInRange(1, 5),
              },
            );
          }
          else if (fetureChose == "write") {
            word wordCheckRandom =
            widget.dataWords[randomInRange(0, widget.dataWords.length)];

            dataMap.add({
              "feture": fetureChose,
              "word": wordCheckRandom.vocabulary,
              "mean": wordCheckRandom.mean
            });
          }
          else if ((fetureChose == "read")){
            word wordCheckRandom =
            widget.dataWords[randomInRange(0, widget.dataWords.length)];

            dataMap.add({
              "feture": fetureChose,
              "word": wordCheckRandom.vocabulary,
              "kana": wordCheckRandom.wayread,
              "mean": wordCheckRandom.mean
            });
          }
          i++;
        }
      }

      if (dataMap.isNotEmpty && numberCount < dataMap.length) {
        updateView(dataMap[numberCount]["feture"]);
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
                topic: widget.topic,
                reload: () {
                  widget.reload();
                },
              ),
            ),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context, builder: (ctx) => quitTab());
                  },
                  icon: const Icon(Icons.close, size: 50),
                ),
                Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: LinearProgressIndicator(
                        value: numberCount / (dataMap.length + 1),
                        backgroundColor: Colors.grey[300],
                        color: AppColors.primary,
                        minHeight: 15,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    )),
              ],
            ),
            view != null
                ? Expanded(child: view!)
                : Center(
              child: Container(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
