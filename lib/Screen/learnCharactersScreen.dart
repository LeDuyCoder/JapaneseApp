import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/Config/dataJson.dart';
import 'package:japaneseapp/Screen/congraculationCharacterScreen.dart';
import 'package:japaneseapp/Theme/colors.dart';
import 'package:japaneseapp/Widget/learnWidget/combinationTest.dart';
import 'package:japaneseapp/Widget/learnWidget/writeTestCharacterScreen.dart';
import 'package:japaneseapp/Widget/learnWidget/writeTestScreen.dart';
import 'package:kana_kit/kana_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:japaneseapp/Module/character.dart' as charHiKa;
import 'package:japaneseapp/Widget/learnWidget/choseTest.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';
import '../Service/timeService.dart';
import '../Widget/quitTab.dart';

class learnCharactersScreen extends StatefulWidget {
  final String typeCharacter;
  final BuildContext contextScreen;
  final void Function() loadScreen;
  const learnCharactersScreen({super.key, required this.typeCharacter, required this.contextScreen, required this.loadScreen});

  @override
  State<StatefulWidget> createState() => _learnCharactersScreen();
}

class _learnCharactersScreen extends State<learnCharactersScreen> {
  int maxQuestion = 15;
  int question = 0;
  List<Widget> mapQuesstion = [];
  late Future<bool> _loadQuestionsFuture;
  Widget? view;
  late TimerService _timerService;
  int _currentSeconds = 0;

  final kanaKit = KanaKit();

  List<String> listCharacterInTestToCheck = [];
  List<String> listCharacterAwnserWrongInTest = [];

  @override
  void initState() {
    super.initState();
    _loadQuestionsFuture = generateQuestion();
    _initialize();
  }

  Future<void> _initialize() async {
    _timerService = TimerService(onUpdate: (seconds) {
      _currentSeconds = seconds;
    });
    _timerService.startTimer();
  }

  Future<dynamic> loadJsonData() async {
    return dataJson.instance.data;
  }

  charHiKa.character? findCharacter(dynamic dataCharacter, String type, String targetSearch) {
    try {
      int index = (type == "hiragana") ? 0 : 1;
      List<dynamic> sectionList = dataCharacter[index];
      for (var section in sectionList) {
        if (section is Map && section.containsKey(targetSearch)) {
          var data = section[targetSearch];
          return charHiKa.character(
            null,
            text: data["text"] ?? "",
            romaji: data["romaji"] ?? "",
            image: data["image"] ?? "",
            example: data["example"] ?? "",
          );
        }
      }
      return null;
    } catch (e) {
      print("Error finding character: $e");
      return null;
    }
  }

  List<String> generateWrongAnswers(dynamic dataCharacter, List<String> charactersTest, String wordCorrect, bool romaji) {
    Set<String> wrongAnswers = {};
    Random random = Random();
    List<String> shuffledCharacters = List.of(charactersTest)..shuffle(random);

    for (String char in shuffledCharacters) {
      if (wrongAnswers.length >= 3) break;
      var character = findCharacter(dataCharacter, widget.typeCharacter, char);
      if (character != null) {
        String answer = romaji ? character.romaji : character.text;
        if (answer != wordCorrect && !wrongAnswers.contains(answer)) {
          wrongAnswers.add(answer);
        }
      }
    }

    print(wrongAnswers);
    print(wordCorrect);
    return wrongAnswers.toList();
  }

  String toRomaji(String text) {
    return kanaKit.toRomaji(text).trim().toLowerCase();
  }


  List<String> generateWrongAwnsersExempleToWay(dynamic dataCharacter, List<String> charactersTest, String example) {
    Set<String> wrongAnswers = {};
    Random random = Random();
    List<String> shuffledCharacters = List.of(charactersTest)..shuffle(random);

    for (String char in shuffledCharacters) {
      if (wrongAnswers.length >= 3) break;
      var character = findCharacter(dataCharacter, widget.typeCharacter, char);
      if (character != null) {
        String answer = (character.example[Random().nextInt(3)] as Map<String, dynamic>).keys.first;
        if (answer != example && !wrongAnswers.contains(answer)) {
          wrongAnswers.add(toRomaji(answer));
        }
      }
    }

    wrongAnswers.add(toRomaji(example));


    return wrongAnswers.toList();
  }

  List<String> generateWrongAwnsersWayToExample(dynamic dataCharacter, List<String> charactersTest, String example) {
    Set<String> wrongAnswers = {};
    Random random = Random();
    List<String> shuffledCharacters = List.of(charactersTest)..shuffle(random);

    for (String char in shuffledCharacters) {
      if (wrongAnswers.length >= 3) break;
      var character = findCharacter(dataCharacter, widget.typeCharacter, char);
      if (character != null) {
        String answer = (character.example[Random().nextInt(3)] as Map<String, dynamic>).keys.first;
        if (answer != example && !wrongAnswers.contains(answer)) {
          wrongAnswers.add(answer);
        }
      }
    }

    wrongAnswers.add(example);


    return wrongAnswers.toList();
  }

  Map<String, dynamic> generateDataChoseTest(dynamic jsonData, List<String> charactersTest, charHiKa.character character, int level){
    Map<String, dynamic> data;

    List<String> typeChoses = ["WordToWay", "ExempleToWay", "WayToWord", "WaytoExample", "WayToWord", "ExempleToWay", "WordToWay", "WaytoExample", "WordToWay", "WayToWord"];
    List<String> typeChosesLowLevel = ["WordToWay", "WayToWord", "WayToWord", "WordToWay", "WordToWay", "WayToWord"];
    String typeChose = level >= 0 && level < 2 ? typeChosesLowLevel[Random().nextInt(typeChosesLowLevel.length)] : typeChoses[Random().nextInt(typeChoses.length)];

    switch(typeChose){
      case "WordToWay":
        int correctIndex = Random().nextInt(4) + 1;;
        List<String> wrongAnswers = generateWrongAnswers(jsonData, charactersTest, character.romaji, true);
        wrongAnswers.shuffle();
        data = {
          "word": character.text,
          "anwser": character.romaji,
          "listAnwserWrong": wrongAnswers,
          "numberRight": correctIndex,
          "read": true
        };
        break;
      case "ExempleToWay":
        int correctIndex = Random().nextInt(4) + 1;;
        String example = (character.example[Random().nextInt(3)] as Map<String, dynamic>).keys.first;
        print(example);
        List<String> dataAwnser = generateWrongAwnsersExempleToWay(jsonData, charactersTest, example);

        print(dataAwnser);

        String exampleAwnser = dataAwnser[3];
        dataAwnser.remove(exampleAwnser);

        data = {
          "word": example,
          "anwser": exampleAwnser,
          "listAnwserWrong": dataAwnser,
          "numberRight": correctIndex,
        };

        break;
      case "WaytoExample":
        int correctIndex = Random().nextInt(4) + 1;;
        String example = (character.example[Random().nextInt(3)] as Map<String, dynamic>).keys.first;
        print(example);
        List<String> dataAwnser = generateWrongAwnsersWayToExample(jsonData, charactersTest, example);

        print(dataAwnser);

        String exampleAwnser = dataAwnser[3];
        dataAwnser.remove(exampleAwnser);

        data = {
          "word": toRomaji(example),
          "anwser": exampleAwnser,
          "listAnwserWrong": dataAwnser,
          "numberRight": correctIndex,
        };

        break;
      case "WayToWord":
        int correctIndex = Random().nextInt(4) + 1;;
        List<String> wrongAnswers = generateWrongAnswers(jsonData, charactersTest, character.text, false);
        wrongAnswers.shuffle();

        data = {
          "word": character.romaji,
          "anwser": character.text,
          "listAnwserWrong": wrongAnswers,
          "numberRight": correctIndex,
        };
        break;
      default:
        data = {};
    }
    return data;
  }

  Future<bool> generateQuestion() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? storedData = pref.getString(widget.typeCharacter);
    List<String> typeTest = ["chose", "write", "combination"];
    String lastTest = "";
    if (storedData == null) return false;

    Map<String, dynamic> dataCharacterUser = jsonDecode(storedData);
    dynamic jsonData = await loadJsonData();

    List<String> charactersTest = [];
    int typeSection = widget.typeCharacter == "hiragana" ? 2 : 3;
    int levelSet = dataCharacterUser["levelSet"] ?? 0;
    int level = dataCharacterUser["level"] ?? 0;

    if(level >= 0 && level < 2){
      List<dynamic> levelChars = jsonData[typeSection][levelSet];
      charactersTest.addAll(levelChars.cast<String>());
    }else{
      for (int i = 0; i <= levelSet; i++) {
        List<dynamic> levelChars = jsonData[typeSection][i];
        charactersTest.addAll(levelChars.cast<String>());
      }
      charactersTest.shuffle();
    }

    listCharacterInTestToCheck.addAll(charactersTest);

    for (int i = 0; i < maxQuestion && charactersTest.isNotEmpty; i++) {
      String wordText = charactersTest[i % charactersTest.length];
      var character = findCharacter(jsonData, widget.typeCharacter, wordText);
      if (character == null) continue;

      String randTest = "";
      do {
        randTest = typeTest[Random().nextInt(typeTest.length)];
      } while (randTest == lastTest);
      lastTest = randTest;

      if(randTest == "chose"){
        mapQuesstion.add(
          choseTest(
            data: generateDataChoseTest(jsonData, charactersTest, character, level),
            nextQuestion: () {
              if (question < mapQuesstion.length - 1) {
                setState(() {
                  question += 1;
                  view = mapQuesstion[question];
                });
              } else {
                finishTest(jsonData);
              }
            },
            readText: true,
          ),
        );
      }
      else if (randTest == "combination") {
        Set<String> listCharacterExist = {};
        Set<String> listExampleExist = {}; // Kiểm tra trùng lặp nhanh hơn
        List<NodeColum> dataColumeA = [];
        List<NodeColum> dataColumeB = [];

        List<String> typeCombinations = ["character", "example"];
        String typeCombination = level >= 0 && level < 2 ? "character" : typeCombinations[Random().nextInt(typeCombinations.length)];

        while (listCharacterExist.length + listExampleExist.length < 4) {
          String characterJapanese = charactersTest[Random().nextInt(charactersTest.length)];

          if (typeCombination == "character") {
            if (listCharacterExist.add(characterJapanese)) {
              String wayRead = toRomaji(characterJapanese);
              NodeColum nodeColum = new NodeColum(UuidV4().generate(), characterJapanese, wayRead, characterJapanese);
              dataColumeA.add(nodeColum);
              dataColumeB.add(nodeColum);
            }
          } else {
            charHiKa.character characterJPObject = findCharacter(jsonData, widget.typeCharacter, characterJapanese)!;
            String exampleCharacter = (characterJPObject.example[Random().nextInt(3)] as Map<String, dynamic>).keys.first;
            if (listExampleExist.add(exampleCharacter)) {
              String coverWayReadExample = toRomaji(exampleCharacter);
              NodeColum nodeColum = new NodeColum(UuidV4().generate(), exampleCharacter, coverWayReadExample, exampleCharacter);
              print(nodeColum);
              dataColumeA.add(nodeColum);
              dataColumeB.add(nodeColum);//coverWayReadExample
            }
          }
        }

        mapQuesstion.add(
          combinationTest(
            listColumA: dataColumeA,
            listColumB: dataColumeB,
            nextQuestion: () {
              if (question < mapQuesstion.length - 1) {
                setState(() {
                  question++;
                  view = mapQuesstion[question];
                });
              } else {
                finishTest(jsonData);
              }
            },
          ),
        );
      }
      else{
        charHiKa.character characterObject = findCharacter(jsonData, widget.typeCharacter, wordText)!;


        mapQuesstion.add(
          characterObject.image == null ? WriteTestScreen(testData: wordText, nextLearned: (isCorrect) {
            if (question < mapQuesstion.length) {
              setState(() {
                question += 1;
                view = mapQuesstion[question];
              });
            } else {
              finishTest(jsonData);
            }
          }) : WriteTestCharacterScreen(testData: wordText, nextLearned: (isCorrect) {
            if (question < mapQuesstion.length - 1) {
              setState(() {
                question += 1;
                view = mapQuesstion[question];
              });
            } else {
              finishTest(jsonData);
            }
          }, ImageAsset: "assets/${characterObject.image!}",)
        );
      }
    }
    print(mapQuesstion);
    view = mapQuesstion[question];
    return true;
  }

  void finishTest(dynamic dataJson){
    Future.delayed(Duration.zero, () {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => congraculationChacterScreen(listWordsTest: listCharacterInTestToCheck, listWordsWrong: listCharacterAwnserWrongInTest, timeTest: _currentSeconds, topic: widget.typeCharacter, reload: (){
            widget.loadScreen();
          }, dataJson: dataJson,),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return Future.value(false);
      },
      child: Scaffold(
        body: FutureBuilder<bool>(
          future: _loadQuestionsFuture,
          builder: (context, snapshot) {

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || !snapshot.data!) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (mapQuesstion.isEmpty) {
              return const Center(child: Text('No questions available.'));
            }

            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => showModalBottomSheet(
                          context: context,
                          builder: (ctx) => quitTab(),
                        ),
                        icon: const Icon(Icons.close, size: 50),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: LinearProgressIndicator(
                            value: (question + 1) / mapQuesstion.length,
                            backgroundColor: Colors.grey[300],
                            color: AppColors.primary,
                            minHeight: 15,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: mapQuesstion[question],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class NodeColum{
  final String uuid;
  final String word;
  final String awnser;
  final String wayread;

  NodeColum(this.uuid, this.word, this.awnser, this.wayread);

  @override
  String toString() {
    // TODO: implement toString
    return '${uuid.toString()} - $word - $awnser - $wayread';
  }
}