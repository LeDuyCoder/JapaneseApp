import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:japaneseapp/core/Screen/registerScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Service/Local/local_db_service.dart';
import '../Service/Server/ServiceLocator.dart';
import '../Theme/colors.dart';
import '../generated/app_localizations.dart';

class loginScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _loginScreen();
}

class _loginScreen extends State<loginScreen>{
  bool _isShowPass = false;
  String? err_Password, err_mail;
  Map<String, dynamic>? _userData;
  final TextEditingController mailController = TextEditingController(),
                        passController = TextEditingController();
  static String? typeLogin;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential> signInFacebook() async {
    try {
      // Start Facebook login
      final LoginResult loginResult = await FacebookAuth.instance.login(permissions: ['email']);

      // Check if login was successful
      if (loginResult.status == LoginStatus.success) {
        // Get user data
        final userData = await FacebookAuth.instance.getUserData();
        _userData = userData;
        typeLogin = "facebook";

        // Create an OAuthCredential from the access token
        final OAuthCredential oAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

        UserCredential result = await FirebaseAuth.instance.signInWithCredential(oAuthCredential);
        await updateAsynchronyData();

        // Sign in to Firebase with the credential
        return result;
      } else {
        throw Exception('Facebook login failed');
      }
    } catch (e) {
      throw Exception('Error during Facebook login: $e');
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      // Bước 1: Người dùng đăng nhập Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // Người dùng hủy đăng nhập
        return null;
      }

      // Bước 2: Lấy thông tin xác thực (authentication) từ Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Bước 3: Tạo credential Firebase bằng token Google
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Bước 4: Đăng nhập Firebase với credential Google
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // Bước 5: Lấy User từ Firebase sau khi đăng nhập thành công
      final User? user = userCredential.user;
      await updateAsynchronyData();
      await addUser();
      return user;
    } catch (error) {
      print('Lỗi đăng nhập Google: $error');
      return null;
    }
  }

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
    if(FirebaseAuth.instance.currentUser != null) {
      print("demo addUsser");
      ServiceLocator.userService.addUser(FirebaseAuth.instance.currentUser!.uid,
          FirebaseAuth.instance.currentUser!.displayName!);
    }
  }

  Future<void> signInEmail() async {
    // Reset error messages
    setState(() {
      err_mail = null;
      err_Password = null;
    });

    // Validate email
    if (mailController.text.isEmpty) {
      setState(() {
        err_mail = "Email không được để trống";
      });
      return;
    }

    // Validate password
    if (passController.text.isEmpty) {
      setState(() {
        err_Password = "Password không được để trống";
      });
      return;
    }

    try {
      // Attempt sign in
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: mailController.text.trim(),
        password: passController.text,
      );

      final user = FirebaseAuth.instance.currentUser;

       await addUser();

      if (user != null) {
        await updateAsynchronyData();
        _userData = {
          'email': user.email,
          // Các thông tin khác
        };

        typeLogin = "mail";
      }

    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase auth errors
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = AppLocalizations.of(context)!.login_invalid_email;
          break;
        case 'user-disabled':
          errorMessage = AppLocalizations.of(context)!.login_user_disabled;
          break;
        case 'user-not-found':
          errorMessage = AppLocalizations.of(context)!.login_user_not_found;
          break;
        case 'wrong-password':
          errorMessage = AppLocalizations.of(context)!.login_wrong_password;
          break;
        default:
          errorMessage = AppLocalizations.of(context)!.login_error;
      }

      setState(() {
        err_Password = errorMessage;
      });
    } catch (e) {
      // Handle other errors
      setState(() {
        err_Password = "Có lỗi xảy ra: $e";
      });
    } finally {
      // Hide loading indicator
      if (mounted) {
        // setState(() {
        //   isLoading = false;
        // });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height*0.1,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 20),
              child: Container(
                height: MediaQuery.sizeOf(context).height*0.1,
                width: MediaQuery.sizeOf(context).width,
                child: AutoSizeText(AppLocalizations.of(context)!.login_title, style: TextStyle(fontSize: MediaQuery.sizeOf(context).width*0.8, fontFamily: "Itim"),),
              ),
            ),

            SizedBox(height: 20,),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: mailController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.login_email_input_hint,
                  hintText: 'Nhập email của bạn',
                  prefixIcon: Icon(Icons.mail),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.green, width: 2.0),
                  ),
                  errorText: err_mail,
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: passController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.login_email_input_password,
                  hintText: 'Nhập Mật Khẩu',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_isShowPass ? Icons.visibility : Icons.visibility_off),
                    onPressed: (){
                      setState(() {
                        _isShowPass = !_isShowPass;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.green, width: 2.0),
                  ),
                  errorText: err_Password,
                  filled: true,
                  fillColor: Colors.white,
                ),
                obscureText: !_isShowPass,
              ),
            ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: (){
                signInEmail();
              },
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Container(
                    height: MediaQuery.sizeOf(context).width*0.14,
                    width: MediaQuery.sizeOf(context).width,
                    decoration: const BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.all(Radius.circular(15))
                    ),
                    child: Center(
                      child: Text(AppLocalizations.of(context)!.login_btn, style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "Itim")),
                    )
                ),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (ctx)=>registerScreen()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${AppLocalizations.of(context)!.login_create_question_account} ", style: TextStyle(fontFamily: "Itim"),),
                  SizedBox(width: 2,),
                  Text(AppLocalizations.of(context)!.login_create_btn_account, style: TextStyle(color: CupertinoColors.activeBlue, fontFamily: "Itim"),),
                ],
              ),
            ),
            const SizedBox(height: 10,),
            const Center(
              child: Text("________ OR ________", style: TextStyle(fontFamily: "Itim", color: Colors.grey, fontSize: 20),),
            ),
            // SizedBox(height: 10,),
            // GestureDetector(
            //   onTap: (){
            //     signInFacebook();
            //   },
            //   child: Padding(
            //     padding: EdgeInsets.only(left: 20, right: 20),
            //     child: Container(
            //         height: MediaQuery.sizeOf(context).width*0.14,
            //         width: MediaQuery.sizeOf(context).width,
            //         decoration: BoxDecoration(
            //             color: Colors.white,
            //             border: Border.all(
            //                 color: Colors.grey
            //             ),
            //             borderRadius: BorderRadius.all(Radius.circular(15))
            //         ),
            //         child: Center(
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //                 const Icon(Icons.facebook_outlined, color: Colors.blue,),
            //                 const SizedBox(width: 10,),
            //                 Text(AppLocalizations.of(context)!.login_with_facebook, style: TextStyle(fontFamily: "Itim"),)
            //               ],
            //             )
            //         )
            //     ),
            //   ),
            // ),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: (){
                signInWithGoogle();
              },
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Container(
                    height: MediaQuery.sizeOf(context).width*0.14,
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: Colors.grey
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15))
                    ),
                    child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/logo_google.png", width: 24, height: 24),
                            SizedBox(width: 10,),
                            Text(AppLocalizations.of(context)!.login_with_google, style: TextStyle(fontFamily: "Itim"),)
                          ],
                        )
                    )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}