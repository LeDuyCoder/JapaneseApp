import '../../../dictionary/domain/entities/word_entity.dart';

class WordModel extends WordEntity {
  WordModel({
    required super.word,
    required super.meaning,
    required super.reading,
    required super.isBookmarked,
    required super.anotherWord,
    required super.example,
    required super.jlpt,
    required super.tag,
  });

  factory WordModel.fromJson(Map<String, dynamic> json) {

    List<String> anotherWords = [];
    if (json.containsKey("anotherWord")) {
      anotherWords = (json["anotherWord"] as List).map((e) => e.toString()).toList();
    }

    return WordModel(
      word: json["word"],
      meaning: (json["meaning"] as List).join(",").replaceAll("[", "").replaceAll("]", ""),
      anotherWord: anotherWords,
      tag: (json["tags"] as List).join(",").replaceAll("[", "").replaceAll("]", "") ?? "",
      isBookmarked: json["stored"] ?? false,
      reading: json["reading"],
      example: json["example"] ?? '',
      jlpt: json["jlpt"] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    "word": word,
    "meaning": meaning,
    "isBookmarked": isBookmarked,
    "anotherWord": anotherWord,
    "tag": tag,
    "reading": reading,
  };
}
