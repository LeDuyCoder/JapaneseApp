import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/Screen/charactersScreen.dart';
import 'package:japaneseapp/Screen/dashboardScreen.dart';
import 'package:japaneseapp/Screen/profileScreen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../generated/app_localizations.dart';
import 'addFolderScreen.dart';

class TabScreen extends StatefulWidget {
  final Function(Locale _locale) changeLanguage;

  const TabScreen({super.key, required this.changeLanguage});

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _selectedIndex = 0;
  late PageController _pageController;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _screens = [
      dashboardScreen(key: dashboardScreen.globalKey, changeLanguage: widget.changeLanguage,),
      charactersScreen(),
      profileScreen(changeLanguage: widget.changeLanguage,)
    ];
  }

  void _showBottomMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(232, 232, 232, 0.4),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListTile(
                      leading:
                      const Icon(Icons.menu_book, color: Color(0xFF2E7D32)),
                      title: const Text("Học phần",
                          style: TextStyle(color: Colors.black, fontSize: 18)),
                      onTap: () {
                        Navigator.pop(context);
                        dashboardScreen.globalKey.currentState
                            ?.showPopupAddTopic();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(232, 232, 232, 0.4),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListTile(
                      leading:
                      const Icon(Icons.folder_open, color: Color(0xFF2E7D32)),
                      title: const Text("Thư Mục",
                          style: TextStyle(color: Colors.black, fontSize: 18)),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) =>
                                addFolderScreen(
                                  reloadScreen: () {},
                                ),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin = Offset(0.0, 1.0);
                              const end = Offset.zero;
                              const curve = Curves.ease;
                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));
                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      _showBottomMenu(context);
    } else {
      setState(() {
        _selectedIndex = index;
      });
      _pageController.animateToPage(
        index-1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // user ko vuốt ngang
        children: _screens,
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade300, width: 3),
          ),
        ),
        child: SalomonBottomBar(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.home, size: 30),
              title:  Text(AppLocalizations.of(context)!.tabbar_home,),
              selectedColor: Colors.green,
              unselectedColor: Colors.grey,
            ),
            SalomonBottomBarItem(
              selectedColor: Colors.green,
              icon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    child: const Center(
                      child: Icon(Icons.add, size: 35, color: Colors.black),
                    ),
                  ),
                ],
              ),
              title: const Text("Thêm Mới"),
            ),
            SalomonBottomBarItem(
              icon: const Text("あ",
                  style: TextStyle(
                      fontSize: 22, color: Colors.grey, fontWeight: FontWeight.bold)),
              activeIcon: const Text("あ",
                  style: TextStyle(
                      fontSize: 22, color: Colors.green, fontWeight: FontWeight.bold)),
              title: Text(AppLocalizations.of(context)!.tabbar_character),
              selectedColor: Colors.green,
              unselectedColor: Colors.grey,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.person, size: 30),
              title: Text(AppLocalizations.of(context)!.tabbar_info),
              selectedColor: Colors.green,
              unselectedColor: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
