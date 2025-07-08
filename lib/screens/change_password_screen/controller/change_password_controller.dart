import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/routes/app_routes.dart';
import 'package:the_leaderboard/services/api/api_post_service.dart';

class ChangePasswordController extends GetxController {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  void saveChange() async {
    if (oldPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmNewPasswordController.text.isEmpty) {
      Get.snackbar("Error", "Please fill the form correctly");
      return;
    }
    if (newPasswordController.text != confirmNewPasswordController.text) {
      Get.snackbar("Error", "Password mismatched error");
      return;
    }
    if (oldPasswordController.text == newPasswordController.text) {
      Get.snackbar("Error", "Old and new password are same");
      return;
    }

    await ApiPostService.changePassword(
        oldPasswordController.text, newPasswordController.text);

    oldPasswordController.clear();
    newPasswordController.clear();
    confirmNewPasswordController.clear();
    Get.toNamed(AppRoutes.loginScreen);
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
  }
}
