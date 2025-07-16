import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/screens/profile_screen/controller/profile_screen_controller.dart';
import 'package:the_leaderboard/screens/profile_screen/widgets/affiliate_status_widget.dart';
import 'package:the_leaderboard/screens/profile_screen/widgets/profile_header_widget.dart';
import 'package:the_leaderboard/widgets/button_widget/button_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_icon_path.dart';
import '../../constants/app_image_path.dart';
import '../../constants/app_strings.dart';
import '../../routes/app_routes.dart';
import '../../widgets/appbar_widget/appbar_widget.dart';
import '../../widgets/icon_widget/icon_widget.dart';
import '../../widgets/image_widget/image_widget.dart';
import '../../widgets/space_widget/space_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ProfileScreenController(),
      builder: (controller) => AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: AppColors.blueDark,
          appBar: AppbarWidget(
            title: AppStrings.theLeaderboard,
            leading: const Padding(
              padding: EdgeInsets.only(left: 16, bottom: 8),
              child: ImageWidget(
                height: 20,
                width: 20,
                imagePath: AppImagePath.crownImage,
                fit: BoxFit.contain,
              ),
            ),
            action: Obx(
              () => IconButton(
                tooltip: "Notifications",
                onPressed: () {
                  controller.notificationController.clear();
                  Get.toNamed(AppRoutes.notificationsScreen);
                  // Get.toNamed(AppRoutes.serverOff);
                },
                icon: Badge(
                  isLabelVisible: controller
                          .notificationController.notificationCounter.value !=
                      0,
                  label: Text(controller
                      .notificationController.notificationCounter.value
                      .toString()),
                  backgroundColor: AppColors.red,
                  child: const IconWidget(
                    icon: AppIconPath.notificationIcon,
                    width: 24,
                    height: 24,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
          body: Obx(
            () => RefreshIndicator(
              onRefresh: controller.fetchProfile,
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile Header
                      ProfileHeaderWidget(
                        fromNetwork: controller.image.value.isNotEmpty,
                        isLoading: controller.isLoading.value,
                        image: controller.image.value.isNotEmpty
                            ? "${AppUrls.mainUrl}${controller.image.value}"
                            : AppImagePath.profileImage,
                        name: controller.name.value,
                        email: controller.email.value,
                        balance: "\$${controller.totalBalance.value}",
                        withdrawButtonOnPressed: controller.withdrawAmount,
                        tweeterButtonOnPressed: () {
                          launchUrl(Uri.parse(AppUrls.twitterUrl),
                              mode: LaunchMode.externalApplication);
                        },
                        instagramButtonOnPressed: () {
                          launchUrl(Uri.parse(AppUrls.instagramUrl),
                              mode: LaunchMode.externalApplication);
                        },
                        discordButtonOnPressed: () {
                          launchUrl(Uri.parse(AppUrls.discordUrl),
                              mode: LaunchMode.externalApplication);
                        },
                        youtubeButtonOnPressed: () {
                          launchUrl(Uri.parse(AppUrls.youtubeUrl),
                              mode: LaunchMode.externalApplication);
                        },
                      ),

                      const SpaceWidget(spaceHeight: 16),

                      // Affiliate Status
                      AffiliateStatusWidget(
                        isLoading: controller.isLoading.value,
                        totalRaisedValue: "\$${controller.totalSpent.value}",
                        positionValue: "Top ${controller.rank.value}%",
                        profileViewValue: controller.totalViews.value,
                        iconButtonOnTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Creator Code copied!")),
                          );
                        },
                        codeNumber: controller.creatorCode.value,
                      ),

                      const SpaceWidget(spaceHeight: 16),

                      // View Settings Button
                      ButtonWidget(
                        onPressed: () {
                          Get.toNamed(AppRoutes.settingsScreen);
                        },
                        label: "View Settings",
                        buttonWidth: double.infinity,
                      ),

                      const SpaceWidget(spaceHeight: 12),

                      // Logout Button
                      ButtonWidget(
                        onPressed: controller.logout,
                        label: "Logout",
                        buttonWidth: double.infinity,
                        backgroundColor: AppColors.blueDark,
                        borderColor: AppColors.blueLighter,
                        textColor: AppColors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
