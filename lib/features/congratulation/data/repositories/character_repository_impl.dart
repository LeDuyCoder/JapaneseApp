import 'package:japaneseapp/features/congratulation/data/datasource/character_local_datasource.dart';
import 'package:japaneseapp/features/congratulation/domain/entities/character_enity.dart';
import 'package:japaneseapp/features/congratulation/domain/repositories/character_repository.dart';

class CharacterRepositoryImpl extends CharacterRepository{
  final CharacterLocalDatasource characterLocalDatasource;

  CharacterRepositoryImpl({required this.characterLocalDatasource});

  @override
  Future<void> updateProgressCharacterDB(String type, List<CharacterEntity> listCharacters) {
    return characterLocalDatasource.updateProgressCharacterDB(type, listCharacters);
  }

  @override
  Future<void> updateProgressCharacterSharedFile(String type, int level) {
    return characterLocalDatasource.updateProgressCharacterSharedFile(type, level);
  }
  
}