import 'dart:convert';

import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/profile_model.dart';
import 'package:the_leaderboard/services/api/api_get_service.dart';
import 'package:the_leaderboard/utils/app_common_function.dart';
import 'package:the_leaderboard/utils/app_logs.dart';

class OtherProfileController extends GetxController {
  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final RxString totalSpent = ''.obs;
  final RxString totalViews = ''.obs;
  final RxString rank = ''.obs;
  final RxBool isLoading = true.obs;
  final RxString profileImage = "".obs;
  final RxString facebookUrl = "".obs;
  final RxString instagramUrl = "".obs;
  final RxString twitterUrl = "".obs;
  final RxString linkedinUrl = "".obs;
  final RxString youtubeUrl = "".obs;
  final RxString bio = "".obs;
  final RxString shoutTitle = ''.obs;
  final RxString shoutContent = ''.obs;

  final userId = "".obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    final args = Get.arguments;
    userId.value = args;
    appLog(userId.value);
    fetchProfile();
  }

  void fetchProfile() async {
    try {
      appLog("other profile data is loading");
      isLoading.value = true;
      final url = "${AppUrls.otherUserProfile}/${userId.value}";
      final response = await ApiGetService.apiGetService(url);
      isLoading.value = false;
      if (response != null) {
        final jsonbody = jsonDecode(response.body);

        if (response.statusCode == 200) {
          final shout = jsonbody['data']['shout'];
          if (shout != null) {
            shoutTitle.value = shout['title'];
            shoutContent.value = shout['description'];
          }
          final profile = ProfileUserModel.fromJson(jsonbody["data"]["user"]);
          name.value = profile.name;
          email.value = profile.email;
          totalSpent.value = AppCommonFunction.formatNumber(profile.totalInvest);
          totalViews.value = jsonbody["data"]["views"].toString();
          rank.value = profile.rank.toString();
          profileImage.value = profile.profileImg;
          facebookUrl.value = profile.facebook;
          instagramUrl.value = profile.instagram;
          twitterUrl.value = profile.twitter;
          linkedinUrl.value = profile.linkedin;
          youtubeUrl.value = profile.youtube;
          bio.value = profile.bio;
          appLog("Profile image of other users");
          appLog(profileImage.value);
          appLog(facebookUrl.value);
        } else {
          Get.snackbar(
            "Error",
            jsonbody["message"],
            colorText: AppColors.white,
          );
        }
      }
      appLog("Succeed");
    } catch (e) {
      appLog("Succeed");
    } finally {
      update();
    }
    return;
  }
}
