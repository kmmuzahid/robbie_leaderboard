import 'package:get/get.dart';
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
    final profile = await ApiGetService.fetchOtherProfile(userId);
    isLoading.value = false;
    if (profile != null) {
      name.value = profile.name;
      email.value = profile.email;
      totalSpent.value = profile.totalInvest.toString();
      totalViews.value = profile.views.toString();
      rank.value = profile.rank.toString();
    }   
  }
}
