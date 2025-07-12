import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/screens/home_screen/home_screen.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/leaderboard_screen.dart';

import '../../profile_screen/profile_screen.dart';
import '../../rewards_screen/rewards_screen.dart';

class BottomNavController extends GetxController {
  var selectedIndex = 0.obs;

  final List<Widget> widgetOptions = [
    const HomeScreen(),
    const LeaderboardScreen(),
    const RewardsScreen(),
    const ProfileScreen(),
  ];

  void changeIndex(int index) {
    try {
      print("object");
      print(index);
      selectedIndex.value = index;
      update();
    } catch (e) {
      debugPrint("error form $e");
    }
  }
}
