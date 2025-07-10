import 'dart:convert';

import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/routes/app_routes.dart';
import 'package:the_leaderboard/services/api/api_delete_service.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';

class SettingController extends GetxController {
  void deleteUser() async {
    final url = "${AppUrls.deleteUser}/${LocalStorage.userId}";
    final response = await ApiDeleteService.apiDeleteService(url);
    if (response != null) {
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Get.snackbar("Success", data["message"]);
        Get.toNamed(AppRoutes.registerScreen);
      } else {
        Get.snackbar("Error", data["message"]);
      }
    }
  }
}
