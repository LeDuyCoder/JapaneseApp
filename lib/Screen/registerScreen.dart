import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          String msg = 'Passwords do not match';
          setState(() {
            err_Password = msg;
            err_RePass = msg;
            _isLoading = false;
          });
        }else{
          if (passController.text.length < 6) {
            String msg = 'Password must be at least 6 characters';
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
          errorMessage = 'This email is already registered.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is invalid.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password accounts are not enabled.';
          break;
        case 'weak-password':
          errorMessage = 'The password is too weak.';
          break;
        default:
          errorMessage = 'An unknown error occurred.';
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

  void showDialogRegisterSuccess() {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ), // Bo góc popup
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.green, // Màu xanh cạnh trên ngoài cùng
                        width: 10.0, // Độ dày của cạnh trên
                      ),
                    ),
                  ),
                  child: Container(
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: MediaQuery.sizeOf(context).width - 100,
                              height: 30,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: AutoSizeText(
                                      "Tạo tài khoản thành công, quay lại trang đăng nhập", // Nội dung văn bản
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      maxLines: 2,
                                      style: TextStyle(fontFamily: "Itim", fontSize: 35),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: MediaQuery.sizeOf(context).width*0.3,
                                height: MediaQuery.sizeOf(context).height*0.04,
                                decoration: const BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    boxShadow: [
                                    ]
                                ),
                                child: const Center(
                                  child: Text("Tiếp Tục", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "Itim"),),
                                ),
                              ),

                            ),
                            SizedBox(width: 10,)
                          ],
                        ),
                        SizedBox(height: 10,)
                      ],
                    ),
                  )
              );
            },
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
                      child: AutoSizeText("Hello, Register to get started", style: TextStyle(fontSize: MediaQuery.sizeOf(context).width*0.8, fontFamily: "Itim"),),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextField(
                      controller: mailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your Email',
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
                        labelText: 'User Name',
                        hintText: 'Enter your User Name',
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
                  const SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextField(
                      controller: rePassController,
                      decoration: InputDecoration(
                        labelText: 'Re_Password',
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
                      //showDialogRegisterSuccess();
                      FocusScope.of(context).unfocus();
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
                            child: Text("REGISTER", style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "Itim")),
                          )
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
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