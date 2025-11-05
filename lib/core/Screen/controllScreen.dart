// ignore: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Screen/loginScreen.dart';
import 'package:japaneseapp/core/Screen/tabScreen.dart';
import 'package:japaneseapp/features/dashboard/presentaition/pages/dashboard_page.dart';

class controllScreen extends StatelessWidget {
  final Function(Locale _locale) changeLanguage;

  const controllScreen({super.key, required this.changeLanguage});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, snapshot) {
        if(snapshot.hasData){
          return DashboardPage(changeLanguage: changeLanguage,);
        }
        return loginScreen();
      },
    );
  }
}
