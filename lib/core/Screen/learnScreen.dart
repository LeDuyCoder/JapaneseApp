import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Module/word.dart';
import 'package:japaneseapp/core/Screen/congraculationScreen.dart';
import 'package:japaneseapp/core/Screen/learnCharactersScreen.dart';
import 'package:japaneseapp/core/Screen/splashScreen.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/core/Widget/learnWidget/choseTest.dart';
import 'package:japaneseapp/core/Widget/learnWidget/combinationTest.dart';
import 'package:japaneseapp/core/Widget/learnWidget/listenTest.dart';
import 'package:japaneseapp/core/Widget/learnWidget/readTest.dart';
import 'package:japaneseapp/core/Widget/learnWidget/sortText.dart';
import 'package:japaneseapp/core/Widget/learnWidget/writeTestScreen.dart';
import 'package:japaneseapp/core/Widget/quitTab.dart';
import 'package:uuid/v4.dart';

import '../../features/splash/presentation/splash_screen.dart';
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

  int maxQuestion = 6; //5
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
            WordTest: dataMap[numberCount]["wordObject"],
          )
          : feature == "chose" ? choseTest(
              WordTest: dataMap[numberCount]["wordObject"],
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
      String typeAwnser, String rightAwnser, List<word> dataWords)
  {
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
    if (dataMap.isNotEmpty) return;

    int i = 0;
    int safetyCounter = 0;
    String lastFeature = "";
    List<String> features = [
      "sort",
      "listen",
      "combination",
      "chose",
      "write",
    ];

    if (SplashScreen.featureState.readTesting) {
      features.add("read");
    }

    while (i < maxQuestion && safetyCounter < 1000) {
      safetyCounter++;

      String newFeature = features[randomInRange(0, features.length)];

      // tránh lặp lại liên tục 1 loại
      if (newFeature == lastFeature && features.length > 1) {
        continue;
      }
      lastFeature = newFeature;

      if (newFeature == "sort" || newFeature == "listen") {
        typeSort ranType = randomInRange(0, 2) == 0
            ? typeSort.VietNamToJapan
            : typeSort.JapanToVietNam;
        word wordRandom = dataWords[randomInRange(0, dataWords.length)];

        dataMap.add({
          "feture": newFeature,
          "type": "translate",
          "typeTranslate": ranType,
          "word": wordRandom,
          "listChose": ranType == typeSort.JapanToVietNam
              ? hanldStringChoseVN(
            "${wordRandom.mean} ${generateWrongAwnser("JapToVN", wordRandom.mean, dataWords)}",
          )
              : handleJapaneseString(
            "${wordRandom.vocabulary} ${generateWrongAwnser("VNToJap", wordRandom.mean, dataWords)}",
          ),
        });

        if (!listWordsTest.contains(wordRandom)) {
          listWordsTest.add(wordRandom);
        }
      }

      else if (newFeature == "combination") {
        List<word> wordsRandom = [];
        int numberWord = 0;

        if (dataWords.length <= 4) {
          wordsRandom = List.from(dataWords);
        } else {
          while (numberWord < 4 && safetyCounter < 1000) {
            word wordRandom = dataWords[randomInRange(0, dataWords.length)];
            if (!wordsRandom.contains(wordRandom)) {
              wordsRandom.add(wordRandom);
              numberWord++;
            }
          }
        }

        List<NodeColum> dataWordsTest = [];
        List<String> dataType = ["JapToVN", "JapToWayRead", "WayReadToJap"];
        String type = dataType[randomInRange(0, 3)];

        for (word w in wordsRandom) {
          dataWordsTest.add(
            type == "JapToVN"
                ? NodeColum(UuidV4().generate(), w.vocabulary, w.mean, w.wayread,
                wordObject: w)
                : type == "JapToWayRead"
                ? NodeColum(UuidV4().generate(), w.vocabulary, w.wayread,
                w.wayread, wordObject: w)
                : NodeColum(UuidV4().generate(), w.wayread, w.vocabulary,
                w.wayread, wordObject: w),
          );

          if (!listWordsTest.contains(w)) {
            listWordsTest.add(w);
          }
        }

        dataMap.add({
          "feture": newFeature,
          "listColumA": dataWordsTest,
          "listColumB": dataWordsTest,
        });
      }

      else if (newFeature == "chose") {
        word wordRandom = dataWords[randomInRange(0, dataWords.length)];
        List<String> dataType = ["JapToVN", "JapToWayRead", "WayReadToJap"];
        String type = dataType[randomInRange(0, 3)];
        List<String> wrongWords = [];
        Set<String> used = {wordRandom.vocabulary};

        while (wrongWords.length < 3 && safetyCounter < 1000) {
          safetyCounter++;
          word w = dataWords[randomInRange(0, dataWords.length)];
          if (used.add(w.vocabulary)) {
            wrongWords.add(type == "JapToVN"
                ? w.mean
                : type == "JapToWayRead"
                ? w.wayread
                : w.vocabulary);
          }
        }

        dataMap.add({
          "feture": newFeature,
          "word": type == "WayReadToJap"
              ? wordRandom.wayread
              : wordRandom.vocabulary,
          "anwser": type == "JapToVN"
              ? wordRandom.mean
              : type == "JapToWayRead"
              ? wordRandom.wayread
              : wordRandom.vocabulary,
          "listAnwserWrong": wrongWords,
          "numberRight": randomInRange(1, 5),
          "wordObject": wordRandom,
        });
      }

      else if (newFeature == "write") {
        word w = dataWords[randomInRange(0, dataWords.length)];
        dataMap.add({
          "feture": newFeature,
          "wordObject": w,
          "word": w.vocabulary,
          "mean": w.mean,
        });
      }

      else if (newFeature == "read") {
        word w = dataWords[randomInRange(0, dataWords.length)];
        dataMap.add({
          "feture": newFeature,
          "word": w.vocabulary,
          "kana": w.wayread,
          "mean": w.mean,
        });
      }

      i++;
    }

    // Nếu vẫn trống => fallback
    if (dataMap.isEmpty) {
      debugPrint("⚠️ Không sinh được câu hỏi, tạo tạm 1 câu test mặc định.");
      word w = dataWords.first;
      dataMap.add({
        "feture": "read",
        "word": w.vocabulary,
        "kana": w.wayread,
        "mean": w.mean,
      });
    }

    if (numberCount < dataMap.length) {
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
              reload: widget.reload,
            ),
          ),
        );
      });
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
