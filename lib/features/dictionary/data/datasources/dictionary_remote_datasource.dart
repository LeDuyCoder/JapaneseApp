import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:japaneseapp/core/Service/Local/local_db_service.dart';
import 'package:japaneseapp/features/dictionary/data/models/word_model.dart';
import 'package:japaneseapp/features/dictionary/domain/entities/word_entity.dart';
import 'package:language_detector/language_detector.dart';
import 'package:translator/translator.dart';

abstract class DictionaryRemoteDataSource {
  Future<String> generateExample(String word);
  Future<Map<dynamic, dynamic>?> searchWord(String word);
  Future<WordEntity> toggleBookmark(WordModel word);
}

class DictionaryRemoteDataSourceImpl implements DictionaryRemoteDataSource {
  DictionaryRemoteDataSourceImpl();

  @override
  Future<String> generateExample(String word) async {
    final String url = "https://tatoeba.org/en/api_v0/search?query=$word&from=jpn&to=vie";
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String ex = data["results"][0]["translations"][0].length == 0
            ? data["results"][0]["translations"][1][0]["text"]
            : data["results"][0]["translations"][0][0]["text"];

        return data["results"][0]["text"] + "- " + ex;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  Future<String> detectLanguage(String word) async{
    var code = await LanguageDetector.getLanguageCode(
        content: word);
    if(code == "vi"){
      return (await translateEnglish(word));
    }

    return word;
  }

  Future<String> translateEnglish(String input) async{
    try{
      final translator = GoogleTranslator();
      String translation = (await translator.translate(input, to: 'en')).toString();
      return translation;
    }catch(e){
      return input;
    }
  }

  Future<Map<String, dynamic>> fetchData(String word) async {
    String wordSearch = await detectLanguage(word);
    final String url = "https://jisho.org/api/v1/search/words?keyword=${wordSearch.toLowerCase()}"; // Thay URL API của bạn
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        int sizeArgs = (data["data"] as List<dynamic>).length;
        return sizeArgs > 0 ? data : null;
      } else {
        throw new Exception("No Data");
      }
    } catch (e) {
      throw new Exception("No Data");
    }
  }

  @override
  Future<Map<String, dynamic>?> searchWord(String query) async {
    String example = "";
    Map<String, dynamic> data = await fetchData(query);

    if(data.isEmpty){
      return null;
    }

    String word = (data["data"][0]["japanese"][0] as Map<String, dynamic>)
        .containsKey("word")
        ? data["data"][0]["japanese"][0]["word"]
        : data["data"][0]["slug"];

    example = await generateExample(word);
    final db = LocalDbService.instance;
    bool isExist = await db.vocabularyDao.isVocabularyExist(wordJp: word, wordKana: data["data"][0]["japanese"][0]["reading"]??"");
    List<String> anotherWords = [];

    for(dynamic item in data["data"]){
      anotherWords.add(item["slug"]);
    }

    anotherWords.removeAt(0);

    Map<String, dynamic> dataResult = {
      "word": word,
      "example": example,
      "stored": isExist,
      "jlpt": data["data"][0]["jlpt"] != null && (data["data"][0]["jlpt"] as List).isNotEmpty
          ? data["data"][0]["jlpt"][0]
          : "N5",
      "meaning": data["data"][0]["senses"][0]["english_definitions"],
      "reading": data["data"][0]["japanese"][0]["reading"],
      "tags": data["data"][0]["tags"],
      "anotherWord": anotherWords
    };
    return dataResult;

    // if (_isInterstitialAdReady && amountSearch >= 15) {
    //   _showInterstitialAd();
    // }
  }

  @override
  Future<WordEntity> toggleBookmark(WordEntity word) async {
    final db = LocalDbService.instance;
    await db.vocabularyDao.addVocabularyInDistionary(wordJp: word.word, wordKana: word.reading, wordMean: word.meaning, exampleJp: word.example.split("-")[0], exampleVi: word.example.split("-")[1]);
    word.isBookmarked = true;
    return word;
  }
}
