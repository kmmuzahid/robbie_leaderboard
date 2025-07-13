import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/routes/app_routes.dart';
import 'package:the_leaderboard/services/api/api_delete_service.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';

class AccountDeleteController extends GetxController {
  final passwordController = TextEditingController();

  void deleteAccount() {}
  void deleteUser() async {
    final url = "${AppUrls.deleteUser}/${LocalStorage.userId}";
    final response = await ApiDeleteService.apiDeleteService(url);
    if (response != null) {
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Get.snackbar("Success", data["message"]);
        Get.toNamed(AppRoutes.registerScreen);
      } else {
        Get.snackbar("Error", data["message"]);
      }
    }
  }

  void tempDelete(BuildContext context) {
    if (passwordController.text.isEmpty) {
      Get.snackbar(
          "You haven't written the password", "Please write your password",
          colorText: AppColors.white);
      return;
    }
    if (passwordController.text != LocalStorage.myPassword) {
      Get.snackbar("Wrong Password", "Please write the correct password",
          colorText: AppColors.white);
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        icon: const Icon(Icons.warning),
        iconColor: AppColors.red,
        content: const Text("Do you really want to delete your account?"),
        actions: [
          TextButton(onPressed: () => deleteUser(), child: const Text("Yes")),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("No")),
        ],
      ),
    );
  }
}
