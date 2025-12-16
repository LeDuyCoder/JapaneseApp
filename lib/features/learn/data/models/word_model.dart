import 'package:japaneseapp/features/learn/domain/entities/word_entity.dart';

class WordModel extends WordEntity{
  WordModel({
    required super.word,
    required super.mean,
    required super.wayread,
    required super.topic,
    required super.level
  });

  factory WordModel.fromJson(Map<String, dynamic> json) {
    return WordModel(
      word: json['word'],
      mean: json['mean'],
      wayread: json['wayread'],
      topic: json['topic'],
      level: json['level'],
    );
  }
}