import 'package:japaneseapp/features/dashboard/domain/models/user_model.dart';

abstract class TabHomeRepository {
  Future<Map<String, dynamic>> getTabHomeData(); // keys: "topic","folder","topicServer"
  Future<bool> downloadTopic(String id);
  Future<UserModel> getUserInfo();
}
