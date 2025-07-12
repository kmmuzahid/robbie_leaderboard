import 'dart:convert';

import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/term_and_condition_model.dart';
import 'package:the_leaderboard/services/api/api_get_service.dart';
import 'package:the_leaderboard/utils/app_logs.dart';

class TermAndConditionController extends GetxController {
  final RxString termAndCondition = ''.obs;

  void fetchData() async {
    try {
      appLog("term and condition data is fetching");
      final response =
          await ApiGetService.apiGetService(AppUrls.termAndCondition);
      if (response != null) {
        final jsonbody = jsonDecode(response.body);
        if (response.statusCode == 200) {
          final List data = jsonbody["data"];
          final temp =
              data.map((e) => TermAndConditionModel.fromJson(e)).toList();
          termAndCondition.value = temp.first.text;
        } else {
          Get.snackbar("Error", jsonbody["message"],
              colorText: AppColors.white, snackPosition: SnackPosition.BOTTOM);
          termAndCondition.value = "";
        }
      }
    } catch (e) {
       errorLog("Failed", e);
    }
  }
}
