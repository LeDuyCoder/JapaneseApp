import 'package:japaneseapp/features/character/data/datasource/character_datasource.dart';
import 'package:japaneseapp/features/character/domain/entity/character_collection_entity.dart';
import 'package:japaneseapp/features/character/domain/entity/character_entity.dart';
import 'package:japaneseapp/features/character/domain/entity/character_group_entity.dart';
import 'package:japaneseapp/features/character/domain/repositories/character_repository.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterDatasource datasource;

  CharacterRepositoryImpl({required this.datasource});

  @override
  Future<CharacterCollectionEntity> loadCharacters({
    required String type,
    required List<Map<String, dynamic>> rawData,
  }) async {
    return datasource.loadCharacters(type: type, rawData: rawData);
  }

  @override
  CharacterGroupEntity mapGroup(
      CharacterGroupType type,
      Map<String, dynamic> rawGroup,
      Map<dynamic, dynamic>? progressGroup,
      ) {
    return datasource.mapGroup(type, rawGroup, progressGroup);
  }
}
