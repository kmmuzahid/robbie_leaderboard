import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/widgets/button_widget/button_widget.dart';
import 'package:the_leaderboard/widgets/space_widget/space_widget.dart';
import 'package:the_leaderboard/widgets/text_widget/text_widgets.dart';

class ServerOffScreen extends StatelessWidget {
  const ServerOffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.blue,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const TextWidget(
                text: "Oops!",
                fontColor: AppColors.white,
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
              const TextWidget(
                text: "Something went wrong.",
                fontColor: AppColors.white,
                fontSize: 20,
              ),
              const SpaceWidget(spaceHeight: 20),
              const TextWidget(
                text: "It could be a connection issue,",
                fontColor: AppColors.white,
                fontSize: 15,
              ),
              const TextWidget(
                text: "or the server might be under maintenance.",
                fontColor: AppColors.white,
                fontSize: 15,
              ),
              const SpaceWidget(spaceHeight: 30),
              ButtonWidget(
                label: "Try Again",
                onPressed: () => Get.back(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
