import 'package:japaneseapp/features/congratulation/domain/entities/character_enity.dart';

abstract class CharacterRepository{
  Future<void> updateProgressCharacterDB(String type, List<CharacterEntity> listCharacters);
  Future<void> updateProgressCharacterSharedFile(String type, int level);
}