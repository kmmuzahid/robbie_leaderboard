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
      height: 45, // This forces the exact height you want
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TabBar(
        controller: tabController,
        dividerColor: Colors.transparent,
        labelColor: Colors.black,
        unselectedLabelColor: AppColors.white,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),

        // Key settings to reduce height
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AppColors.gradientColorStart,
              AppColors.gradientColorEnd,
            ],
          ),
          borderRadius: BorderRadius.circular(8),
        ),

        // These two lines are what actually shrink the TabBar height
        padding: EdgeInsets.zero,
        labelPadding: EdgeInsets.zero,
        indicatorPadding: EdgeInsets.zero,

        // Optional: even tighter vertical spacing
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.all(Colors.transparent),

        tabs: tabTexts.asMap().entries.map((entry) {
          final index = entry.key;
          final text = entry.value;

          return Container(
            width: double.infinity,
            height: double.infinity, // Fill the 40px container
            alignment: Alignment.center,
            child: Text(text),
          );
        }).toList(),
      ),
    );
  }
}
