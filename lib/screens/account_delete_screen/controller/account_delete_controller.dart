import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_strings.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/routes/app_routes.dart';
import 'package:the_leaderboard/services/api/api_delete_service.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';

class AccountDeleteController extends GetxController {
  final passwordController = TextEditingController();

  void deleteAccount() {}
  void deleteUser() async {
    final url = "${AppUrls.deleteUser}/${StorageService.userId}";
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
        AppStrings.missingPassword,
        AppStrings.enterPassword,
        colorText: AppColors.white,
      );

      return;
    }
    if (passwordController.text != StorageService.myPassword) {
      Get.snackbar(
        AppStrings.incorrectPassword,
       AppStrings.passwordIsIncorrect,
        colorText: AppColors.white,
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        icon: const Icon(Icons.warning),
        iconColor: AppColors.red,
        content: const Text(
           AppStrings.permanentDeleteAccount),
        actions: [
          TextButton(onPressed: () => deleteUser(), child: const Text(AppStrings.yes)),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(AppStrings.no)),
        ],
      ),
    );
  }
}
