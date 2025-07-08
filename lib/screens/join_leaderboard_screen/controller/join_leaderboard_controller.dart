import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/screens/bottom_nav/bottom_nav.dart';
import 'package:the_leaderboard/services/api/api_post_service.dart';
import 'package:url_launcher/url_launcher.dart';

class JoinLeaderboardController extends GetxController {
  final amountController = TextEditingController();
  final RxString generatedUrl = "".obs;
  final RxString urlTitle = "".obs;

  void submit() async {
    int amount = int.parse(amountController.text);
    urlTitle.value = "Please click the link below";
    generatedUrl.value = await ApiPostService.joinLeaderboard(amount);
    final url = Uri.parse(generatedUrl.value);
    await launchUrl(url, mode: LaunchMode.inAppWebView);
    Get.offAll(BottomNav());
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    amountController.dispose();
  }
}
