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
  final _controller = Get.put(ProfileScreenController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
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
          action: IconButton(
            tooltip: "Notifications",
            onPressed: () {
              Get.toNamed(AppRoutes.notificationsScreen);
            },
            icon: const Badge(
              isLabelVisible: true,
              label: Text('3'),
              backgroundColor: AppColors.red,
              child: IconWidget(
                icon: AppIconPath.notificationIcon,
                width: 24,
                height: 24,
                color: AppColors.white,
              ),
            ),
          ),
        ),
        body: Obx(
          () => _controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Profile Header
                        ProfileHeaderWidget(
                          image: AppImagePath.profileImage,
                          name: _controller.name.value,
                          email: _controller.email.value,
                          balance: "\$${_controller.totalBalance.value}",
                          withdrawButtonOnPressed: _controller.withdrawAmount,
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
                          totalRaisedValue: "\$${_controller.totalSpent.value}",
                          positionValue: "Top ${_controller.rank.value}%",
                          profileViewValue: _controller.totalViews.value,
                          iconButtonOnTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Creator Code copied!")),
                            );
                          },
                          codeNumber: _controller.creatorCode.value,
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
                          onPressed: _controller.logout,
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
    );
  }
}
