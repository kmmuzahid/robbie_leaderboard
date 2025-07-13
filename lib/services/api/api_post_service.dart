import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/routes/app_routes.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';

class ApiPostService {
  static Future<http.Response?> apiPostService(String url, dynamic body) async {
    try {
      final response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            "authorization": LocalStorage.token
          },
          body: body == null ? body : jsonEncode(body));

      return response;
    } catch (e) {
      Get.snackbar("Error", "Something went wrong", colorText: AppColors.red);
      Get.toNamed(AppRoutes.serverOff);
    }
    return null;
  }
}
