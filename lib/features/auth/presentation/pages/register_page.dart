import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/core/Utilities/SnackbarUtils.dart';
import '../../../../core/generated/app_localizations.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repasswordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isShowPass = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            SnackBarUtil.success(context, "Đăng Kí Thành Công");
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.pop(context);
              Navigator.pop(context);
            });
          } else if (state is AuthFailure) {
            SnackBarUtil.error(context, state.message.split(":")[1].trim());
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Container(
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
                            controller: _emailController,
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
                              errorText: (state is AuthFailure)?state.message.split(":")[1].trim():null,
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: TextField(
                            controller: _nameController,
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
                              errorText: (state is AuthFailure)?state.message.split(":")[1].trim():null,
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: TextField(
                            controller: _passwordController,
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
                              errorText: (state is AuthFailure)?state.message.split(":")[1].trim():null,
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
                            controller: _repasswordController,
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
                              errorText: (state is AuthFailure)?state.message.split(":")[1].trim():null,
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
                            if (_emailController.text.trim().isEmpty) {
                              SnackBarUtil.warning(context, "Vui lòng nhập email.");
                            } else if (!_emailController.text.contains('@')) {
                              SnackBarUtil.error(context, "Email không hợp lệ.");
                            } else if (_passwordController.text.isEmpty) {
                              SnackBarUtil.warning(context, "Vui lòng nhập mật khẩu.");
                            } else if (_passwordController.text.length < 6) {
                              SnackBarUtil.warning(context, "Mật khẩu phải có ít nhất 6 ký tự.");
                            } else if (_repasswordController.text.isEmpty) {
                              SnackBarUtil.warning(context, "Vui lòng nhập lại mật khẩu để xác nhận.");
                            } else if (_passwordController.text != _repasswordController.text) {
                              SnackBarUtil.error(context, "Mật khẩu xác nhận không khớp.");
                            } else {
                              // ✅ Gửi event đăng ký
                              context.read<AuthBloc>().add(
                                RegisterRequested(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text,
                                  name: _nameController.text.trim()
                                ),
                              );
                            }
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
                  if (state is AuthLoading)
                    ...[
                      Container(
                        width: MediaQuery.sizeOf(context).width,
                        height: MediaQuery.sizeOf(context).height,
                        color: Colors.grey.withOpacity(0.5),
                      ),

                      // Add this condition to show/hide loading
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
                    ]
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
