import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/widgets/text_widget/text_widgets.dart';

class ServerOffScreen extends StatelessWidget {
  const ServerOffScreen({super.key});

  Future refresh() async {
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refresh,
        child: const Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextWidget(
              text: "Opps! Sorry,",
              fontColor: AppColors.black,
              fontSize: 30,
            ),
            TextWidget(
              text: "Server is now undermaintanence",
              fontColor: AppColors.black,
            ),
          ]),
        ),
      ),
    );
  }
}
