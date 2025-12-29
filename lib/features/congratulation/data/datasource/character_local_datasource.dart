import 'dart:convert';

import 'package:japaneseapp/core/service/Local/local_db_service.dart';
import 'package:japaneseapp/features/congratulation/domain/entities/character_enity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CharacterLocalDatasource{
  Future<void> updateProgressCharacterDB(String type, List<CharacterEntity> listCharacters) async {
    LocalDbService localDbService = LocalDbService.instance;
    for(CharacterEntity characterEntity in listCharacters){
      if(await localDbService.characterDao.isCharacterExist(characterEntity.character)){
        await localDbService.characterDao.increaseCharacterLevel(characterEntity.character, 1);
      }else{
        await localDbService.characterDao.insertCharacter(
            characterEntity.character,
            1, characterEntity.level, type);
      }
    }
  }

  Future<void> updateProgressCharacterSharedFile(String type, int level) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    dynamic data = jsonDecode(sharedPreferences.getString(type)!);

    data["level"] = data["level"]+1;
    if(data["level"] >= 7){
      data["levelSet"]++;
    }

    await sharedPreferences.setString(type, jsonEncode(data));
  }
}