import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/screens/bottom_nav/bottom_nav.dart';
import 'package:the_leaderboard/services/api/api_post_service.dart';

class WithdrawAmountController extends GetxController {
  final amountController = TextEditingController();

  void submit() async {
    int amount = int.parse(amountController.text);
    final response = await ApiPostService.apiPostService(
        AppUrls.withdrawAmount, {"amount": amount});
    if (response != null) {
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", data["message"], colorText: AppColors.white);
        Get.offAll(BottomNav());
      } else {
        Get.snackbar("Success", data["message"], colorText: AppColors.white);
      }
    }
    // await ApiPostService.withdrawAmount(amount);
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    amountController.dispose();
  }
}
