import 'package:equatable/equatable.dart';
import 'package:japaneseapp/features/learn/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/learn/domain/entities/card_entity.dart';

class QuickMatchState extends Equatable {
  final CardEntity? cardChosen;
  final CardEntity? cardWrong;
  final List<WordEntity> listCompletes;
  final List<CardEntity> listCards;
  final int timeElapsed; // ⏱ đã trôi qua (giây)
  final int record;

  const QuickMatchState({
    this.cardChosen,
    this.cardWrong,
    required this.listCompletes,
    required this.listCards,
    required this.timeElapsed,
    required this.record
  });

  @override
  List<Object?> get props => [
    cardChosen,
    cardWrong,
    listCompletes,
    listCards,
    timeElapsed,
    record
  ];

  QuickMatchState copyWith({
    CardEntity? cardChosen,
    bool clearChosen = false,
    CardEntity? cardWrong,
    List<WordEntity>? listCompletes,
    List<CardEntity>? listCards,
    int? timeElapsed,
    int? record
  }) {
    return QuickMatchState(
      record: record ?? this.record,
      cardChosen: clearChosen ? null : cardChosen ?? this.cardChosen,
      cardWrong: cardWrong,
      listCompletes: listCompletes ?? this.listCompletes,
      listCards: listCards ?? this.listCards,
      timeElapsed: timeElapsed ?? this.timeElapsed,
    );
  }
}