import 'dart:math';

import 'package:japaneseapp/features/learn/domain/entities/character_entity.dart';
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
  final List<WordEntity>? wordEntities;
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

  List<TestEntity> generateOfCharacterTest(List<CharacterEntity> listCharacter) {
    const int amountQuestion = 5;

    final List<TestView> testViews = [];
    final List<TestEntity> tests = [];
    final random = Random();

    int index = 0;

    while (index < amountQuestion && listCharacter.isNotEmpty) {
      final TestView testView = _randomCharacterTestView(random);

      if (index > 0 && testViews[index - 1] == testView) {
        continue;
      }

      final int characterIndex = random.nextInt(listCharacter.length);
      final CharacterEntity word = listCharacter.removeAt(characterIndex);

      tests.add(
        TestEntity(
          testView: testView,
          wordEntity: WordEntity(
              word: word.character,
              mean: word.romaji,
              wayread: word.romaji,
              topic: '',
              level: word.level,
              examples: word.examples,
              pathImage: word.pathImage
          ),
        ),
      );

      testViews.add(testView);
      index++;
    }

    return tests;
  }

  TestView _randomCharacterTestView(Random random) {
    const allowedViews = [
      TestView.ChoseTestView,
      TestView.WriteTestView,
      TestView.CombinationTestView,
    ];

    return allowedViews[random.nextInt(allowedViews.length)];
  }
}