import 'package:equatable/equatable.dart';
import 'package:japaneseapp/features/learn/domain/entities/word_entity.dart';

enum Combinations {
  jpToVi,
  wordToReadWay,
}

class CombinationTestState extends Equatable {
  final List<WordEntity> columA;
  final List<WordEntity> columB;
  final List<WordEntity> completes;
  final WordEntity? selectedA;
  final WordEntity? selectedB;
  final Combinations typeCombination;

  const CombinationTestState({
    required this.columA,
    required this.columB,
    this.completes = const [],
    required this.typeCombination,
    this.selectedA,
    this.selectedB,
  });

  CombinationTestState copyWith({
    List<WordEntity>? columA,
    List<WordEntity>? columB,
    List<WordEntity>? completes,
    WordEntity? selectedA,
    WordEntity? selectedB,
    Combinations? typeCombination,
  }) {
    return CombinationTestState(
      columA: columA ?? this.columA,
      columB: columB ?? this.columB,
      completes: completes ?? this.completes,
      selectedA: selectedA == null
          ? null
          : selectedA as WordEntity? ?? this.selectedA,
      selectedB: selectedB == null
          ? null
          : selectedB as WordEntity? ?? this.selectedB,
      typeCombination: typeCombination ?? this.typeCombination,
    );
  }

  @override
  List<Object?> get props =>
      [columA, columB, completes, selectedA, selectedB, typeCombination];
}
