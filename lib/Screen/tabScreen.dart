import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:japaneseapp/Screen/charactersScreen.dart';
import 'package:japaneseapp/Screen/dashboardScreen.dart';
import 'package:japaneseapp/Screen/dictionaryScreen.dart';
import 'package:japaneseapp/Screen/profileScreen.dart';
import 'package:japaneseapp/Theme/colors.dart';
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
  late PageController _pageController;
  late final List<Widget> _screens = [
    dashboardScreen(key: dashboardScreen.globalKey, changeLanguage: widget.changeLanguage,),
    dictionaryScreen(),
    charactersScreen(),
    profileScreen(changeLanguage: widget.changeLanguage,)
  ];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
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
            crossAxisAlignment: CrossAxisAlignment.center,
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
                height: 85,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(232, 232, 232, 0.4),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      dashboardScreen.globalKey.currentState?.showPopupAddTopic();
                    },
                    child: Row(
                      children: [
                        SizedBox(width: 10,),
                        Icon(Icons.menu_book, color: Color(0xFF2E7D32)),
                        SizedBox(width: 10),
                        Text(AppLocalizations.of(context)!.add_course,
                            style: TextStyle(color: Colors.black, fontSize: 18)),
                      ],
                    ),
                )
              ),
              const SizedBox(height: 10),
              Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 85,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(232, 232, 232, 0.4),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: GestureDetector(
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
                    child: Row(
                      children: [
                        SizedBox(width: 10,),
                        const Icon(Icons.folder_open, color: Color(0xFF2E7D32)),
                        SizedBox(width: 10),
                        Text(AppLocalizations.of(context)!.add_folder,
                            style: TextStyle(color: Colors.black, fontSize: 18)),
                      ],
                    ),
                  )
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: (){
        setState((){
          _currentIndex = index;
          _pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.primary : Colors.grey,
            size: 24,
          ),

          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? AppColors.primary : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // user ko vuốt ngang
        children: _screens,
      ),
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          onPressed: () {
            _showBottomMenu(context);
          },
          backgroundColor: Colors.red,
          shape: const CircleBorder(
            side: BorderSide(
              color: Colors.white, // màu viền
              width: 5,            // độ dày viền
            ),
          ),
          child: const Icon(Icons.add, size: 35, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        height: 100,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, -2),
              blurRadius: 10
            )
          ]
        ),
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 5,
          color: Colors.white,
          child: Container(
            decoration: BoxDecoration(
            ),
            height: 65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home, AppLocalizations.of(context)!.tabbar_home, 0),
                _buildNavItem(Icons.menu_book, AppLocalizations.of(context)!.tabber_distionary, 1),
                const SizedBox(width: 40), // chừa chỗ cho FAB
                _buildNavItem(Icons.translate, AppLocalizations.of(context)!.tabbar_character, 2),
                _buildNavItem(Icons.person, AppLocalizations.of(context)!.tabbar_info, 3),
              ],
            ),
          ),
        )
      ),
    );
  }
}
