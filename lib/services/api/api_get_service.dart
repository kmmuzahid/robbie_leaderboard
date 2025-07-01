import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/profile_model.dart';
import 'package:the_leaderboard/screens/auth_screens/auth_controller.dart';

final authController = Get.find<AuthController>();

class ApiGetService {
  static Future<ProfileUserModel?> fetchProfile() async {
    final authController = Get.find<AuthController>();

    final response = await http.get(Uri.parse(AppUrls.profile), headers: {
      'Content-Type': 'application/json',
      'authorization': authController.token
    });
    if (response.statusCode == 200) {
      final jsonbody = jsonDecode(response.body);
      return ProfileUserModel.fromJson(jsonbody["data"]["user"]);
    } else {
      return null;
    }
  }

  static Future<ProfileResponseModel?> fetchHomeData() async {
    final authController = Get.find<AuthController>();

    final response = await http.get(Uri.parse(AppUrls.profile), headers: {
      'Content-Type': 'application/json',
      'authorization': authController.token
    });
    if (response.statusCode == 200) {
      final jsonbody = jsonDecode(response.body);
      return ProfileResponseModel.fromJson(jsonbody["data"]);
    } else {
      return null;
    }
  }

}
