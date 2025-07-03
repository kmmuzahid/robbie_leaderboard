import 'package:get/get.dart';
import 'package:the_leaderboard/services/api/api_get_service.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';

class ProfileScreenController extends GetxController {
  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final RxString totalBalance = ''.obs;
  final RxString totalSpent = ''.obs;
  final RxString totalViews = ''.obs;
  final RxString creatorCode = ''.obs;
  final RxString rank = ''.obs;
  final RxBool isLoading = true.obs;

  void fetchProfile() async {
    isLoading.value = true;
    final profile = await ApiGetService.fetchProfile();
    isLoading.value = false;
    if (profile != null) {
      name.value = profile.name;
      email.value = profile.email;
      totalBalance.value = profile.totalAdminAmount.toString();
      totalSpent.value = profile.totalInvest.toString();
      totalViews.value = profile.views.toString();
      creatorCode.value = profile.userCode;
      rank.value = profile.rank.toString();
      LocalStorage.userId = profile.id;
      print("user id: ${profile.id}");
      print("token: ${LocalStorage.token}");
    } else {
      Get.snackbar("Error", "Something went wrong");
    }
  }
}
