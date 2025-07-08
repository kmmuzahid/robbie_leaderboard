import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';

class ApiDeleteService {
  static Future<void> deleteUser() async {
    final url = "${AppUrls.deleteUser}/${LocalStorage.userId}";
    try {
      final response = await http.delete(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'authorization': LocalStorage.token
      });
      final jsonbody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Get.snackbar("Success", jsonbody["message"], colorText: AppColors.white);
        return;
      } else {
        Get.snackbar("Error", jsonbody["message"], colorText: AppColors.white);
        return;
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong", colorText: AppColors.white);
      return;
    }
  }
}
