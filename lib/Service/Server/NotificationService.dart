import '../../Module/notification.dart';
import '../../Utilities/WeekUtils.dart';
import '../BaseService.dart';

class Notificationservice extends BaseService {

  /// Get user score for a period
  Future<List<NotificationModel>> getAllNotification(String userId) async {
    final data = await get(
      '/controller/notification/getAllNotifications.php',
      queryParams: {
        'user_id': userId,
      },
    );

    if (data is Map<String, dynamic> && data["data"] is List) {
      final List<dynamic> jsonList = data["data"];
      print(jsonList);
      return jsonList.map((e) => NotificationModel.fromJson(e)).toList();
    } else {
      throw Exception('Dữ liệu trả về không hợp lệ');
    }
  }
}