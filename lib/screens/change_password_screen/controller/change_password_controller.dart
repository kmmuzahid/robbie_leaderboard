import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/routes/app_routes.dart';
import 'package:the_leaderboard/services/api/api_post_service.dart';

class ChangePasswordController extends GetxController {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  void saveChange() async {
    if (oldPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmNewPasswordController.text.isEmpty) {
      Get.snackbar("Error", "Please fill the form correctly");
      return;
    }
    if (newPasswordController.text != confirmNewPasswordController.text) {
      Get.snackbar("Error", "Password mismatched error");
      return;
    }
    if (oldPasswordController.text == newPasswordController.text) {
      Get.snackbar("Error", "Old and new password are same");
      return;
    }
    final response =
        await ApiPostService.apiPostService(AppUrls.changePassword, {
      "oldPassword": oldPasswordController.text,
      "newPassword": newPasswordController.text
    });
    if (response != null) {
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", data["message"], colorText: AppColors.white);
        Get.toNamed(AppRoutes.loginScreen);
      } else {
        Get.snackbar("Error", data["message"], colorText: AppColors.white);
      }
    }

    oldPasswordController.clear();
    newPasswordController.clear();
    confirmNewPasswordController.clear();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
  }
}
