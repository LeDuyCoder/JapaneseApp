import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

enum KeyFeature { timerView, readTesting }

class FeatureState {
  bool timerView;
  bool readTesting;

  FeatureState(this.timerView, this.readTesting);

  /// Chuyển object -> Map -> JSON string
  String toJsonString() {
    final map = {
      "timerView": timerView,
      "readTesting": readTesting,
    };
    return jsonEncode(map);
  }

  Future<bool> setStateFeture(KeyFeature key, bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if(key == KeyFeature.timerView){
      timerView = value;
    }else if(key == KeyFeature.readTesting){
      readTesting = value;
    }

    sharedPreferences.setString("feature", this.toJsonString());
    return true;
  }

  factory FeatureState.fromJsonString(String source) {
    final map = jsonDecode(source);
    return FeatureState(
      map["timerView"] as bool,
      map["readTesting"] as bool,
    );
  }

  Map<String, dynamic> toMap() => {
    "timerView": timerView,
    "readTesting": readTesting,
  };

  factory FeatureState.fromMap(Map<String, dynamic> map) {
    return FeatureState(
      map["timerView"] as bool,
      map["readTesting"] as bool,
    );
  }
}
