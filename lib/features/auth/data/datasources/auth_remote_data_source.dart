import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:japaneseapp/core/Service/Local/local_db_service.dart';
import 'package:japaneseapp/core/Service/Server/ServiceLocator.dart';
import 'package:japaneseapp/core/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class AuthRemoteDataSource {

  List<String> _convertToListString(dynamic list) {
    if (list == null) return [];
    return List<String>.from(list.map((item) => item.toString()));
  }

  Future<void> updateAsynchronyData() async {
    final db = LocalDbService.instance;
    final prefs = await SharedPreferences.getInstance();

    try {
      // Lấy document trên Firestore
      final userDoc = FirebaseFirestore.instance
          .collection("datas")
          .doc(FirebaseAuth.instance.currentUser!.uid);

      final docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) {
        // Nếu chưa có data trên server thì tạo mặc định trong DB local
        await db.preferencesService.initDefaults();
        return;
      }

      final data = docSnapshot.data();
      if (data == null || data["data"] == null) {
        await db.preferencesService.initDefaults();
        return;
      }

      final Map<String, dynamic> dataMap = Map<String, dynamic>.from(data["data"]);

      // --- 1. Khôi phục SQLite ---
      final String sqliteData = dataMap["sqlite"] ?? "";
      if (sqliteData.isNotEmpty) {
        await db.syncDao.importSynchronyData(sqliteData);
      }

      // --- 2. Khôi phục SharedPreferences ---
      final Map<String, dynamic> dataPrefs =
      Map<String, dynamic>.from(dataMap["prefs"] ?? {});

      // ⚡ Không dùng prefs.clear() để tránh mất key khác, chỉ update key có
      if (dataPrefs.containsKey("level")) {
        await prefs.setInt("level", dataPrefs["level"]);
      }
      if (dataPrefs.containsKey("exp")) {
        await prefs.setInt("exp", dataPrefs["exp"]);
      }
      if (dataPrefs.containsKey("nextExp")) {
        await prefs.setInt("nextExp", dataPrefs["nextExp"]);
      }
      if (dataPrefs.containsKey("Streak")) {
        await prefs.setInt("Streak", dataPrefs["Streak"]);
      }
      if (dataPrefs.containsKey("lastCheckIn")) {
        await prefs.setString("lastCheckIn", dataPrefs["lastCheckIn"]);
      }
      if (dataPrefs.containsKey("checkInHistory")) {
        await prefs.setStringList(
          "checkInHistory",
          _convertToListString(dataPrefs["checkInHistory"]),
        );
      }
      if (dataPrefs.containsKey("checkInHistoryTreak")) {
        await prefs.setStringList(
          "checkInHistoryTreak",
          _convertToListString(dataPrefs["checkInHistoryTreak"]),
        );
      }
      if (dataPrefs.containsKey("achivement")) {
        await prefs.setStringList(
          "achivement",
          _convertToListString(dataPrefs["achivement"]),
        );
      }

      // --- 3. Tuỳ chọn: xoá doc sau khi tải về ---
      // await userDoc.delete();

      print("✅ UpdateAsynchronyData: dữ liệu đã được khôi phục thành công.");
    } catch (e, st) {
      print("❌ Error retrieving data: $e");
      debugPrintStack(stackTrace: st);
    }
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

      //userCredential.

      final user = FirebaseAuth.instance.currentUser;
      // TODO: addUser on database server

      if(user != null){
        await updateAsynchronyData();
      }

      return new UserModel(id: user!.uid, email: user.email??'', name: user.displayName);


    } on FirebaseAuthException catch (e) {
      throw new Exception("Email hoặc Mật Khẩu Không Đúng");
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

