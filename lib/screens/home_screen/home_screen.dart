import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_image_path.dart';
import 'package:the_leaderboard/constants/app_strings.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/screens/home_screen/controller/home_screen_controller.dart';
import 'package:the_leaderboard/screens/home_screen/widgets/hall_of_fame_card_widget.dart';
import 'package:the_leaderboard/screens/home_screen/widgets/hall_of_frame_loading.dart';
import 'package:the_leaderboard/screens/home_screen/widgets/home_appbar_widget.dart';
import 'package:the_leaderboard/screens/home_screen/widgets/profile_card_loading.dart';
import 'package:the_leaderboard/screens/home_screen/widgets/profile_card_widget.dart';
import 'package:the_leaderboard/screens/home_screen/widgets/recent_activity_card_widget.dart';
import 'package:the_leaderboard/widgets/image_widget/image_widget.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_icon_path.dart';
import '../../routes/app_routes.dart';
import '../../widgets/icon_widget/icon_widget.dart';
import '../../widgets/space_widget/space_widget.dart';
import '../../widgets/text_widget/text_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: HomeScreenController(),
      builder: (controller) => AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: AppColors.blueDark,
          appBar: HomeAppbarWidget(
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
                // Get.toNamed(AppRoutes.serverOff);
              },
              icon: const Badge(
                isLabelVisible: false,
                label: Text(""),
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
            () => RefreshIndicator(
              onRefresh: controller.fetchData,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SpaceWidget(spaceHeight: 16),
                    controller.ismydataLoading.value
                        ? const ProfileCardLoading()
                        : ProfileCardWidget(
                            fromNetwork: controller.image.value.isNotEmpty,
                            profileImagePath: controller.image.value.isEmpty
                                ? AppImagePath.profileImage
                                : "${AppUrls.mainUrl}${controller.image.value}",
                            name: controller.name.value,
                            rankNumber: controller.rank.value,
                            totalRaisedAmount:
                                "\$${controller.totalRaised.value}",
                            totalSpentAmount:
                                "\$${controller.totalSpent.value}",
                            onViewProfilePressed: controller.viewMyProfile,
                            onJoinLeaderboardPressed: () {
                              Get.toNamed(AppRoutes.joinLeaderboard);
                            },
                            onSharePressed: () {
                              // controller.sendData();
                              Get.snackbar(
                                  "This feature is not implemented yet",
                                  "Please wait for the future update",
                                  colorText: AppColors.white);
                            },
                          ),
                    const SpaceWidget(spaceHeight: 16),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextWidget(
                        text: AppStrings.hallOfFame,
                        fontColor: AppColors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const SpaceWidget(spaceHeight: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            controller.ishallofframeSinglePaymentLoading.value
                                ? const HallOfFrameLoading()
                                : HallOfFameCardWidget(
                                    name: controller
                                        .recoredSinglePayment.value!.name,
                                    status:
                                        "\$${controller.recoredSinglePayment.value!.totalInvested}",
                                    imageUrl: '',
                                    type: AppStrings.highestPayment,
                                    title: AppStrings.recordSingle,
                                  ),
                            controller.ishallofframeConsisntantTopLoading.value
                                ? const HallOfFrameLoading()
                                : HallOfFameCardWidget(
                                    name:
                                        controller.consistantlyTop.value!.name,
                                    status:
                                        "Last ${controller.consistantlyTop.value!.timesRankedTop} Days",
                                    imageUrl: '',
                                    type: AppStrings.consecutively1st,
                                    title: AppStrings.consistentlyTop,
                                  ),
                            controller.ishallofframeMostEngagedLoading.value
                                ? const HallOfFrameLoading()
                                : HallOfFameCardWidget(
                                    imageUrl: controller
                                        .mostEngaged.value!.profileImg,
                                    name: controller.mostEngaged.value!.name,
                                    status:
                                        "${controller.mostEngaged.value!.views} Views",
                                    type: AppStrings.mostViewedProfile,
                                    title: AppStrings.mostEngage,
                                  )
                          ]),
                    ),
                    const SpaceWidget(spaceHeight: 16),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextWidget(
                        text: AppStrings.recentActivity,
                        fontColor: AppColors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const SpaceWidget(spaceHeight: 8),
                    LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        // Get screen height safely
                        final screenHeight = MediaQuery.of(context).size.height;
                        // Calculate a safe height value (190 or 25% of screen height)
                        final containerHeight = screenHeight * 0.25;

                        return Obx(
                          () => Container(
                              width: double.infinity,
                              height: containerHeight,
                              // Use safe height value
                              padding: const EdgeInsets.all(12),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: AppColors.blue,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: controller.recentActivity.isEmpty
                                  ? const Center(
                                      child: TextWidget(
                                        text: "There is no recent activity",
                                        fontColor: AppColors.white,
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount:
                                          controller.recentActivity.length,
                                      itemBuilder: (context, index) {
                                        return RecentActivityCardWidget(
                                            action: controller
                                                .recentActivity[index].title,
                                            value: controller
                                                .recentActivity[index].subTitle,
                                            time: controller
                                                .recentActivity[index].type);
                                      })
                              // StreamBuilder(stream: _controller.streamSocket.getResponse, builder: (context, snapshot) {
                              //   if(snapshot.hasData){
                              //     return ListView.builder(itemBuilder: (context, index) => RecentActivityCardWidget(action: snapshot.data[index], value: value, time: time),)
                              //   }
                              // },)
                              ),
                        );
                      },
                    ),
                    const SpaceWidget(spaceHeight: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
