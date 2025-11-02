import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/user_model.dart';
import 'package:the_leaderboard/screens/bottom_nav/bottom_nav.dart';
import 'package:the_leaderboard/services/api/api_post_service.dart';
import 'package:the_leaderboard/services/storage/storage_keys.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';
import 'package:the_leaderboard/utils/app_logs.dart';

class LoginScreenController extends GetxController {
  // TextEditingControllers for form fields
  late TextEditingController emailController;

  late TextEditingController passwordController;

  // Observable for remember me checkbox
  final RxBool rememberMe = StorageService.rememberMe.obs;

  final RxBool isLoading = false.obs;

  // Function to handle registration
  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    appLog("User is logging in with $email and $password");
    final user = User(email: email, password: password);
    if (email.isEmpty || password.isEmpty) {
      Get.closeAllSnackbars();
      Get.snackbar('Form Incomplete', 'Please fill in all fields.',
          colorText: AppColors.white);
      return;
    }
    if (!email.contains("@")) {
      Get.closeAllSnackbars();
      Get.snackbar('Email invaild', 'PLease write a vaild email address',
          colorText: AppColors.white);
      return;
    }

    try {
      isLoading.value = true;
      final response =
          await ApiPostService.apiPostService(AppUrls.login, user.toJson());
      isLoading.value = false;
      if (response != null) {
        final data = jsonDecode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          String token = data["data"]["accessToken"];
          StorageService.token = token;
          StorageService.myEmail = email;

          if (rememberMe.value) {
            StorageService.setBool(LocalStorageKeys.rememberMe, rememberMe.value);
            StorageService.setString(LocalStorageKeys.myEmail, email);
            StorageService.setString(LocalStorageKeys.myPassword, password);
            StorageService.setString(LocalStorageKeys.token, token);
          }
          if (!rememberMe.value) {
            StorageService.setBool(LocalStorageKeys.rememberMe, rememberMe.value);
            StorageService.setString(LocalStorageKeys.myEmail, "");
            StorageService.setString(LocalStorageKeys.myPassword, "");
            StorageService.setString(LocalStorageKeys.token, "");
          }
          Get.closeAllSnackbars();
          Get.snackbar("Success", data["message"], colorText: AppColors.white);
          // Proceed with registration (e.g., API call, navigation, etc.)
          Get.offAll(() => const BottomNav());
        } else {
          Get.closeAllSnackbars();
          Get.snackbar("Error", data["message"], colorText: AppColors.white);
        }
      }
      appLog("Succeed");
    } catch (e) {
      errorLog("Failed", e);
    }

    return;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    appLog("login controller initialized");
    emailController = TextEditingController(text: StorageService.myEmail);
    passwordController = TextEditingController(text: StorageService.myPassword);
    if (kDebugMode) {
      // emailController.text = "biwova9852@jxbav.com";
      // passwordController.text = "12345678";

      // emailController.text = "fesad96953@dpwev.com";
      emailController.text = "copoc67793@lanipe.com";
      passwordController.text = "12345678";
    }
  }

  @override
  void onClose() {
    // Dispose of controllers

    super.onClose();
    emailController.dispose();
    passwordController.dispose();
    appLog("login controller disposed");
  }
}
