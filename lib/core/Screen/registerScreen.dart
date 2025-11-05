import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Service/Server/ServiceLocator.dart';
import '../generated/app_localizations.dart';

class registerScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _registerScreen();
}

class _registerScreen extends State<registerScreen>{

  bool _isShowPass = false;
  String? err_Password, err_RePass, err_Mail, err_Username;
  final mailController = TextEditingController(),
      userController = TextEditingController(),
      passController = TextEditingController(),
      rePassController = TextEditingController();
  bool _isLoading = false;

  Future<void> registerAccount() async {
    setState(() {
      _isLoading = true;
    });
    try {
      // Validate all fields are filled
      if (mailController.text.isEmpty ||
          userController.text.isEmpty ||
          passController.text.isEmpty ||
          rePassController.text.isEmpty) {

      }else{
        // Validate password match
        if (passController.text != rePassController.text) {
          String msg = 'Hai mật khẩu không giống nhau';
          setState(() {
            err_Password = msg;
            err_RePass = msg;
            _isLoading = false;
          });
        }else{
          if (passController.text.length < 6) {
            String msg = 'Mật khẩu phải có ít nhất 6 ký tự';
            err_Password = msg;
            _isLoading = false;
          }else{
            // Create user with email and password
            UserCredential userCredential = await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
              email: mailController.text.trim(),
              password: passController.text,
            );

            // Update user display name (optional)
            await userCredential.user?.updateDisplayName(userController.text.trim());

            // You might want to add additional user data to Firestore here
            // Example:
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userCredential.user?.uid)
                .set({
              'username': userController.text.trim(),
              'email': mailController.text.trim(),
              'createdAt': FieldValue.serverTimestamp(),
            });

            addUser();

            setState(() {
              _isLoading = false;
            });
            showDialogRegisterSuccess();
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = AppLocalizations.of(context)!.register_email_already_in_use;
          break;
        case 'invalid-email':
          errorMessage = AppLocalizations.of(context)!.register_invalid_email;
          break;
        case 'operation-not-allowed':
          errorMessage = AppLocalizations.of(context)!.register_operation_not_allowed;
          break;
        case 'weak-password':
          errorMessage = AppLocalizations.of(context)!.register_weak_password;
          break;
        default:
          errorMessage = AppLocalizations.of(context)!.register_error;
      }
      setState(() {
        err_Username = errorMessage;
        err_Mail = errorMessage;
        err_Password = errorMessage;
        err_RePass = errorMessage;
        _isLoading = false;
      });
    } catch (e) {
      // Re-throw any other errors
      throw e.toString();
    }
  }

  Future<void> addUser() async{
    ServiceLocator.userService.addUser(FirebaseAuth.instance.currentUser!.uid,
        FirebaseAuth.instance.currentUser!.displayName!);
  }

  void showDialogRegisterSuccess() {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Bo góc toàn popup
          ),
          child: Container(
            decoration: const BoxDecoration(
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Fit nội dung
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 50,
                ),
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(context)!.register_success,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Đóng dialog
                      Navigator.pop(context); // Quay về trước đó
                    },
                    child: const Text(
                      "Tiếp Tục",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
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
                      child: AutoSizeText(AppLocalizations.of(context)!.register_title, style: TextStyle(fontSize: MediaQuery.sizeOf(context).width*0.8, fontWeight: FontWeight.bold),),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextField(
                      controller: mailController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.register_email_input_hint,
                        hintText: AppLocalizations.of(context)!.register_email_input_hint_focus,
                        prefixIcon: Icon(Icons.mail),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.green, width: 2.0),
                        ),
                        errorText: err_Mail,
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextField(
                      controller: userController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.register_user_input_hint,
                        hintText: AppLocalizations.of(context)!.register_user_input_hint_focus,
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.green, width: 2.0),
                        ),
                        errorText: err_Username,
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextField(
                      controller: passController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.register_password_input_hint,
                        hintText: AppLocalizations.of(context)!.register_password_input_hint_focus,
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
                  const SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextField(
                      controller: rePassController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.register_re_password_input_hint,
                        hintText: AppLocalizations.of(context)!.register_re_password_input_hint_focus,
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
                        errorText: err_RePass,
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      obscureText: !_isShowPass,
                    ),
                  ),
                  const SizedBox(height: 20,),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      FocusScope.of(context).unfocus();
                      showDialogRegisterSuccess();
                      registerAccount();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Container(
                          height: MediaQuery.sizeOf(context).width*0.14,
                          width: MediaQuery.sizeOf(context).width,
                          decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.all(Radius.circular(15))
                          ),
                          child: Center(
                            child: Text(AppLocalizations.of(context)!.register_btn, style: TextStyle(color: Colors.white, fontSize: 20)),
                          )
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppLocalizations.of(context)!.register_question_login),
                        SizedBox(width: 5,),
                        Text(AppLocalizations.of(context)!.register_btn_login, style: TextStyle(color: CupertinoColors.activeBlue),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading)
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,
                color: Colors.grey.withOpacity(0.5),
              ),

            if (_isLoading) // Add this condition to show/hide loading
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  child: const CircularProgressIndicator(
                    color: Colors.green,
                    strokeWidth: 3,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}