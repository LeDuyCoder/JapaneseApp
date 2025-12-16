import 'dart:math';

import 'package:japaneseapp/features/learn/domain/entities/test_entity.dart';
import 'package:japaneseapp/features/learn/domain/entities/word_entity.dart';

enum TestView{
  ListenTestView,
  ChoseTestView,
  SortTestView,
  SpeakTestView,
  WriteTestView,
  CombinationTestView,
}

class GenerateTestUsecase{
  final List<WordEntity> wordEntities;
  int amountQuestion = 5;

  GenerateTestUsecase(this.amountQuestion, {required this.wordEntities});

  TestView _randomTestView(){
    final random = Random();
    int index = random.nextInt(TestView.values.length);
    return TestView.values[index];
  }

  List<TestEntity> generate(List<WordEntity> listWords) {
    final List<TestView> testViews = [];
    final List<TestEntity> tests = [];
    final random = Random();

    int index = 0;

    while (index < amountQuestion && listWords.isNotEmpty) {
      final testView = _randomTestView();

      if (index > 0 && testViews[index - 1] == testView) {
        continue;
      }

      final wordIndex = random.nextInt(listWords.length);
      WordEntity word = listWords.removeAt(wordIndex);
      tests.add(TestEntity(testView: testView, wordEntity: word));
      testViews.add(testView);
      index++;
    }

    return tests;
  }

}