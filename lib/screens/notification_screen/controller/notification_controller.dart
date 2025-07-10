import 'dart:convert';

import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/notification_model.dart';
import 'package:the_leaderboard/services/api/api_get_service.dart';

class NotificationController extends GetxController {
  final RxList<NotificationModel?> notificationList = <NotificationModel>[].obs;

  void fetchNotification() async {
    final response = await ApiGetService.apiGetService(AppUrls.notification);
    if (response != null) {
      final jsonbody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final List data = jsonbody["data"];
        notificationList.value =
            data.map((e) => NotificationModel.fromJson(e)).toList();
      } else {
        Get.snackbar("Error", jsonbody["message"],
            colorText: AppColors.white, snackPosition: SnackPosition.BOTTOM);
      }
    }
    return;   
  }
}
