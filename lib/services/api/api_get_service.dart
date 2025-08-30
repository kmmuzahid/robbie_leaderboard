import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_strings.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/leader_board_model.dart';
import 'package:the_leaderboard/routes/app_routes.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';
import 'package:the_leaderboard/utils/app_logs.dart';

class ApiGetService {
  static Future<http.Response?> apiGetService(String url) async {
    try {
      appLog("hitting url: $url");
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'authorization': LocalStorage.token
      }).timeout(const Duration(seconds: 10));
      appLog("response from Get- $url: ${response.body}");
      return response;
    } on SocketException catch (e) {
      errorLog("apiGetService - No Internet", e);
      Get.snackbar(
        "Connection Error",
        AppStrings.noInternet,
        colorText: AppColors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.toNamed(AppRoutes.serverOff);
    } on TimeoutException catch (e) {
      errorLog("apiGetService - Timeout", e);
      Get.snackbar(
        "Timeout",
        AppStrings.requestTimeOut,
        colorText: AppColors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.toNamed(AppRoutes.serverOff);
    } catch (e) {
      errorLog("apiGetService - Unknown Error", e);
      Get.snackbar(
        "Error",
        AppStrings.somethingWentWrong,
        colorText: AppColors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.toNamed(AppRoutes.serverOff);
    }
    return null;
  }

  static Future<List<LeaderBoardModel?>> fetchFilteredLeaderboardData(
      {required String url,
      required String name,
      required String country,
      required String city,
      required String gender}) async {
    try {
      final response = await http.get(
        Uri.parse(url).replace(queryParameters: {
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
        appLog(data);
        return data.map((e) => LeaderBoardModel.fromJson(e)).toList();
      } else {
        Get.snackbar("Error", jsonbody["message"], colorText: AppColors.white);
        return [];
      }
    } on SocketException catch (e) {
      errorLog("apiGetService - No Internet", e);
      Get.snackbar(
        "Connection Error",
        AppStrings.noInternet,
        colorText: AppColors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.toNamed(AppRoutes.serverOff);
      return [];
    } on TimeoutException catch (e) {
      errorLog("apiGetService - Timeout", e);
      Get.snackbar(
        "Timeout",
        AppStrings.requestTimeOut,
        colorText: AppColors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.toNamed(AppRoutes.serverOff);
      return [];
    } catch (e) {
      appLog(e);
      // Get.snackbar("Error", e.toString());
      return [];
    }
  }
}
