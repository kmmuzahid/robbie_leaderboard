import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    try {
      final message = await ApiPostService.forgetPassword(email);
      LocalStorage.myEmail = email;

      Get.snackbar("Success", message);
      // You can use rememberMe.value here for your logic
      // For example, print the state for now

      // Proceed with registration (e.g., API call, navigation, etc.)
      Get.toNamed(AppRoutes.forgotVerifyOtpScreen);
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    }
  }

  @override
  void onClose() {
    // Dispose of controllers
    emailController.dispose();
    super.onClose();
  }
}
