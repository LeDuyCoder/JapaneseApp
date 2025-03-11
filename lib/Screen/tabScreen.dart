import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:japaneseapp/Screen/charactersScreen.dart';
import 'package:japaneseapp/Screen/dashboardScreen.dart';
import 'package:japaneseapp/Screen/miniGameScreen.dart';
import 'package:japaneseapp/Screen/profileScreen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    dashboardScreen(),
    miniGameScreen(),
    charactersScreen(),
    profileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(height: 80,
        decoration: BoxDecoration(
            color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade300, width: 3),  // Chỉnh màu viền trên
          ),
        ),
        child: SalomonBottomBar(
          margin: EdgeInsets.only(left: 10, right: 10),
          currentIndex: _selectedIndex,
          onTap: (i) => setState(() => _selectedIndex = i),
          items: [
            /// Home
            SalomonBottomBarItem(
              selectedColor: Colors.green,
              icon: Container(
                width: 30,
                height: 30,
                child: Center(
                  child: Image.asset("assets/tabbar/home.png", scale: 10.0,),
                ),
              ),
              title: Text("Trang Chính"),
            ),

            SalomonBottomBarItem(
              selectedColor: Colors.green,
              icon: Container(
                width: 30,
                height: 30,
                child: Center(
                  child: Image.asset("assets/tabbar/minigame.png", scale: 10.0,),
                ),
              ),
              title: Text("game"),
            ),


            SalomonBottomBarItem(
              selectedColor: Colors.green,
              icon: Container(
                width: 30,
                height: 30,
                child: Center(
                  child: Image.asset("assets/tabbar/alphabet.png", scale: 10.0,),
                ),
              ),
              title: Text("Bảng Chữ Cái"),
            ),
            /// Profile
            SalomonBottomBarItem(
              selectedColor: Colors.green,
              icon: Container(
                width: 30,
                height: 30,
                child: Center(
                  child: Image.asset("assets/tabbar/wizard.png", scale: 10.0,),
                ),
              ),
              title: Text("Thông Tin"),
            ),
          ],
        ),
      )
    );
  }
}