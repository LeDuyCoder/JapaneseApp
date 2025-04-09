import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:japaneseapp/Screen/registerScreen.dart';

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

        // Sign in to Firebase with the credential
        return await FirebaseAuth.instance.signInWithCredential(oAuthCredential);
      } else {
        // Print any errors if login was unsuccessful
        print('Facebook login failed: ${loginResult.message}');
        throw Exception('Facebook login failed');
      }
    } catch (e) {
      // Handle any errors
      print('Error during Facebook login: $e');
      throw Exception('Error during Facebook login: $e');
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
      if (user != null) {
        _userData = {
          'email': user.email,
          // Các thông tin khác
        };

        typeLogin = "mail";
      }


      // Success - navigation or other logic can be added here
      // For example:
      // Navigator.pushReplacementNamed(context, '/home');

    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase auth errors
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = "Email không hợp lệ";
          break;
        case 'user-disabled':
          errorMessage = "Tài khoản đã bị vô hiệu hóa";
          break;
        case 'user-not-found':
          errorMessage = "Không tìm thấy tài khoản với email này";
          break;
        case 'wrong-password':
          errorMessage = "Mật khẩu không đúng";
          break;
        default:
          errorMessage = "Đăng nhập thất bại: ${e.message}";
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
                child: AutoSizeText("Welcome back, Gad to see you", style: TextStyle(fontSize: MediaQuery.sizeOf(context).width*0.8, fontFamily: "Itim"),),
              ),
            ),

            SizedBox(height: 20,),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: mailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
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
                  labelText: 'Password',
                  hintText: 'Enter your password',
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
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(15))
                    ),
                    child: const Center(
                      child: Text("LOGIN", style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "Itim")),
                    )
                ),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (ctx)=>registerScreen()));
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? ", style: TextStyle(fontFamily: "Itim"),),
                  SizedBox(width: 2,),
                  Text("Register Now ", style: TextStyle(color: CupertinoColors.activeBlue, fontFamily: "Itim"),),
                ],
              ),
            ),
            const SizedBox(height: 10,),
            const Center(
              child: Text("________ OR ________", style: TextStyle(fontFamily: "Itim", color: Colors.grey, fontSize: 20),),
            ),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: (){
                signInFacebook();
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
                    child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.facebook_outlined, color: Colors.blue,),
                            SizedBox(width: 10,),
                            Text("Continue with Facebook", style: TextStyle(fontFamily: "Itim"),)
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