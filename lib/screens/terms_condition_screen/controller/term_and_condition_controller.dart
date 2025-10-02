import 'dart:convert';

import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/services/api/api_get_service.dart';
import 'package:the_leaderboard/utils/app_logs.dart';

class TermAndConditionController extends GetxController {
  final RxString termAndCondition = ''.obs;
  final RxBool isLoading = true.obs;

  void fetchData() async {
    try {
      appLog("term and condition data is fetching");
      isLoading.value = true;
      final response =
          await ApiGetService.apiGetService(AppUrls.termAndCondition);
      isLoading.value = false;
      if (response != null) {
        final jsonbody = jsonDecode(response.body);
        if (response.statusCode == 200) {
          termAndCondition.value = jsonbody["data"]["text"];
        } else {
          Get.snackbar(
            "Error",
            jsonbody["message"],
            colorText: AppColors.white,
          );
          termAndCondition.value = "";
        }
      }
    } catch (e) {
      errorLog("Failed", e);
    }
  }
}
