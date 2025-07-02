import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/faq_model.dart';
import 'package:the_leaderboard/models/profile_model.dart';
import 'package:the_leaderboard/models/term_and_condition_model.dart';
import 'package:the_leaderboard/screens/auth_screens/auth_controller.dart';

class ApiGetService {
  static final authController = Get.find<AuthController>();

  static Future<ProfileUserModel?> fetchProfile() async {
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

  static Future<List<FaqModel?>> fetchFaq() async {
    final response = await http.get(Uri.parse(AppUrls.faq), headers: {
      'Content-Type': 'application/json',
      'authorization': authController.token
    });
    if (response.statusCode == 200) {
      final jsonbody = jsonDecode(response.body);
      final List data = jsonbody["data"];

      return data.map((e) => FaqModel.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  static Future<List<TermAndConditionModel?>> fetchTermAndCondition() async {
    final response = await http.get(Uri.parse(AppUrls.termAndCondition), headers: {
      'Content-Type': 'application/json',
      'authorization': authController.token
    });   
    if (response.statusCode == 200) {
      final jsonbody = jsonDecode(response.body);
       final List data = jsonbody["data"];
      return data.map((e) => TermAndConditionModel.fromJson(e)).toList();
    } else {
      return [];
    }
  }

}
