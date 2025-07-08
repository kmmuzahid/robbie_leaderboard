import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';

class LeaderboardTabBar extends StatelessWidget {
  final List<String> tabTexts;
  final TabController tabController;

  const LeaderboardTabBar({
    super.key,
    required this.tabTexts,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TabBar(
        dividerColor: Colors.transparent,
        controller: tabController,
        labelColor: Colors.black,
        unselectedLabelColor: AppColors.white,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        indicator: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              AppColors.gradientColorStart,
              AppColors.gradientColorEnd,
            ],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: tabTexts.map((text) => Tab(text: text)).toList(),
      ),
    );
  }
}
