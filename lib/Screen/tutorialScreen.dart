import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:japaneseapp/Screen/dashboardScreen.dart';
import 'package:japaneseapp/Screen/tabScreen.dart';

class tutorialScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _tutorialScreen();

}

class _tutorialScreen extends State<tutorialScreen>{
  @override
  Widget build(BuildContext context) {
    List<PageViewModel> pages = [
      PageViewModel(
        title: "Welcome to Learn Japanese!",
        body: "Start Your Japanese Learning Journey!",
        image: Center(child: Image.asset("assets/storyset/pic1.png")),
        decoration: PageDecoration(
          imageFlex: 2,
          bodyFlex: 1,
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          bodyTextStyle: TextStyle(fontSize: 18),
          pageColor: Colors.white,
        ),
      ),
      PageViewModel(
        title: "Learn Vocabulary Easily",
        body: "Our app offers thematic vocabulary lessons to help you learn in a systematic and memorable way.",
        image: Center(child: Image.asset("assets/storyset/pic2.png")),
        decoration: const PageDecoration(
          imageFlex: 2,
          bodyFlex: 1,
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          bodyTextStyle: TextStyle(fontSize: 18),
          pageColor: Colors.white,
        ),
      ),
      PageViewModel(
        title: "Practice Listening and Pronunciation",
        body: "Enhance your listening skills and pronunciation with our method learn",
        image: Center(child: Image.asset("assets/storyset/pic3.png")),
        decoration: const PageDecoration(
          imageFlex: 2,
          bodyFlex: 1,
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          bodyTextStyle: TextStyle(fontSize: 18),
          pageColor: Colors.white,
        ),
      ),
      PageViewModel(
        title: "Practice with Quizzes",
        body: "My app has many methods of learning while studying to help you reduce boredom",
        image: Center(child: Image.asset("assets/storyset/pic4.png")),
        decoration: const PageDecoration(
          imageFlex: 2,
          bodyFlex: 1,
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          bodyTextStyle: TextStyle(fontSize: 18),
          pageColor: Colors.white,
        ),
      ),
      PageViewModel(
        title: "Ready to Start?",
        body: "Explore and learn Japanese anytime, anywhere. Start your journey now!",
        image: Center(child: Image.asset("assets/storyset/pic6.png")),
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
            MaterialPageRoute(builder: (_) => TabScreen()),
          );
        },
        onSkip: () {
          // Khi nhấn "Skip", chuyển tới màn hình chính của ứng dụng
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => TabScreen()),
          );
        },
        showSkipButton: true,
        skip: Text("Skip"),
        next: Text("Next"),
        done: Text("Done", style: TextStyle(fontWeight: FontWeight.bold)),
        dotsDecorator: const DotsDecorator(
          size: Size(10.0, 10.0),
          activeSize: Size(22.0, 10.0),
          activeColor: Colors.blue,
          color: Colors.black26,
          spacing: EdgeInsets.symmetric(horizontal: 3.0),
        ),
      ),
    );
  }

}