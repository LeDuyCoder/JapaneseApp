import '../BaseService.dart';
import 'ScoreService.dart';

class UserService extends BaseService {

  /// Add new user
  Future<void> addUser(String idUser, String name) async {
    print("Adding user...");

    try {
      await postForm('/controller/user/addUser.php', {
        'idUser': idUser,
        'name': name,
      });

      // Add initial score for new user
      final scoreService = ScoreService();
      await scoreService.addScore(idUser, 0);
    } catch (e) {
      rethrow;
    }
  }

  /// Get user coins
  Future<int> getCoin(String idUser) async {
    final data = await postForm('/controller/user/getCoin.php', {
      'idUser': idUser,
    });

    if (data is Map<String, dynamic> && data.containsKey('coins')) {
      return data['coins'];
    } else {
      throw Exception('Invalid coin data format');
    }
  }

  /// Add coins to user
  Future<void> addCoin(String idUser, int coin) async {
    await postForm('/controller/user/addCoin.php', {
      'idUser': idUser,
      'coint': coin.toString(), // Note: typo in original API
    });
    print("✅ Add coin success");
  }
}