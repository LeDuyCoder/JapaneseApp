import 'package:firebase_auth/firebase_auth.dart';
import 'package:japaneseapp/core/service/Server/ServiceLocator.dart';
import 'package:japaneseapp/features/profile/domain/entities/user_entity.dart';
import 'package:japaneseapp/features/profile/domain/entities/wallet_entity.dart';

abstract class ProfileRemoteDataSource {
  Future<UserEntity> getUser();
  Future<WalletEntity> getWallet(String uid);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {

  @override
  Future<UserEntity> getUser() async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    final u = auth.currentUser!;
    return UserEntity(
      uid: u.uid,
      displayName: u.displayName,
      email: u.email,
    );
  }

  @override
  Future<WalletEntity> getWallet(String uid) async {
    final coin = await ServiceLocator.userService.getCoin(uid);
    return WalletEntity(coin);
  }
}
