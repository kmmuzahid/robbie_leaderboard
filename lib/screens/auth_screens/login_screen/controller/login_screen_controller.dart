import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/models/user_model.dart';
import 'package:the_leaderboard/screens/bottom_nav/bottom_nav.dart';
import 'package:the_leaderboard/services/api/api_post_service.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';

class LoginScreenController extends GetxController {
  // TextEditingControllers for form fields
  TextEditingController emailController =
      TextEditingController(text: LocalStorage.myEmail);
  TextEditingController passwordController =
      TextEditingController(text: LocalStorage.myPassword);
  // Observable for remember me checkbox
  var rememberMe = false.obs;

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

    try {
      isLoading.value = true;
      final response = await ApiPostService.loginUser(user);
      final data = jsonDecode(response.body);
      String token = data["data"]["accessToken"];
      LocalStorage.token = token;
      LocalStorage.myEmail = email;
      isLoading.value = false;
      if (rememberMe.value) {
        LocalStorage.myPassword = password;
      }
      LocalStorage.rememberMe = rememberMe.value;
      print(
          "After pressing login: {${LocalStorage.myEmail} : ${LocalStorage.myPassword}}");
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
