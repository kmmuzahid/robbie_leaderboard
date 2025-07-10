import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/routes/app_routes.dart';
import 'package:the_leaderboard/services/api/api_post_service.dart';

class ReportProblemController extends GetxController {
  final TextEditingController textController = TextEditingController();

  void sendMessage() async {
    final response = await ApiPostService.apiPostService(
        AppUrls.reportProblem, {"text": textController.text});
    if (response != null) {
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", data["message"], colorText: AppColors.white);
        Get.toNamed(AppRoutes.settingsScreen);
      } else {
        Get.snackbar("Error", data["message"], colorText: AppColors.white);
      }
    }
    // await ApiPostService.sentReport(_controller.text);
    textController.clear();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    textController.dispose();
  }
}
