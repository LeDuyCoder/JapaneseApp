import 'package:firebase_auth/firebase_auth.dart';
import 'package:japaneseapp/core/Service/Server/ServiceLocator.dart';


class UserRemoteDatasource{

  /// Thêm `coin` cho user hiện tại.
  ///
  /// Tham số:
  /// - `coin`: số coin muốn cộng.
  ///
  /// Hành vi:
  /// - Lấy userId từ FirebaseAuth; nếu null sẽ ném `StateError`.
  /// - Gọi `userService.addCoin(userId, coin)`.
  /// - Nếu service ném lỗi, method sẽ ném `Exception` có thông tin lỗi.
  Future<void> addCoin(int coin) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    await ServiceLocator.userService.addCoin(userId, coin);
  }

  /// Thêm exp/rank cho user hiện tại.
  ///
  /// Tham số:
  /// - `exp`: số exp muốn cộng.
  ///
  /// Hành vi tương tự `addCoin`.
  Future<void> addExpRank(int exp) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    await ServiceLocator.scoreService.addScore(userId, exp);
  }
}