import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/services/api/api_post_service.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';
import '../../../../routes/app_routes.dart';

class ForgotPasswordScreenController extends GetxController {
  // TextEditingControllers for form fields
  final TextEditingController emailController = TextEditingController();

  // Function to handle forgot password
  void forgotPassword() async {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar(
        'Form Incomplete',
        'Please fill in the fields.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    final url = "${AppUrls.forgetPassword}/$email";
    final response = await ApiPostService.apiPostService(url, {"email": email});
    if (response != null) {
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", data["message"], colorText: AppColors.white);
        LocalStorage.myEmail = email;
        Get.toNamed(AppRoutes.forgotVerifyOtpScreen);
      } else {
        Get.snackbar("Error", data["message"], colorText: AppColors.white);
      }
    }
  }

  @override
  void onClose() {
    // Dispose of controllers
    emailController.dispose();
    super.onClose();
  }
}
