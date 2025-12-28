import 'package:japaneseapp/core/Service/Local/local_db_service.dart';
import 'package:japaneseapp/features/character/domain/entity/character_collection_entity.dart';
import 'package:japaneseapp/features/character/domain/entity/character_entity.dart';
import 'package:japaneseapp/features/character/domain/entity/character_group_entity.dart';
import 'package:japaneseapp/features/character/domain/repositories/character_mapper.dart';

class CharacterDatasource{
  final LocalDbService _db = LocalDbService.instance;

  Future<CharacterCollectionEntity> loadCharacters({
    required String type,
    required List<Map<String, dynamic>> rawData,
  }) async {
    final progressMap = await _db.wordDao.getDataCharacter(type);
    return CharacterCollectionEntity(
      groups: [
        mapGroup(
          CharacterGroupType.basic,
          rawData[0],
          progressMap["1"],
        ),
        mapGroup(
          CharacterGroupType.dakuon,
          rawData[1],
          progressMap["2"],
        ),
        mapGroup(
          CharacterGroupType.combo,
          rawData[2],
          progressMap["3"],
        ),
        mapGroup(
          CharacterGroupType.small,
          rawData[3],
          progressMap["4"],
        ),
        mapGroup(
          CharacterGroupType.longVowel,
          rawData[4],
          progressMap["5"],
        ),
      ],
    );
  }

  CharacterGroupEntity mapGroup(
      CharacterGroupType type,
      Map<String, dynamic> rawGroup,
      Map<dynamic, dynamic>? progressGroup,
      ) {
    return CharacterGroupEntity(
      type: type,
      characters: rawGroup.values.map((char) {
        final level =
            progressGroup?[char["text"]]?.first?["level"] ?? 0;

        return CharacterMapper.fromRaw(
          rawChar: char,
          level: level,
        );
      }).toList(),
    );
  }
}