import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_strings.dart';
import 'package:the_leaderboard/models/leader_board_model.dart';
import 'package:the_leaderboard/routes/app_routes.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';
import 'package:the_leaderboard/utils/app_logs.dart';

class ApiGetService {
  static Future<http.Response?> apiGetService(String url) async {
    try {
      appLog("hitting url: $url");
      final token = LocalStorage.token;
      appLog("Token: $token");
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'authorization': token,
      }).timeout(const Duration(seconds: 40));
      appLog("response from Get- $url: ${response.body}");
      return response;
    } on SocketException catch (e) {
      errorLog("apiGetService - No Internet", e);
      Get.snackbar(
        "Connection Error",
        AppStrings.noInternet,
        colorText: AppColors.white,
      );
      Get.toNamed(AppRoutes.serverOff);
    } on TimeoutException catch (e) {
      errorLog("apiGetService - Timeout", e);
      Get.snackbar(
        "Timeout",
        AppStrings.requestTimeOut,
        colorText: AppColors.white,
      );
      Get.toNamed(AppRoutes.serverOff);
    } catch (e) {
      errorLog("apiGetService - Unknown Error", e);
      Get.snackbar(
        "Error",
        AppStrings.somethingWentWrong,
        colorText: AppColors.white,
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
      final link = Uri.parse(url).replace(queryParameters: {
        if (name.isNotEmpty) "searchTerm": name,
        if (country.isNotEmpty) "country": country,
        if (city.isNotEmpty) "city": city,
        if (gender.isNotEmpty) "gender": gender,
      });
      appLog(link);
      final response = await http.get(
        link,
        headers: {
          'Content-Type': 'application/json',
          'authorization': LocalStorage.token
        },
      );
      appLog(response.body);
      final jsonbody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final List data = jsonbody["data"];
        appLog(data);
        return data.map((e) => LeaderBoardModel.fromJson(e)).toList();
      } else {
        appLog(jsonbody["message"]);
        // Get.snackbar("Error", jsonbody["message"], colorText: AppColors.white);
        return [];
      }
    } on SocketException catch (e) {
      errorLog("apiGetService - No Internet", e);
      Get.snackbar(
        "Connection Error",
        AppStrings.noInternet,
        colorText: AppColors.white,
      );
      Get.toNamed(AppRoutes.serverOff);
      return [];
    } on TimeoutException catch (e) {
      errorLog("apiGetService - Timeout", e);
      Get.snackbar(
        "Timeout",
        AppStrings.requestTimeOut,
        colorText: AppColors.white,
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
