import 'package:firebase_auth/firebase_auth.dart';
import 'package:japaneseapp/core/Service/Server/ServiceLocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/user_model.dart';

class UserRemoteDataSource {
  Future<void> setRoleinStorage(String role) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("Role", role);
  }

  Future<UserModel> getUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final data = await ServiceLocator.userService.getUser(uid)
        .timeout(const Duration(seconds: 10));
    await setRoleinStorage(data.role.toText());
    return data;
  }
}
