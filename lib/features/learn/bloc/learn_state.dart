import 'package:japaneseapp/features/learn/domain/entities/test_entity.dart';
import 'package:japaneseapp/features/learn/domain/entities/word_entity.dart';

abstract class LearnState {}


//state initial load word from topic
class LearnInitial extends LearnState {}

class LearnGeneratation extends LearnState {}

class LearnGenerated extends LearnState {
  final List<TestEntity> testEntities;
  final List<WordEntity> listEntites;
  LearnGenerated(this.testEntities, this.listEntites);
}