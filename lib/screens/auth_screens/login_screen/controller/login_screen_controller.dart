import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/models/user_model.dart';
import 'package:the_leaderboard/screens/bottom_nav/bottom_nav.dart';
import 'package:the_leaderboard/services/api/api_post_service.dart';
import 'package:the_leaderboard/services/storage/storage_keys.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';

class LoginScreenController extends GetxController {
  // TextEditingControllers for form fields
  TextEditingController emailController =
      TextEditingController(text: LocalStorage.myEmail);
  TextEditingController passwordController =
      TextEditingController(text: LocalStorage.myPassword);
  // Observable for remember me checkbox
  final RxBool rememberMe = LocalStorage.rememberMe.obs;

  final RxBool isLoading = false.obs;

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

    isLoading.value = true;

    final data = await ApiPostService.loginUser(user);
    if (data != null) {
      String token = data["data"]["accessToken"];
      LocalStorage.token = token;
      LocalStorage.myEmail = email;
      isLoading.value = false;
      if (rememberMe.value) {
        LocalStorage.setBool(LocalStorageKeys.rememberMe, rememberMe.value);
        LocalStorage.setString(LocalStorageKeys.myEmail, email);
        LocalStorage.setString(LocalStorageKeys.myPassword, password);
      }

      // Proceed with registration (e.g., API call, navigation, etc.)
      Get.offAll(BottomNav());
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
