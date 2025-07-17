import 'dart:convert';

import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/notification_model.dart';
import 'package:the_leaderboard/services/api/api_get_service.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';
import 'package:the_leaderboard/utils/app_logs.dart';

class NotificationController extends GetxController {
  final RxList<NotificationModel?> notificationList = <NotificationModel>[].obs;
  final RxInt notificationCounter = 0.obs;
  final RxBool isLoading = false.obs;
  void setUnread(int value) {
    notificationCounter.value = value;
  }

  void increment() {
    notificationCounter.value++;
  }

  void clear() {
    notificationCounter.value = 0;
  }

  void fetchNotification() async {
    try {
      appLog("fetching notification");
      isLoading.value = true;
      final response = await ApiGetService.apiGetService(AppUrls.notification);
      isLoading.value = false;
      if (response != null) {
        final jsonbody = jsonDecode(response.body);
        appLog(jsonbody);
        if (response.statusCode == 200) {
          final List data = jsonbody["data"];
          notificationList.value =
              data.map((e) => NotificationModel.fromJson(e)).toList();
          appLog(notificationList);
        } else {
          Get.snackbar("Error", jsonbody["message"],
              colorText: AppColors.white, snackPosition: SnackPosition.BOTTOM);
        }
      }
      appLog("Succeed");
    } catch (e) {
      errorLog("Failed", e);
    }
    return;
  }
}
