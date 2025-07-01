import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/widgets/button_widget/button_widget.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../routes/app_routes.dart';
import '../../widgets/gradient_text_widget/gradient_text_widget.dart';
import '../../widgets/space_widget/space_widget.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.blueDark,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: GradientText(
                  text: AppStrings.leaderboard,
                  fontWeight: FontWeight.w600,
                  fontSize: 32,
                ),
              ),
              const SpaceWidget(spaceHeight: 16),
              const Center(
                child: GradientText(
                  text: AppStrings.description1,
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  maxLines: 6,
                  textAlign: TextAlign.justify,
                ),
              ),
              const SpaceWidget(spaceHeight: 16),
              const Center(
                child: GradientText(
                  text: AppStrings.description2,
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  maxLines: 6,
                  textAlign: TextAlign.justify,
                ),
              ),
              const SpaceWidget(spaceHeight: 16),
              const Center(
                child: GradientText(
                  text: AppStrings.description3,
                  maxLines: 2,
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  textAlign: TextAlign.justify,
                ),
              ),
              const SpaceWidget(spaceHeight: 96),
              ButtonWidget(
                onPressed: () {
                  Get.toNamed(AppRoutes.loginScreen);
                },
                label: AppStrings.start,
                buttonWidth: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
