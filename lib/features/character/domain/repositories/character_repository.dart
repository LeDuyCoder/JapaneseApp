import 'package:japaneseapp/features/character/domain/entity/character_collection_entity.dart';
import 'package:japaneseapp/features/character/domain/entity/character_entity.dart';
import 'package:japaneseapp/features/character/domain/entity/character_group_entity.dart';

abstract class CharacterRepository {
  Future<CharacterCollectionEntity> loadCharacters({required String type, required List<Map<String, dynamic>> rawData});
  CharacterGroupEntity mapGroup(CharacterGroupType type, Map<String, dynamic> rawGroup, Map<dynamic, dynamic>? progressGroup);
}