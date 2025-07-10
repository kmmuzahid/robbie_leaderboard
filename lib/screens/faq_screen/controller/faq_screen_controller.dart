import 'dart:convert';

import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/faq_model.dart';
import 'package:the_leaderboard/services/api/api_get_service.dart';

class FaqScreenController extends GetxController {
  final RxList<FaqModel?> faqList = <FaqModel>[].obs;
  final RxBool isLoading = true.obs;

  void fetchData() async {
    isLoading.value = true;
    final response = await ApiGetService.apiGetService(AppUrls.faq);
    isLoading.value = false;
    if (response != null) {
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final List value = data["data"];
        faqList.value = value.map((e) => FaqModel.fromJson(e)).toList();
        return;
      } else {
        Get.snackbar("Error", data["message"]);
      }
    }
  }
}
