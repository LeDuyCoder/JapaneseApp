import 'package:japaneseapp/features/character/domain/entity/character_entity.dart';
import 'package:japaneseapp/features/character/domain/entity/character_group_entity.dart';

class CharacterCollectionEntity {
  final List<CharacterGroupEntity> groups;

  const CharacterCollectionEntity({required this.groups});

  CharacterGroupEntity getGroup(CharacterGroupType type) {
    return groups.firstWhere((g) => g.type == type);
  }
}
