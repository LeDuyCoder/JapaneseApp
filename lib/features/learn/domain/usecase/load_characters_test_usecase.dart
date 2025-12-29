import 'package:japaneseapp/core/Config/dataJson.dart';
import 'package:japaneseapp/features/learn/domain/entities/character_entity.dart';
import 'package:japaneseapp/features/learn/domain/entities/character_example.dart';
import 'package:japaneseapp/features/learn/domain/enum/type_test.dart';

class LoadCharactersTesUsecase{
  final TypeTest type;
  final int setLevel;

  LoadCharactersTesUsecase({required this.type, required this.setLevel});

  List<CharacterEntity> loadCharacters() {
    final List<CharacterEntity> listCharacters = [];

    // 1️⃣ xác định typeIndex
    final int typeIndex = type == TypeTest.katakana ? 1 : 0;

    // 2️⃣ flatten data 1 lần
    final dynamic dataJsonCharacters = dataJson.instance.data;
    final Map<String, dynamic> dataFlatten = {};

    for (int i = 0; i < 4; i++) {
      dataFlatten.addAll(dataJsonCharacters[typeIndex][i]);
    }

    List<List<String>> dataCharacterLearn = [];

    if(setLevel == 0){
      dataCharacterLearn.add(dataJsonCharacters[type == TypeTest.hiragana ? 2 : 3][0]);
    }else {
      for (var i = 0; i < (setLevel <= 24 ? setLevel : 24); i++) {
        dataCharacterLearn.add(dataJsonCharacters[type == TypeTest.hiragana ? 2 : 3][i]);
      }
    }

    // 3️⃣ duyệt dataCharacter
    for (final test in dataCharacterLearn) {
      for (final value in test) {
        final charData = dataFlatten[value];
        if (charData == null) continue;

        // build examples
        final List<CharacterExample> examples =
        (charData["example"] as List<Map<String, String>>)
            .map(
              (e) => CharacterExample(
            word: e.keys.first,
            mean: e.values.first,
          ),
        )
            .toList();

        listCharacters.add(
          CharacterEntity(
            character: charData["text"],
            romaji: charData["romaji"],
            examples: examples,
            pathImage: charData["image"]??"",
            level: charData["level"],
          ),
        );
      }
    }



    return listCharacters;
  }
}