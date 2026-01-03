import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Theme/colors.dart';

class AchievementTabBar extends StatelessWidget {
  final TabController controller;

  const AchievementTabBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabAlignment: TabAlignment.start,
      controller: controller,
      isScrollable: true,
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: Colors.transparent,
      padding: EdgeInsets.zero,

      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(
          width: 2.5,
          color: AppColors.primary,
        ),
      ),
      labelColor: AppColors.primary,
      unselectedLabelColor: Colors.grey,

      labelStyle: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),

      tabs: const [
        Tab(text: "Tất cả"),
        Tab(text: "Đã mở"),
        Tab(text: "Chưa mở"),
      ],
    );
  }
}
