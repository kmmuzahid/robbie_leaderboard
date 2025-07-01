import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';

class CreateNewPasswordScreenController extends GetxController {
  // Observable for checkbox state

  // TextEditingControllers for form fields
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Function to toggle checkbox

  // Function to handle registration
  void createNewPassword() {
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

    // Proceed with registration (e.g., API call, navigation, etc.)
    Get.offNamed(AppRoutes.loginScreen);
  }

  @override
  void onClose() {
    // Dispose of controllers

    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
