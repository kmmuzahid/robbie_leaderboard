import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_image_path.dart';
import 'package:the_leaderboard/screens/other_profile_screen/controller/other_profile_controller.dart';
import 'package:the_leaderboard/screens/other_profile_screen/widgets/affiliate_status_widget.dart';
import 'package:the_leaderboard/screens/other_profile_screen/widgets/profile_header_widget.dart';
import 'package:the_leaderboard/widgets/appbar_widget/appbar_widget.dart';
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
        appBar: const AppbarWidget(
          title: "Profile",
          centerTitle: true,
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
