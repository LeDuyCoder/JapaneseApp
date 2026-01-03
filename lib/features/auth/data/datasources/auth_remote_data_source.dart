import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:japaneseapp/core/service/FunctionService.dart';
import 'package:japaneseapp/core/service/Server/ServiceLocator.dart';

import '../models/user_model.dart';

class AuthRemoteDataSource {

  List<String> _convertToListString(dynamic list) {
    if (list == null) return [];
    return List<String>.from(list.map((item) => item.toString()));
  }

  Future<void> addUser() async{
    ServiceLocator.userService.addUser(FirebaseAuth.instance.currentUser!.uid,
        FirebaseAuth.instance.currentUser!.displayName!);
  }

  Future<UserModel> login({required String email, required String password}) async {
    try {
      // Attempt sign in
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = FirebaseAuth.instance.currentUser;

      if(user != null){
        await FunctionService.asynchronyData();
      }

      return UserModel(id: user!.uid, email: user.email??'', name: user.displayName);


    } on FirebaseAuthException catch (exception) {
      throw Exception("Email hoặc Mật Khẩu Không Đúng");
    }
  }

  Future<UserModel> register({required String email, required String password, String? name}) async {
    try{

      // Create user with email and password
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: email.trim(),
          password: password
      );

      await userCredential.user?.updateDisplayName(name?.trim());

      // You might want to add additional user data to Firestore here
      // Example:
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({
        'username': name?.trim(),
        'email': email.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      UserModel userModel = new UserModel(id: userCredential.user!.uid, email: email, name: name);
      addUser();

      //showDialogRegisterSuccess();
      return userModel;
    }on FirebaseAuthException catch (e) {
      throw new Exception("Đăng ký thất bại, vui lòng kiểm tra lại thông tin.");
    } on FirebaseException catch (e) {
      String _mapFirestoreErrorToMessage(String code) {
        switch (code) {
          case 'permission-denied':
            return 'Bạn không có quyền thực hiện thao tác này.';
          case 'unavailable':
            return 'Máy chủ Firestore tạm thời không khả dụng, vui lòng thử lại sau.';
          case 'not-found':
            return 'Không tìm thấy dữ liệu yêu cầu.';
          case 'already-exists':
            return 'Dữ liệu đã tồn tại.';
          case 'unauthenticated':
            return 'Vui lòng đăng nhập lại để tiếp tục.';
          default:
            return 'Đã xảy ra lỗi khi kết nối đến máy chủ, vui lòng thử lại.';
        }
      }
      throw new Exception(_mapFirestoreErrorToMessage);
    } catch (e) {
      throw new Exception(e);
    }
  }
}

