import 'dart:convert';

import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/profile_model.dart';
import 'package:the_leaderboard/routes/app_routes.dart';
import 'package:the_leaderboard/services/api/api_get_service.dart';
import 'package:the_leaderboard/services/storage/storage_keys.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';
import 'package:the_leaderboard/utils/app_logs.dart';

class ProfileScreenController extends GetxController {
  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final RxString totalBalance = ''.obs;
  final RxString totalSpent = ''.obs;
  final RxString totalViews = ''.obs;
  final RxString creatorCode = ''.obs;
  final RxString rank = ''.obs;
  final RxBool isLoading = true.obs;
  final RxString image = "".obs;

  Future fetchProfile() async {
    try {
      appLog("Profile data is fetching");
      isLoading.value = true;
      final response = await ApiGetService.apiGetService(AppUrls.profile);
      isLoading.value = false;
      if (response != null) {
        final data = jsonDecode(response.body);
        if (response.statusCode == 200) {
          final profile = ProfileUserModel.fromJson(data["data"]["user"]);
          name.value = profile.name;
          email.value = profile.email;
          totalBalance.value = profile.totalAdminAmount.toString();
          totalSpent.value = profile.totalInvest.toString();
          totalViews.value = profile.views.toString();
          creatorCode.value = profile.userCode;
          rank.value = profile.rank.toString();
          image.value = profile.profileImg;
          LocalStorage.userId = profile.id;
          appLog("user id: ${profile.id} and token: ${LocalStorage.token}");
        } else {
          Get.snackbar("Error", data["message"], colorText: AppColors.white);
        }
      }
      appLog("Succeed");
    } catch (e) {
      errorLog("Failed", e);
    }
    // final profile = await ApiGetService.fetchProfile();
  }

  void logout() {
    appLog("User is logged out");
    LocalStorage.myEmail = "";
    LocalStorage.myPassword = "";
    LocalStorage.rememberMe = false;
    LocalStorage.token = "";
    LocalStorage.setString(LocalStorageKeys.myEmail, "");
    LocalStorage.setString(LocalStorageKeys.myPassword, "");
    LocalStorage.setBool(LocalStorageKeys.rememberMe, false);
    LocalStorage.setString(LocalStorageKeys.token, "");
    Get.offAllNamed(AppRoutes.loginScreen);
  }

  void withdrawAmount() {
    Get.toNamed(AppRoutes.withdrawAmountScreen);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchProfile();
  }
}
