import 'package:firebase_auth/firebase_auth.dart';
import 'package:japaneseapp/core/Service/Server/ServiceLocator.dart';
import '../../domain/models/user_model.dart';

class UserRemoteDataSource {
  Future<UserModel> getUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final data = await ServiceLocator.userService.getUser(uid)
        .timeout(const Duration(seconds: 10));
    return data;
  }
}
