import 'dart:convert';

import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/profile_model.dart';
import 'package:the_leaderboard/routes/app_routes.dart';
import 'package:the_leaderboard/screens/notification_screen/controller/notification_controller.dart';
import 'package:the_leaderboard/services/api/api_get_service.dart';
import 'package:the_leaderboard/services/storage/storage_keys.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';
import 'package:the_leaderboard/utils/app_logs.dart';

class ProfileScreenController extends GetxController {
  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final RxDouble totalBalance = 0.0.obs;
  final RxDouble totalSpent = 0.0.obs;
  final RxString totalViews = ''.obs;
  final RxString creatorCode = ''.obs;
  final RxString rank = ''.obs;
  final RxBool isLoading = true.obs;
  final RxString image = "".obs;
  final RxString facebookUrl = "".obs;
  final RxString instagramUrl = "".obs;
  final RxString twitterUrl = "".obs;
  final RxString linkedinUrl = "".obs;
  final RxString youtubeUrl = "".obs;
  final notificationController = Get.find<NotificationController>();
  Future fetchProfile() async {
    try {
      appLog("Profile data is fetching");
      isLoading.value = true;
      final response = await ApiGetService.apiGetService(AppUrls.profile);
      isLoading.value = false;
      if (response != null) {
        appLog(response.body);
        final data = jsonDecode(response.body);
        if (response.statusCode == 200) {
          final profile = ProfileUserModel.fromJson(data["data"]["user"]);
          name.value = profile.name;
          email.value = profile.email;
          totalBalance.value = profile.totalAdminAmount.toDouble();
          totalSpent.value = profile.totalInvest.toDouble();
          totalViews.value = profile.views.toString();
          creatorCode.value = profile.userCode;
          rank.value = profile.rank.toString();
          image.value = profile.profileImg;
          facebookUrl.value = profile.facebook;
          instagramUrl.value = profile.instagram;
          twitterUrl.value = profile.twitter;
          linkedinUrl.value = profile.linkedin;
          youtubeUrl.value = profile.youtube;
          LocalStorage.myName = profile.name;
          LocalStorage.userId = profile.id;
          appLog("user id: ${profile.id} and token: ${LocalStorage.token}");
        } else {
          Get.closeAllSnackbars();
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
    LocalStorage.userId = "";
    LocalStorage.setString(LocalStorageKeys.userId, "");
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
