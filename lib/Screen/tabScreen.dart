import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:japaneseapp/Screen/dashboardScreen.dart';
import 'package:japaneseapp/Screen/miniGameScreen.dart';
import 'package:japaneseapp/Screen/profileScreen.dart';

class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    dashboardScreen(),
    miniGameScreen(),
    profileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 10, right: 10, left: 10),
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(60)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, -4),
                    blurRadius: 10
                )
              ]
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: GNav(
              rippleColor: Colors.grey.shade800,
              hoverColor: Colors.grey.shade700,
              haptic: true,
              tabBorderRadius: 20,
              tabActiveBorder: Border.all(color: Colors.grey, width: 1),
              tabBorder: Border.all(color: Colors.grey, width: 1),
              //tabShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 8)],
              curve: Curves.easeOutExpo,
              duration: Duration(milliseconds: 900),
              gap: 8,
              color: Colors.grey[800],
              activeColor: Colors.green,
              iconSize: 24,
              tabBackgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.videogame_asset_outlined,
                  text: 'Mini Game',
                ),
                GButton(
                  icon: Icons.person,
                  text: 'Profile',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      )
    );
  }
}