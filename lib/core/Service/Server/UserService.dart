import 'package:japaneseapp/core/DTO/UserDTO.dart';
import 'package:japaneseapp/features/dashboard/domain/models/user_model.dart';

import '../BaseService.dart';
import 'ScoreService.dart';

class UserService extends BaseService {

  /// Add new user
  Future<void> addUser(String idUser, String name) async {

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

  Future<UserModel> getUser(String userId) async {
    final data = await postForm("/controller/user/getUser.php", {
      'idUser': userId,
    });

    if (data is Map<String, dynamic>) {

      return UserModel.fromJson(data["data"]);
    } else {
      throw Exception('Invalid coin data format');
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

  Future<void> reduceCoin(String idUser, int coin) async {
    await postForm('/controller/user/removeCoin.php', {
      'idUser': idUser,
      'coint': coin.toString(), // Note: typo in original API
    });
  }

  Future<void> updateFrameUser(String idUser, String idFrame) async{
    print(idFrame);
    await postForm('/controller/user/updateAvatarFrame.php', {
      'idUser': idUser,
      if(idFrame != '')
        'frameId': idFrame
    });
  }
  
  Future<void> updateAvatarUser(String idUser, String idAvatar) async {
    await postForm('/controller/user/updateAvatar.php', {
      'idUser': idUser,
      if(idAvatar != '')
        'avatarId': idAvatar
    });
  }
}