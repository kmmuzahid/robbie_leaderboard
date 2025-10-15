import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/screens/home_screen/controller/home_screen_controller.dart';

class FloatingButtonWidget extends StatelessWidget {
  const FloatingButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeScreenController>();
    return IconButton(
        iconSize: 35,
        style: IconButton.styleFrom(backgroundColor: AppColors.goldLight),
        onPressed: controller.initialize,
        icon: const Icon(Icons.add));
  }

  
  
}
