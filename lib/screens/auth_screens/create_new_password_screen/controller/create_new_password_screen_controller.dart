import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/services/api/api_post_service.dart';

import '../../../../routes/app_routes.dart';

class CreateNewPasswordScreenController extends GetxController {
  // Observable for checkbox state
  // TextEditingControllers for form fields
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Function to toggle checkbox

  // Function to handle registration
  void createNewPassword() async {
    // Add your registration logic here
    // Example: Validate form fields and proceed

    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar(
        'Form Incomplete',
        'Please fill in all fields.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar(
        'Password Mismatch',
        'Passwords do not match.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    final response = await ApiPostService.apiPostService(
        AppUrls.setNewPassword, {"newPassword": password});
    if (response != null) {
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", data["message"], colorText: AppColors.white);
        Get.offNamed(AppRoutes.loginScreen);
      } else {
        Get.snackbar("Error", data["message"], colorText: AppColors.white);
      }
    }
  }

  @override
  void onClose() {
    // Dispose of controllers
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
