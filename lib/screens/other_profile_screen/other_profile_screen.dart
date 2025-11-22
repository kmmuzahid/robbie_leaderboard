import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_image_path.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/screens/other_profile_screen/controller/other_profile_controller.dart';
import 'package:the_leaderboard/screens/other_profile_screen/widgets/affiliate_status_widget.dart';
import 'package:the_leaderboard/screens/other_profile_screen/widgets/profile_header_widget.dart';
import 'package:the_leaderboard/widgets/appbar_widget/appbar_widget.dart';
import 'package:the_leaderboard/widgets/space_widget/space_widget.dart';
import 'package:the_leaderboard/widgets/text_widget/text_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class OtherProfileScreen extends StatelessWidget {
  const OtherProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
      ),
      child: GetBuilder(
          init: OtherProfileController(),
          builder: (controller) {
            return Scaffold(
              backgroundColor: AppColors.blueDark,
              appBar: const AppbarWidget(
                title: "Profile",
                centerTitle: true,
              ),
              body: controller.isLoading.value
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
                              fromNetwork: controller.profileImage.value != "",
                              image: controller.profileImage.value != ""
                                  ? "${AppUrls.mainUrl}${controller.profileImage.value}"
                                  : AppImagePath.profileImage,
                              name: controller.name.value,
                              email: controller.email.value,
                              socialButtonOn:
                                  controller.facebookUrl.isNotEmpty ||
                                      controller.instagramUrl.isNotEmpty ||
                                      controller.twitterUrl.isNotEmpty ||
                                      controller.linkedinUrl.isNotEmpty ||
                                      controller.youtubeUrl.isNotEmpty,
                              facebookUrlOn: controller.facebookUrl.isNotEmpty,
                              instagramUrlOn:
                                  controller.instagramUrl.isNotEmpty,
                              twitterUrlOn: controller.twitterUrl.isNotEmpty,
                              linkedinUrlOn: controller.linkedinUrl.isNotEmpty,
                              youtubeUrlOn: controller.youtubeUrl.isNotEmpty,
                              instagramButtonOnPressed: () {
                                // Get.to(WebviewScreen(
                                //   url: _controller.instagramUrl.value,
                                //   title: "Instagram",
                                // ));
                                launchUrl(
                                    Uri.parse(controller.instagramUrl.value),
                                    mode: LaunchMode.externalApplication);
                              },
                              twitterButtonOnPressed: () {
                                // Get.to(WebviewScreen(
                                //   url: _controller.twitterUrl.value,
                                //   title: "X",
                                // ));
                                launchUrl(
                                    Uri.parse(controller.twitterUrl.value),
                                    mode: LaunchMode.externalApplication);
                              },
                              facebookButtonOnPressed: () {
                                // Get.to(WebviewScreen(
                                //   url: _controller.facebookUrl.value,
                                //   title: "Facebook",
                                // ));
                                launchUrl(
                                    Uri.parse(controller.facebookUrl.value),
                                    mode: LaunchMode.externalApplication);
                              },
                              linkedinButtonOnPressed: () {
                                // Get.to(WebviewScreen(
                                //   url: _controller.linkedinUrl.value,
                                //   title: "Linkedin",
                                // ));
                                launchUrl(
                                    Uri.parse(controller.linkedinUrl.value),
                                    mode: LaunchMode.externalApplication);
                              },
                              youtubeButtonOnPressed: () {
                                // Get.to(WebviewScreen(
                                //   url: _controller.youtubeUrl.value,
                                //   title: "Youtube",
                                // ));
                                launchUrl(
                                    Uri.parse(controller.youtubeUrl.value),
                                    mode: LaunchMode.externalApplication);
                              },
                            ),

                            const SpaceWidget(spaceHeight: 16),

                            // Affiliate Status
                            AffiliateStatusWidget(
                              totalRaisedValue:
                                  "\$${controller.totalSpent.value}",
                              positionValue: "Top ${controller.rank.value}%",
                              profileViewValue: controller.totalViews.value,
                            ),
                            if (int.parse(controller.rank.value) <= 10 &&
                                controller.bio.value.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.all(15.0),
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: AppColors.blue,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const TextWidget(
                                        text: "Bio",
                                        fontColor: AppColors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                      const SpaceWidget(spaceHeight: 8),
                                      Text(
                                        controller.bio.value,
                                        style: const TextStyle(
                                            color: AppColors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            const SpaceWidget(spaceHeight: 8),
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: TextWidget(
                                  text: "Shout",
                                  fontColor: AppColors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),

                            Container(
                              padding: const EdgeInsets.all(15.0),
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  color: AppColors.blue, borderRadius: BorderRadius.circular(12)),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(controller.shoutTitle.value,
                                        style: const TextStyle(
                                            color: AppColors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    const SpaceWidget(spaceHeight: 8),
                                    Text(
                                      controller.shoutContent.value,
                                      style: const TextStyle(color: AppColors.white, fontSize: 14),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            )
                          ],
                        ),
                      ),
                    ),
            );
          }),
    );
  }
}
