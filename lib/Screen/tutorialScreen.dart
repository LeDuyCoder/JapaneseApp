import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
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
        title: "Cài Đặt Ứng Dụng Gboard",
        body: "Hãy đảm bảo thiết bị của bạn đã cài đặt ứng dụng Gboard",
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
        title: "Vào Ứng Dụng Setting",
        body: "Bạn hãy vào ứng dụng setting để thiết lập bàn phìm học viết tiếng nhật",
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
        title: "Tìm Kiếm Gboard",
        body: "Bạn hãy bấm tìm và tìm đến Gboard như trên ảnh",
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
        title: "Gboard",
        body: "Tiếp tục click vào theo như hướng dẫn",
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
        title: "Languages",
        body: "Hãy bấm vào phần ngôn ngữ",
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
        title: "ADD KEYBOARD",
        body: "Bấm vô thêm bàn phìm để thêm bàn phím tiếng nhật",
        image: Center(child: Image.asset("assets/tutorial/t5.png")),
        decoration: const PageDecoration(
          imageFlex: 2,
          bodyFlex: 1,
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          bodyTextStyle: TextStyle(fontSize: 18),
          pageColor: Colors.white,
        ),
      ),PageViewModel(
        title: "Search Japanese",
        body: "Hãy bấm tìm kiếm ngôn ngữ tiếng nhật",
        image: Center(child: Image.asset("assets/tutorial/t6.png")),
        decoration: const PageDecoration(
          imageFlex: 2,
          bodyFlex: 1,
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          bodyTextStyle: TextStyle(fontSize: 18),
          pageColor: Colors.white,
        ),
      ),PageViewModel(
        title: "Handwriting",
        body: "Hãy chọn dạng bàn phím viết và bấm done",
        image: Center(child: Image.asset("assets/tutorial/t7.png")),
        decoration: const PageDecoration(
          imageFlex: 2,
          bodyFlex: 1,
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          bodyTextStyle: TextStyle(fontSize: 18),
          pageColor: Colors.white,
        ),
      ),PageViewModel(
        title: "Change Keyboard",
        body: "Khi học viết nhớ chuyển sang bàn phím để tập viết để nhớ tốt hơn",
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
            MaterialPageRoute(builder: (_) => TabScreen()),
          );
        },
        onSkip: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => TabScreen()),
          );
        },
        showSkipButton: true,
        skip: Text("Skip", style: TextStyle(color: Colors.green),),
        next: Text("Next", style: TextStyle(color: Colors.green)),
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