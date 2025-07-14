import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/leader_board_model.dart';
import 'package:the_leaderboard/routes/app_routes.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';
import 'package:the_leaderboard/utils/app_logs.dart';

class ApiGetService {
  static Future<http.Response?> apiGetService(String url) async {
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'authorization': LocalStorage.token
      }).timeout(const Duration(seconds: 10));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      } else {
        errorLog("apiGetService - HTTP Error", response.body);
        Get.snackbar(
          "Server Error",
          "Received status code: ${response.statusCode}",
          colorText: AppColors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.toNamed(AppRoutes.serverOff);
      }
    } on SocketException catch (e) {
      errorLog("apiGetService - No Internet", e);
      Get.snackbar(
        "Connection Error",
        "Please check your internet connection.",
        colorText: AppColors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.toNamed(AppRoutes.serverOff);
    } on TimeoutException catch (e) {
      errorLog("apiGetService - Timeout", e);
      Get.snackbar(
        "Timeout",
        "Request timed out. Try again later.",
        colorText: AppColors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.toNamed(AppRoutes.serverOff);
    } catch (e) {
      errorLog("apiGetService - Unknown Error", e);
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

  static Future<List<LeaderBoardModel?>> fetchFilteredLeaderboardData(
      {required String name,
      required String country,
      required String city,
      required String gender}) async {
    try {
      final response = await http.get(
        Uri.parse(AppUrls.leaderBoardData).replace(queryParameters: {
          "name": name,
          "country": country,
          "city": city,
          "gender": gender,
        }),
        headers: {
          'Content-Type': 'application/json',
          'authorization': LocalStorage.token
        },
      );
      final jsonbody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final List data = jsonbody["data"];
        return data
            .map(
              (e) => LeaderBoardModel.fromJson(e),
            )
            .toList();
      } else {
        Get.snackbar("Error", jsonbody["message"]);
        return [];
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return [];
    }
  }
}
