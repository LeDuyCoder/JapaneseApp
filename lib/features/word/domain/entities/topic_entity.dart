import 'package:equatable/equatable.dart';
import 'package:japaneseapp/features/word/domain/entities/word_entity.dart';

class TopicEntity extends Equatable {
  final String name;
  final List<WordEntity> words;

  const TopicEntity({required this.name, required this.words});

  @override
  List<Object?> get props => [name, words];
}