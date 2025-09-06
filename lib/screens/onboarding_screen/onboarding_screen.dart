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
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                    child: GradientText(
                      text: AppStrings.welComeToLeaderboard,
                      fontWeight: FontWeight.w600,
                      fontSize: 32,
                      maxLines: 3,
                    ),
                  ),
                  const SpaceWidget(spaceHeight: 40),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: GradientText(
                      text: AppStrings.leaderboardDescrition1,
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      maxLines: 6,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SpaceWidget(spaceHeight: 10),
                  const Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GradientText(
                          text: "• ",
                          fontWeight: FontWeight.w400,
                          fontSize: 30,
                          maxLines: 6,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: GradientText(
                            text: AppStrings.leaderboardDescrition2,
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            maxLines: 6,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SpaceWidget(spaceHeight: 10),
                  const Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GradientText(
                          text: "• ",
                          fontWeight: FontWeight.w400,
                          fontSize: 30,
                          maxLines: 6,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: GradientText(
                            text: AppStrings.leaderboardDescrition3,
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            maxLines: 6,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SpaceWidget(spaceHeight: 10),
                  const Row(
                    children: [
                      GradientText(
                        text: "• ",
                        fontWeight: FontWeight.w400,
                        fontSize: 30,
                        maxLines: 6,
                        textAlign: TextAlign.left,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: GradientText(
                            text: AppStrings.leaderboardDescrition4,
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            maxLines: 6,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SpaceWidget(spaceHeight: 10),
                  const Row(
                    children: [
                      GradientText(
                        text: "• ",
                        fontWeight: FontWeight.w400,
                        fontSize: 30,
                        maxLines: 6,
                        textAlign: TextAlign.left,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: GradientText(
                            text: AppStrings.leaderboardDescrition5,
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            maxLines: 6,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SpaceWidget(spaceHeight: 16),
                  // const Center(
                  //   child: GradientText(
                  //     text: AppStrings.description2,
                  //     fontWeight: FontWeight.w400,
                  //     fontSize: 15,
                  //     maxLines: 6,
                  //     textAlign: TextAlign.justify,
                  //   ),
                  // ),
                  // const SpaceWidget(spaceHeight: 16),
                  // const Center(
                  //   child: GradientText(
                  //     text: AppStrings.description3,
                  //     maxLines: 2,
                  //     fontWeight: FontWeight.w400,
                  //     fontSize: 15,
                  //     textAlign: TextAlign.justify,
                  //   ),
                  // ),
                  const SpaceWidget(spaceHeight: 70),
                  ButtonWidget(
                    onPressed: () {
                      Get.toNamed(AppRoutes.loginScreen);
                    },
                    label: AppStrings.accept,
                    buttonWidth: double.infinity,
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
