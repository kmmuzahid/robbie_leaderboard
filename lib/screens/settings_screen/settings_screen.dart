import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_icon_path.dart';
import 'package:the_leaderboard/screens/settings_screen/widgets/settings_item_widget.dart';

import '../../constants/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../widgets/appbar_widget/appbar_widget.dart';
import '../../widgets/space_widget/space_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.blueDark,
        appBar: const AppbarWidget(title: "Settings", centerTitle: true),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              // Edit Profile
              SettingsItemWidget(
                title: "Edit Profile",
                icon: AppIconPath.editProfileIcon,
                onTap: () {
                  Get.toNamed(AppRoutes.editProfileScreen);
                },
              ),
              const SpaceWidget(spaceHeight: 8),
              // Frequently Asked Questions
              SettingsItemWidget(
                title: "Frequently Asked Questions",
                icon: AppIconPath.faqIcon,
                onTap: () {
                  Get.toNamed(AppRoutes.faqScreen);
                },
              ),
              const SpaceWidget(spaceHeight: 8),
              // Terms & Conditions
              SettingsItemWidget(
                title: "Terms & Conditions",
                icon: AppIconPath.termsIcon,
                onTap: () {
                  Get.toNamed(AppRoutes.termsAndConditionsScreen);
                },
              ),
              const SpaceWidget(spaceHeight: 8),
              // Report Problem
              SettingsItemWidget(
                title: "Report Problem",
                icon: AppIconPath.reportIcon,
                onTap: () {
                  Get.toNamed(AppRoutes.reportProblemsScreen);
                },
              ),
              // const SpaceWidget(spaceHeight: 8),
              // // Payment Method
              // SettingsItemWidget(
              //   title: "Payment Method",
              //   icon: AppIconPath.paymentIcon,
              //   onTap: () {
              //     Get.snackbar("Payment method is not set yet",
              //         "Please wait for the future update",
              //         colorText: AppColors.white);
              //   },
              // ),
              const SpaceWidget(spaceHeight: 8),
              // Change Password
              SettingsItemWidget(
                title: "Change password",
                icon: AppIconPath.changePWIcon,
                onTap: () {
                  Get.toNamed(AppRoutes.changePasswordScreen);
                },
              ),
              const SpaceWidget(spaceHeight: 8),
              // Delete Account
              SettingsItemWidget(
                title: "Delete account",
                icon: AppIconPath.deleteIcon,
                onTap: () {
                  Get.toNamed(AppRoutes.accountDelete);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
