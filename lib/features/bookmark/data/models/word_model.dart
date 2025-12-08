import 'package:japaneseapp/features/bookmark/domain/entities/word_entity.dart';

class WordModel extends WordEntity{
  WordModel({required super.word, required super.reading, required super.meaning, required super.exampleJP, required super.exampleVI});

  factory WordModel.fromJson(Map<String, dynamic> json){
    return WordModel(
      word: json['word_jp'],
      reading: json['word_kana'],
      meaning: json['word_mean'],
      exampleJP: json['example_jp'],
      exampleVI: json['example_vi'],
    );
  }
}