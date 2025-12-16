import 'package:equatable/equatable.dart';
import 'package:japaneseapp/features/learn/domain/entities/word_entity.dart';

class SpeakTestState extends Equatable{
  final bool isListening;
  final bool speaking;
  final String timeDisplay;
  final String userAnswer;
  final double confidence;
  final WordEntity wordEntity;

  SpeakTestState({
    required this.isListening,
    required this.speaking,
    required this.timeDisplay,
    required this.userAnswer,
    required this.confidence,
    required this.wordEntity,
  });

  factory SpeakTestState.initial(WordEntity wordEntity) {
    return SpeakTestState(
      isListening: false,
      speaking: false,
      timeDisplay: "00:00",
      userAnswer: "",
      confidence: 0,
      wordEntity: wordEntity,
    );
  }

  SpeakTestState copyWith({
    bool? isListening,
    bool? speaking,
    String? timeDisplay,
    String? userAnswer,
    double? confidence,
  }) {
    return SpeakTestState(
      isListening: isListening ?? this.isListening,
      speaking: speaking ?? this.speaking,
      timeDisplay: timeDisplay ?? this.timeDisplay,
      userAnswer: userAnswer ?? this.userAnswer,
      confidence: confidence ?? this.confidence,
      wordEntity: wordEntity,
    );
  }

  @override
  List<Object?> get props => [isListening, speaking, timeDisplay, userAnswer, confidence, wordEntity];
}
