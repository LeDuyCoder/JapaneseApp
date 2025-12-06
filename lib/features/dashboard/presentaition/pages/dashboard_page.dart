import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/core/Screen/addFolderScreen.dart';
import 'package:japaneseapp/core/Screen/charactersScreen.dart';
import 'package:japaneseapp/core/Screen/profileScreen.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/core/generated/app_localizations.dart';
import 'package:japaneseapp/features/dashboard/bloc/tab_bloc.dart';
import 'package:japaneseapp/features/dashboard/presentaition/pages/dictionary_page_provider.dart';
import 'package:japaneseapp/features/dashboard/presentaition/pages/tabhome_page.dart';
import 'package:japaneseapp/features/dashboard/presentaition/widgets/dashboard/add_topic_dialog.dart';
import 'package:japaneseapp/features/dictionary/presentation/pages/dictionary_page.dart';

class DashboardPage extends StatefulWidget {
  final Function(Locale _locale) changeLanguage;

  const DashboardPage({super.key, required this.changeLanguage});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      TabHomePage(),
      DictionaryPageProvider(),
      charactersScreen(),
      profileScreen(changeLanguage: widget.changeLanguage),
    ];

    return BlocProvider(
      create: (_) => TabCubit(),
      child: BlocBuilder<TabCubit, int>(
        builder: (context, currentIndex) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_pageController.hasClients) {
              _pageController.jumpToPage(currentIndex);
            }
          });

          return Scaffold(
            body: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: screens,
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.red,
              shape: const CircleBorder(side: BorderSide(color: Colors.white, width: 5)),
              onPressed: () => _showBottomMenu(context),
              child: const Icon(Icons.add, size: 35, color: Colors.white),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              notchMargin: 5,
              color: Colors.white,
              child: Container(
                height: 65,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(context, Icons.home, "Home", 0, currentIndex),
                    _buildNavItem(context, Icons.menu_book, "Dictionary", 1, currentIndex),
                    const SizedBox(width: 40),
                    _buildNavItem(context, Icons.translate, "Characters", 2, currentIndex),
                    _buildNavItem(context, Icons.person, "Profile", 3, currentIndex),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, int index, int currentIndex) {
    final isSelected = currentIndex == index;
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () => context.read<TabCubit>().changeTab(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? Colors.red : Colors.grey, size: 24),
          Text(label, style: TextStyle(fontSize: 12, color: isSelected ? Colors.red : Colors.grey)),
        ],
      ),
    );
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
                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(2)),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => AddTopicDialog(),
                  );
                },
                child: _bottomItem(context, Icons.menu_book, AppLocalizations.of(context)!.add_course),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => addFolderScreen(reloadScreen: () {}),
                    ),
                  );
                },
                child: _bottomItem(context, Icons.folder_open, AppLocalizations.of(context)!.add_folder),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _bottomItem(BuildContext context, IconData icon, String text) {
    return Container(
      height: 85,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(232, 232, 232, 0.4),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(color: Colors.black, fontSize: 18)),
        ],
      ),
    );
  }
}
