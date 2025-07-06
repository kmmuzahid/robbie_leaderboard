import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/routes/app_routes.dart';
import 'package:the_leaderboard/screens/bottom_nav/bottom_nav.dart';
import 'package:the_leaderboard/services/api/api_post_service.dart';

class WithdrawAmountController extends GetxController {
  final amountController = TextEditingController();

  void submit() async {
    int amount = int.parse(amountController.text);
    await ApiPostService.withdrawAmount(amount);
    Get.offAll(BottomNav());
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    amountController.dispose();
  }
}
