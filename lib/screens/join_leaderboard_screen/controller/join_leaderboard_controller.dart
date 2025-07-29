import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/screens/webview_screen/webview_screen.dart';
import 'package:the_leaderboard/services/api/api_post_service.dart';
import 'package:the_leaderboard/utils/app_logs.dart';

class JoinLeaderboardController extends GetxController {
  final amountController = TextEditingController();
  final RxString generatedUrl = "".obs;

  void submit() async {
    try {
      appLog("submit is calling from join leaderboard");
      int amount = int.parse(amountController.text);
      final response = await ApiPostService.apiPostService(
          AppUrls.joinLeaderboard, {"amount": amount});
      if (response != null) {
        final data = jsonDecode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          Get.snackbar("Success", data["message"], colorText: AppColors.white);
          generatedUrl.value = data["data"];
          Get.to(WebviewScreen(
              url: generatedUrl.value, title: "Join Leaderboard"));
        } else {
          Get.snackbar("Error", data["message"], colorText: AppColors.white);
        }
      }
      appLog("Succeed");
    } catch (e) {
      errorLog("submit", e);
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    amountController.dispose();
  }
}
