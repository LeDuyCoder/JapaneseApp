import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/core/Service/Server/ServiceLocator.dart';
import 'package:japaneseapp/core/Service/Local/local_db_service.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/core/Utilities/SnackbarUtils.dart';
import 'package:japaneseapp/core/generated/app_localizations.dart';
import 'package:japaneseapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:japaneseapp/features/auth/presentation/bloc/auth_event.dart';
import 'package:japaneseapp/features/auth/presentation/bloc/auth_state.dart';
import 'package:japaneseapp/features/auth/presentation/pages/register_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isShowPass = false;

  final _googleSignIn = GoogleSignIn();

  Future<User?> _signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      final user = userCredential.user;
      if (user != null) {
        await _updateAsynchronyData();
        await _addUser();
        SnackBarUtil.success(context, "Đăng nhập Google thành công");
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pushReplacementNamed('/home');
        });
      }
      return user;
    } catch (e) {
      SnackBarUtil.error(context, "Lỗi đăng nhập Google: $e");
      return null;
    }
  }

  Future<void> _updateAsynchronyData() async {
    final db = LocalDbService.instance;
    final prefs = await SharedPreferences.getInstance();

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection("datas")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (!userDoc.exists) {
        await db.preferencesService.initDefaults();
        return;
      }

      final data = userDoc.data()?["data"] ?? {};
      final dataMap = Map<String, dynamic>.from(data);

      final sqliteData = dataMap["sqlite"] ?? "";
      if (sqliteData.isNotEmpty) {
        await db.syncDao.importSynchronyData(sqliteData);
      }

      final dataPrefs = Map<String, dynamic>.from(dataMap["prefs"] ?? {});
      for (final key in dataPrefs.keys) {
        final value = dataPrefs[key];
        if (value is int) prefs.setInt(key, value);
        if (value is String) prefs.setString(key, value);
        if (value is List) prefs.setStringList(key, value.map((e) => e.toString()).toList());
      }

      debugPrint("✅ Dữ liệu đã khôi phục thành công");
    } catch (e) {
      debugPrint("❌ Lỗi khôi phục dữ liệu: $e");
    }
  }

  Future<void> _addUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await ServiceLocator.userService.addUser(user.uid, user.displayName ?? "Người dùng");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          SnackBarUtil.success(context, "Đăng nhập thành công");
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(context).pushReplacementNamed('/home');
          });
        } else if (state is AuthFailure) {
          SnackBarUtil.error(context, state.message);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            AutoSizeText(
              AppLocalizations.of(context)!.login_title,
              style: const TextStyle(fontSize: 30, fontFamily: "Itim"),
            ),
            const SizedBox(height: 30),
            _buildTextField(
              controller: _emailController,
              label: AppLocalizations.of(context)!.login_email_input_hint,
              icon: Icons.mail,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _passwordController,
              label: AppLocalizations.of(context)!.login_email_input_password,
              icon: Icons.lock,
              obscure: !_isShowPass,
              suffixIcon: IconButton(
                icon: Icon(_isShowPass ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _isShowPass = !_isShowPass),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                context.read<AuthBloc>().add(LoginRequested(
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim(),
                ));
              },
              child: Text(AppLocalizations.of(context)!.login_btn,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontFamily: "Itim")),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => RegisterPage()),
              ),
              child: Text(
                "${AppLocalizations.of(context)!.login_create_question_account} "
                    "${AppLocalizations.of(context)!.login_create_btn_account}",
                style: const TextStyle(
                  color: CupertinoColors.activeBlue,
                  fontFamily: "Itim",
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text("________ OR ________", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              icon: Image.asset("assets/logo_google.png", width: 24, height: 24),
              label: Text(AppLocalizations.of(context)!.login_with_google,
                  style: const TextStyle(fontFamily: "Itim")),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _signInWithGoogle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
