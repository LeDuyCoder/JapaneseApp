import 'package:japaneseapp/features/dashboard/domain/models/user_model.dart';

abstract class DashboardRepository {
  Future<Map<String, dynamic>> getDashboardData(); // keys: "topic","folder","topicServer"
  Future<bool> downloadTopic(String id);
  Future<UserModel> getUserInfo();
}
