import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config{
  static String admodId = "ca-app-pub-1041515516282066/7437352253";
  static String admodRewardId = "ca-app-pub-3940256099942544/5224354917";//"ca-app-pub-1041515516282066/8577347956";

  static String get baseUrl => dotenv.env['BASE_URL'] ?? 'http://localhost/backend';

  // static String admodRewardId = "ca-app-pub-3940256099942544/5224354917";
}