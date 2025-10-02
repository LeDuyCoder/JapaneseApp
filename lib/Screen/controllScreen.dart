// ignore: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/Screen/loginScreen.dart';
import 'package:japaneseapp/Screen/tabScreen.dart';

class controllScreen extends StatelessWidget {
  final Function(Locale _locale) changeLanguage;

  const controllScreen({super.key, required this.changeLanguage});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, snapshot) {
        if(snapshot.hasData){
          return TabScreen(changeLanguage: changeLanguage,);
        }
        return loginScreen();
      },
    );
  }
}
