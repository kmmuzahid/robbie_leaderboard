import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_icon_path.dart';
import 'package:the_leaderboard/constants/app_image_path.dart';
import 'package:the_leaderboard/constants/app_strings.dart';
import 'package:the_leaderboard/routes/app_routes.dart';
import 'package:the_leaderboard/screens/other_profile_screen/controller/other_profile_controller.dart';
import 'package:the_leaderboard/screens/other_profile_screen/widgets/affiliate_status_widget.dart';
import 'package:the_leaderboard/screens/other_profile_screen/widgets/profile_header_widget.dart';
import 'package:the_leaderboard/widgets/appbar_widget/appbar_widget.dart';
import 'package:the_leaderboard/widgets/icon_widget/icon_widget.dart';
import 'package:the_leaderboard/widgets/image_widget/image_widget.dart';
import 'package:the_leaderboard/widgets/space_widget/space_widget.dart';

class OtherProfileScreen extends StatefulWidget {
  const OtherProfileScreen({super.key, required this.userId});
  final String userId;
  @override
  State<OtherProfileScreen> createState() => _OtherProfileScreenState();
}

class _OtherProfileScreenState extends State<OtherProfileScreen> {
  final _controller = Get.put(OtherProfileController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.fetchProfile(widget.userId);
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
                        ),

                        const SpaceWidget(spaceHeight: 16),

                        // Affiliate Status
                        AffiliateStatusWidget(
                          totalRaisedValue: "\$${_controller.totalSpent.value}",
                          positionValue: "Top ${_controller.rank.value}%",
                          profileViewValue: _controller.totalViews.value,
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
