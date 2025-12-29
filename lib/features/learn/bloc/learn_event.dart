import 'package:japaneseapp/features/learn/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/learn/domain/enum/type_test.dart';

abstract class LearnEvent {}

class StartLearningEvent extends LearnEvent {
  final String topicName;
  StartLearningEvent(this.topicName);
}

class StartLearningCharacterEvent extends LearnEvent{
  final TypeTest type;

  /// số lượng hàng chữ cái trong data để học
  /// dữ liệu này lấy trong data user
  final int setLevel;

  StartLearningCharacterEvent({required this.type, required this.setLevel});
}