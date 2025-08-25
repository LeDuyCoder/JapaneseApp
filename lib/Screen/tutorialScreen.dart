import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:japaneseapp/Screen/tabScreen.dart';

import '../generated/app_localizations.dart';

class tutorialScreen extends StatefulWidget {
  final Function(Locale _locale) changeLanguage;

  const tutorialScreen({super.key, required this.changeLanguage});

  @override
  State<StatefulWidget> createState() => _tutorialScreen();

}

class _tutorialScreen extends State<tutorialScreen>{
  @override
  Widget build(BuildContext context) {
    List<PageViewModel> pages = [
      PageViewModel(
        title: AppLocalizations.of(context)!.tutorial_one_title,
        body: AppLocalizations.of(context)!.tutorial_one_content,
        image: Center(child: Image.asset("assets/tutorial/t0.png")),
        decoration: PageDecoration(
          imageFlex: 2,
          bodyFlex: 1,
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          bodyTextStyle: TextStyle(fontSize: 18),
          pageColor: Colors.white,
        ),
      ),
      PageViewModel(
        title: AppLocalizations.of(context)!.tutorial_two_title,
        body: AppLocalizations.of(context)!.tutorial_two_content,
        image: Center(child: Image.asset("assets/tutorial/t1.png")),
        decoration: PageDecoration(
          imageFlex: 2,
          bodyFlex: 1,
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          bodyTextStyle: TextStyle(fontSize: 18),
          pageColor: Colors.white,
        ),
      ),
      PageViewModel(
        title: AppLocalizations.of(context)!.tutorial_three_title,
        body: AppLocalizations.of(context)!.tutorial_three_content,
        image: Center(child: Image.asset("assets/tutorial/t2.png")),
        decoration: const PageDecoration(
          imageFlex: 2,
          bodyFlex: 1,
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          bodyTextStyle: TextStyle(fontSize: 18),
          pageColor: Colors.white,
        ),
      ),
      PageViewModel(
        title: AppLocalizations.of(context)!.tutorial_four_title,
        body: AppLocalizations.of(context)!.tutorial_four_content,
        image: Center(child: Image.asset("assets/tutorial/t3.png")),
        decoration: const PageDecoration(
          imageFlex: 2,
          bodyFlex: 1,
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          bodyTextStyle: TextStyle(fontSize: 18),
          pageColor: Colors.white,
        ),
      ),
      PageViewModel(
        title: AppLocalizations.of(context)!.tutorial_five_title,
        body: AppLocalizations.of(context)!.tutorial_five_content,
        image: Center(child: Image.asset("assets/tutorial/t4.png")),
        decoration: const PageDecoration(
          imageFlex: 2,
          bodyFlex: 1,
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          bodyTextStyle: TextStyle(fontSize: 18),
          pageColor: Colors.white,
        ),
      ),
      PageViewModel(
        title: AppLocalizations.of(context)!.tutorial_six_title,
        body: AppLocalizations.of(context)!.tutorial_six_content,
        image: Center(child: Image.asset("assets/tutorial/t5.png")),
        decoration: const PageDecoration(
          imageFlex: 2,
          bodyFlex: 1,
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          bodyTextStyle: TextStyle(fontSize: 18),
          pageColor: Colors.white,
        ),
      ),PageViewModel(
        title: AppLocalizations.of(context)!.tutorial_seven_title,
        body: AppLocalizations.of(context)!.tutorial_seven_content,
        image: Center(child: Image.asset("assets/tutorial/t6.png")),
        decoration: const PageDecoration(
          imageFlex: 2,
          bodyFlex: 1,
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          bodyTextStyle: TextStyle(fontSize: 18),
          pageColor: Colors.white,
        ),
      ),PageViewModel(
        title: AppLocalizations.of(context)!.tutorial_eight_title,
        body: AppLocalizations.of(context)!.tutorial_eight_content,
        image: Center(child: Image.asset("assets/tutorial/t7.png")),
        decoration: const PageDecoration(
          imageFlex: 2,
          bodyFlex: 1,
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          bodyTextStyle: TextStyle(fontSize: 18),
          pageColor: Colors.white,
        ),
      ),PageViewModel(
        title: AppLocalizations.of(context)!.tutorial_nice_title,
        body: AppLocalizations.of(context)!.tutorial_nice_content,
        image: Center(child: Image.asset("assets/tutorial/t8.png")),
        decoration: const PageDecoration(
          imageFlex: 2,
          bodyFlex: 1,
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          bodyTextStyle: TextStyle(fontSize: 18),
          pageColor: Colors.white,
        ),
      ),
    ];

    return Container(
      color: Colors.white,
      child: IntroductionScreen(
        globalBackgroundColor: Colors.white,
        pages: pages,
        onDone: () {
          // Khi nhấn "Done", chuyển tới màn hình chính của ứng dụng
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => TabScreen(changeLanguage: widget.changeLanguage,)),
          );
        },
        onSkip: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => TabScreen(changeLanguage: widget.changeLanguage,)),
          );
        },
        showSkipButton: true,
        skip: Text(AppLocalizations.of(context)!.tutorial_btn_skip, style: TextStyle(color: Colors.green),),
        next: Text(AppLocalizations.of(context)!.tutorial_btn_forward, style: TextStyle(color: Colors.green)),
        done: Text("Done", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
        dotsDecorator: const DotsDecorator(
          size: Size(10.0, 10.0),
          activeSize: Size(25.0, 10.0),
          activeColor: Colors.green,
          color: Colors.black26,
          spacing: EdgeInsets.symmetric(horizontal: 1.0),
        ),
      ),
    );
  }

}