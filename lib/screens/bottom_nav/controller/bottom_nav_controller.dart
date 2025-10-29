import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/screens/home_screen/controller/home_screen_controller.dart';
import 'package:the_leaderboard/screens/home_screen/home_screen.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/controller/leaderboard_controller.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/leaderboard_screen.dart';
import 'package:the_leaderboard/screens/profile_screen/controller/profile_screen_controller.dart';
import 'package:the_leaderboard/screens/rewards_screen/controller/rewards_screen_controller.dart';

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
      if (index == 0 && selectedIndex.value != index) {
        Get.find<HomeScreenController>().fetchData(isUpdating: true);
      } else if (index == 1 && selectedIndex.value != index) {
        Get.find<LeaderboardController>().fetchData(isUpdating: true);
      } else if (index == 2 && selectedIndex.value != index) {
        Get.find<RewardsScreenController>().fetchData(isUpdating: true);
      } else if (index == 3 && selectedIndex.value != index) {
        Get.find<ProfileScreenController>().fetchProfile(isUpdating: true);
      }
      selectedIndex.value = index;
      update();
    } catch (e) {
      debugPrint("error form $e");
    }
  }
}
