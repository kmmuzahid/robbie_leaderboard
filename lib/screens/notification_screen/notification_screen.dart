import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:the_leaderboard/constants/app_icon_path.dart';
import 'package:the_leaderboard/screens/notification_screen/controller/notification_controller.dart';
import 'package:the_leaderboard/widgets/icon_widget/icon_widget.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../widgets/appbar_widget/appbar_widget.dart';
import '../../widgets/space_widget/space_widget.dart';
import '../../widgets/text_widget/text_widgets.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // // Separate lists for descriptions and timestamps
  // final List<String> notificationDescriptions = const [
  //   "Dennis Nedry commented on Isla Nublar SOC2 compliance report",
  //   "Dennis Nedry commented on Isla Nublar SOC2 compliance report",
  //   "Dennis Nedry commented on Isla Nublar SOC2 compliance report",
  //   "Dennis Nedry commented on Isla Nublar SOC2 compliance report",
  // ];

  // final List<String> notificationTimestamps = const [
  //   "Last Wednesday at 9:42 AM",
  //   "Last Wednesday at 9:42 AM",
  //   "Last Wednesday at 9:42 AM",
  //   "Last Wednesday at 9:42 AM",
  // ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: NotificationController(),
      builder: (controller) => AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: AppColors.blueDark,
          appBar: const AppbarWidget(
              title: AppStrings.notifications, centerTitle: true),
          body: Obx(
            () => controller.notificationList.isEmpty
                ? const Center(
                    child: TextWidget(
                      text: "There is no notification",
                      fontColor: AppColors.white,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: ListView.separated(
                      itemCount: controller.notificationList.length,
                      // Use length of one list (they should be equal)
                      separatorBuilder: (context, index) =>
                          const SpaceWidget(spaceHeight: 12),
                      itemBuilder: (context, index) {
                        final day = DateFormat("EEE");
                        final time = DateFormat("h:mm a");

                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const IconWidget(
                                icon: AppIconPath.bellIcon,
                                height: 24,
                                width: 24,
                              ),
                              const SpaceWidget(spaceWidth: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      text: controller
                                          .notificationList[index]!.text,
                                      // Fetch description
                                      fontColor: AppColors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      textAlignment: TextAlign.start,
                                    ),
                                    const SpaceWidget(spaceHeight: 8),
                                    TextWidget(
                                      text:
                                          "Last ${day.format(controller.notificationList[index]!.createdAt)} at ${time.format(controller.notificationList[index]!.createdAt)}",
                                      // Fetch timestamp
                                      fontColor: AppColors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      textAlignment: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
