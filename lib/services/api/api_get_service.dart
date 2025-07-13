import 'dart:convert';
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
      });
      return response;
    } catch (e) {
      errorLog("apiGetService", e);
      Get.snackbar("Error", "Something went wrong",
          colorText: AppColors.white, snackPosition: SnackPosition.BOTTOM);
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
