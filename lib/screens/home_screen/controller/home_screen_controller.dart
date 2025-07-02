import 'dart:convert';

import 'package:get/get.dart';
import 'package:the_leaderboard/services/api/api_get_service.dart';

class HomeScreenController extends RxController {
  final RxString name = ''.obs;
  final RxString totalRaised = ''.obs;
  final RxString totalSpent = ''.obs;
  final RxInt rank = 0.obs;

  final RxBool isLoading = true.obs;
  void fetchData() async {
    try {
      isLoading.value = true;
      final data = await ApiGetService.fetchHomeData();
      
      if(data != null){
        final userData = data.user;
        name.value = userData.name;
        totalRaised.value = userData.totalRaised.toString();
        totalSpent.value = userData.totalInvest.toString();
        rank.value = userData.rank;
      }
      isLoading.value = false;
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    }
  }
}
