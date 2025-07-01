import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/user_model.dart';
import 'package:the_leaderboard/screens/auth_screens/auth_controller.dart';
import 'package:the_leaderboard/screens/bottom_nav/bottom_nav.dart';
import 'package:the_leaderboard/services/api/api_get_service.dart';
import 'package:the_leaderboard/services/api/api_post_service.dart';

class LoginScreenController extends GetxController {
  // TextEditingControllers for form fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiPostService _postService = ApiPostService();
  // Observable for remember me checkbox
  var rememberMe = false.obs;

  // Function to handle registration
  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    final user = User(email: email, password: password);
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Form Incomplete',
        'Please fill in all fields.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      final response = await ApiPostService.loginUser(user);
      print(response.body);
      final data = jsonDecode(response.body);
      print(data["data"]["accessToken"]);
      final authController = Get.find<AuthController>();
      authController.setAccessToken(data["data"]["accessToken"]);
      // You can use rememberMe.value here for your logic
      // For example, print the state for now
      print('Remember Me: ${rememberMe.value}');
      Get.snackbar("Success", "Login Successful");
      // Proceed with registration (e.g., API call, navigation, etc.)
      Get.offAll(BottomNav());
    } catch (e) {
      Get.snackbar("Error", "Something went wrong!");
    }
  }

  @override
  void onClose() {
    // Dispose of controllers
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
