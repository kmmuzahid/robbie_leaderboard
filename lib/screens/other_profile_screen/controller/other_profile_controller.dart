import 'dart:convert';

import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/profile_model.dart';
import 'package:the_leaderboard/services/api/api_get_service.dart';

class OtherProfileController extends GetxController {
  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final RxString totalSpent = ''.obs;
  final RxString totalViews = ''.obs;
  final RxString rank = ''.obs;
  final RxBool isLoading = true.obs;

  void fetchProfile(String userId) async {
    isLoading.value = true;
    final url = "${AppUrls.otherUserProfile}/$userId";
    final response = await ApiGetService.apiGetService(url);    
    isLoading.value = false;
    if (response != null) {
      final jsonbody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final profile = ProfileUserModel.fromJson(jsonbody["data"]["user"]);
        name.value = profile.name;
        email.value = profile.email;
        totalSpent.value = profile.totalInvest.toString();
        totalViews.value = profile.views.toString();
        rank.value = profile.rank.toString();
      } else {
        Get.snackbar("Error", jsonbody["message"],
            colorText: AppColors.white, snackPosition: SnackPosition.BOTTOM);
      }
    }
    return;
  }
}
