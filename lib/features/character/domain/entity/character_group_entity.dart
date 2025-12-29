import 'package:japaneseapp/features/character/domain/entity/character_entity.dart';

class CharacterGroupEntity {
  final CharacterGroupType type;
  final List<CharacterEntity> characters;

  const CharacterGroupEntity({
    required this.type,
    required this.characters,
  });
}
