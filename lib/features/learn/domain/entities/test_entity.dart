import 'package:japaneseapp/features/learn/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/learn/domain/usecase/generate_test_usecase.dart';

class TestEntity{
  final TestView testView;
  final WordEntity wordEntity;

  TestEntity({required this.testView, required this.wordEntity});
}