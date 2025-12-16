import 'package:equatable/equatable.dart';
import 'package:japaneseapp/features/learn/domain/entities/word_entity.dart';

class WriteTestState extends Equatable{
  final WordEntity wordEntity;

  WriteTestState({required this.wordEntity});

  WriteTestState copyWith({
    WordEntity? wordEntity,
    String? userAnswer
  }){
    return WriteTestState(
        wordEntity: wordEntity ?? this.wordEntity,
    );
  }

  @override
  List<Object?> get props => [wordEntity];
}