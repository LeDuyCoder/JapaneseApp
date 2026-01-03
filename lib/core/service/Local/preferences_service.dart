import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  Future<void> initDefaults() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey("level")) {
      await prefs.setInt("level", 1);
      await prefs.setInt("exp", 0);
      await prefs.setInt("nextExp", 100);
    }

    if (!prefs.containsKey("Streak")) {
      await prefs.setInt("Streak", 0);
      await prefs.setString("lastCheckIn", '');
      await prefs.setStringList("checkInHistory", []);
    }

    if (!prefs.containsKey("achivement")) {
      await prefs.setStringList("achivement", []);
    }

    if(!prefs.containsKey("timeLearn")){
      await prefs.setInt("timeLearn", 0);
    }

    if(!prefs.containsKey("wordsRemember")){
      await prefs.setStringList("wordsRemember", []);
    }

    if(!prefs.containsKey("amountTop")){
      await prefs.setInt("amountTop", 0);
    }

    if(!prefs.containsKey("timeLearnFast")){
      await prefs.setInt("timeLearnFast", 0);
    }

    if(!prefs.containsKey("topicDowload")){
      await prefs.setInt("topicDowload", 0);
    }

    if (!prefs.containsKey("hiragana")) {
      await prefs.setString("hiragana", jsonEncode({"levelSet": 0, "level": 0}));
    }

    if (!prefs.containsKey("katakana")) {
      await prefs.setString("katakana", jsonEncode({"levelSet": 0, "level": 0}));
    }

    if(!prefs.containsKey("perrior_rank")){
      await prefs.setString("perrior_rank", "");
    }
  }
}
