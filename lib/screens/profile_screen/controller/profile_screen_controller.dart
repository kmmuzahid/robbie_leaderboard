import 'package:get/get.dart';
import 'package:the_leaderboard/screens/auth_screens/auth_controller.dart';
import 'package:the_leaderboard/services/api/api_get_service.dart';

class ProfileScreenController extends GetxController {
  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final RxString totalBalance = ''.obs;
  final RxString totalSpent = ''.obs;
  final RxString totalViews = ''.obs;
  final RxString creatorCode = ''.obs;
  final RxString rank = ''.obs;
  final RxBool isLoading = true.obs;
  final _authController = Get.find<AuthController>();
  void fetchProfile() async {
    print(_authController.token);   
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
      _authController.setUserId(profile.id);      
    } else {
      Get.snackbar("Error", "Something went wrong");
    }
  }
}
