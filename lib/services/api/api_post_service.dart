import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/routes/app_routes.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';
import 'package:the_leaderboard/utils/app_logs.dart';

class ApiPostService {
  static Future<http.Response?> apiPostService(String url, dynamic body) async {
    try {
      final response = await http
          .post(Uri.parse(url),
              headers: {
                'Content-Type': 'application/json',
                "authorization": LocalStorage.token
              },
              body: body == null ? body : jsonEncode(body))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      } else {
        errorLog("apiPostService - HTTP Error", response.body);
        Get.snackbar(
          "Server Error",
          "Received status code: ${response.statusCode}",
          colorText: AppColors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.toNamed(AppRoutes.serverOff);
      }
    } on SocketException catch (e) {
      errorLog("apiPostService - No Internet", e);
      Get.snackbar(
        "Connection Error",
        "Please check your internet connection.",
        colorText: AppColors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.toNamed(AppRoutes.serverOff);
    } on TimeoutException catch (e) {
      errorLog("apiPostService - Timeout", e);
      Get.snackbar(
        "Timeout",
        "Request timed out. Try again later.",
        colorText: AppColors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.toNamed(AppRoutes.serverOff);
    } catch (e) {
      errorLog("apiPostService - Unknown Error", e);
      Get.snackbar(
        "Error",
        "Something went wrong. Please try again.",
        colorText: AppColors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.toNamed(AppRoutes.serverOff);
    }
    return null;
  }
}
