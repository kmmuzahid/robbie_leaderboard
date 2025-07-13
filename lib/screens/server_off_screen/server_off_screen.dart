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
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            color: AppColors.blue,
            height: MediaQuery.of(context).size.height, 
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextWidget(
                    text: "Oops! Sorry,",
                    fontColor: AppColors.white,
                    fontSize: 30,
                  ),
                  TextWidget(
                    text: "Server is now under maintenance",
                    fontColor: AppColors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
