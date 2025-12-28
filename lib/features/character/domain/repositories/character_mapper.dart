import 'package:japaneseapp/features/character/domain/entity/character_entity.dart';

class CharacterMapper {
  static CharacterEntity fromRaw({
    required Map<String, dynamic> rawChar,
    required int level,
  }) {
    return CharacterEntity(
      text: rawChar["text"],
      romaji: rawChar["romaji"],
      sound: rawChar["sound"],
      level: level,
    );
  }
}
