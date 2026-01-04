import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/features/dashboard/domain/models/user_model.dart';
import 'package:japaneseapp/features/navigator_hub/presentation/feature_screen.dart';

class AppSection extends StatelessWidget {
  final UserModel? user;

  const AppSection({super.key, required this.user});

  String getUserName() {
    User? user = FirebaseAuth.instance.currentUser;
    String fullname = user?.displayName ?? "";
    if (fullname.trim().isEmpty) return "";
    List<String> parts = fullname.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    } else {
      String first = parts[parts.length - 2][0].toUpperCase();
      String second = parts.last[0].toUpperCase();
      return first + second;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "KujiLingo",
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 40,
              fontFamily: "",
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FeatureScreen(userModel: user!, reload: () {},
                      )));
            },
            child: SizedBox(
              width: 80,
              height: 80,
              child: Stack(
                alignment: Alignment.center, // căn tất cả vào tâm
                children: [
                  // Frame nếu có
                  (user!.urlAvatar == '')
                      ? Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                    child: Center(
                      child: Text(
                        getUserName(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                      : ClipOval(
                    child: Image.network(
                      user!.urlAvatar,
                      width: 65,
                      height: 65,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (user!.urlFrame != '')
                    Image.network(
                      user!.urlFrame,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}