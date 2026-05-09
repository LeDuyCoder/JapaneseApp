import 'package:japaneseapp/features/learn/domain/entities/word_entity.dart';

class CardEntity{
  final String text;
  final WordEntity wordEntity;

  CardEntity({required this.text, required this.wordEntity});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CardEntity && other.text == text && other.wordEntity == wordEntity;

  @override
  int get hashCode => text.hashCode;
}