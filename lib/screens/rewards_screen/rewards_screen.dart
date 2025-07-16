import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:the_leaderboard/screens/notification_screen/controller/notification_controller.dart';
import 'package:the_leaderboard/screens/rewards_screen/controller/rewards_screen_controller.dart';
import 'package:the_leaderboard/screens/rewards_screen/widgets/ticket_gauge_painter.dart';
import 'package:the_leaderboard/utils/app_logs.dart';
import 'package:the_leaderboard/utils/app_size.dart';
import 'package:the_leaderboard/widgets/button_widget/button_widget.dart';
import 'package:the_leaderboard/widgets/shimmer_loading_widget/shimmer_loading.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_icon_path.dart';
import '../../constants/app_image_path.dart';
import '../../constants/app_strings.dart';
import '../../routes/app_routes.dart';
import '../../widgets/appbar_widget/appbar_widget.dart';
import '../../widgets/gradient_text_widget/gradient_text_widget.dart';
import '../../widgets/icon_widget/icon_widget.dart';
import '../../widgets/image_widget/image_widget.dart';
import '../../widgets/space_widget/space_widget.dart';
import '../../widgets/text_widget/text_widgets.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  int currentTickets = 35;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: RewardsScreenController(),
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
              onRefresh: controller.fetchData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const TextWidget(
                                text: "Raffles",
                                fontColor: AppColors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              controller.isRuffleLoading.value
                                  ? const ShimmerLoading(width: 120, height: 10)
                                  : TextWidget(
                                      text:
                                          "Drawing on ${DateFormat("MMMM d, y").format(controller.currentRuffle.value!.deadline)}",
                                      fontColor: AppColors.greyDarker,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                            ],
                          ),
                          const SpaceWidget(spaceHeight: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.gradientColorStart,
                                  AppColors.gradientColorEnd,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                const TextWidget(
                                  text: "Prize Pool",
                                  fontColor: AppColors.greyBlue,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                                const SpaceWidget(spaceHeight: 4),
                                controller.isRuffleLoading.value
                                    ? const ShimmerLoading(
                                        width: 100, height: 20)
                                    : TextWidget(
                                        text:
                                            "\$${controller.currentRuffle.value!.prizeMoney} to be won!",
                                        fontColor: AppColors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SpaceWidget(spaceHeight: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // Changed from start to center
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const TextWidget(
                                text: 'Current Tickets',
                                fontColor: AppColors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              const SpaceWidget(spaceHeight: 6),
                              controller.isRuffleLoading.value
                                  ? const ShimmerLoading(width: 120, height: 10)
                                  : GradientText(
                                      text: controller.getRemainingDays(),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      textAlign: TextAlign.start,
                                      maxLines: 2,
                                    ),
                            ],
                          ),
                          Container(
                            width: 120, // Reduced width
                            height: 50, // Reduced height
                            margin: const EdgeInsets.only(top: 24),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CustomPaint(
                                  size: const Size(120, 50),
                                  // Reduced size of custom paint
                                  painter: TicketGaugePainter(
                                    currentTickets: currentTickets,
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  // Added this to constrain column
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextWidget(
                                      text: "${controller.totalTicket.value}",
                                      fontColor: AppColors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                    const TextWidget(
                                      text: 'Tickets',
                                      fontColor: AppColors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SpaceWidget(spaceHeight: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TextWidget(
                            text: 'Current Tickets',
                            fontColor: AppColors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          const SpaceWidget(spaceHeight: 12),
                          controller.isRuffleLoading.value
                              ? ShimmerLoading(
                                  width: double.infinity,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                )
                              : Container(
                                  height: 100,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                  child: WheelChooser(
                                    controller: controller.wheelController,
                                    startPosition: null,
                                    listWidth:
                                        MediaQuery.of(context).size.width * 1.5,
                                    itemSize: 70,
                                    squeeze: 1.0,
                                    perspective: 0.01,
                                    datas: controller
                                        .currentRuffle.value!.ticketButtons,
                                    isInfinite: true,
                                    magnification: 1,
                                    listHeight: 100,
                                    onValueChanged: (s) {
                                      appLog(s);
                                      controller.handleWheelValueChanged2(s.toString());
                                      // final selectedIndex = controller
                                      //     .wheelController.selectedItem;
                                      // controller.spinWheelByHand(selectedIndex);
                                    },
                                    // controller.spinWheel(),
                                    // Trim spaces for logging
                                    selectTextStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                    unSelectTextStyle: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      backgroundColor: Colors.transparent,
                                    ),
                                    horizontal: true,
                                  ),
                                ),
                          const SpaceWidget(spaceHeight: 8),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: TextWidget(
                              text:
                                  'You can spin once per day. Come back tomorrow for another spin !',
                              fontColor: AppColors.silver,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                          const SpaceWidget(spaceHeight: 10),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const IconWidget(
                                    height: 16,
                                    width: 16,
                                    icon: AppIconPath.powerIcon,
                                  ),
                                  const SpaceWidget(spaceWidth: 2),
                                  GradientText(
                                    text:
                                        "${controller.dayIndex.value} Days Streak",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SpaceWidget(spaceHeight: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ...List.generate(7, (index) {
                                return Container(
                                  width: AppSize.width(value: 30),
                                  height: ResponsiveUtils.height(10),
                                  margin: const EdgeInsets.only(right: 4),
                                  decoration: BoxDecoration(
                                    gradient: index < controller.dayIndex.value
                                        ? const LinearGradient(
                                            colors: [
                                              AppColors.gradientColorStart,
                                              AppColors.gradientColorEnd,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          )
                                        : null,
                                    color: index < controller.dayIndex.value
                                        ? null
                                        : AppColors.greyBlue,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                );
                              }),
                            ],
                          ),
                          const SpaceWidget(spaceHeight: 10),
                          TextWidget(
                            text:
                                "${controller.dayIndex.value} out of 7 days. You can get an extra Spin after 7 days",
                            fontColor: AppColors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                          const SpaceWidget(spaceHeight: 18),
                          const ButtonWidget(
                            onPressed: null,
                            label: "Spin to Win Tickets",
                            buttonWidth: double.infinity,
                            fontSize: 14,
                            buttonHeight: 42,
                          ),
                        ],
                      ),
                    ),
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
