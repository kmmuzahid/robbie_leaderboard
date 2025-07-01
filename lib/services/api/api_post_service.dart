import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/otp_model.dart';
import 'package:the_leaderboard/models/password_reset_model.dart';
import 'package:the_leaderboard/models/register_model.dart';
import 'package:the_leaderboard/models/user_model.dart';
import 'package:the_leaderboard/screens/auth_screens/auth_controller.dart';

final authController = Get.find<AuthController>();

class ApiPostService {
  static Future<http.Response> loginUser(User user) async {
    final response = await http.post(Uri.parse(AppUrls.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()));
    return response;
  }

  static Future<http.Response> createUser(RegisterModel profile) async {
    final response = await http.post(Uri.parse(AppUrls.createUser),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(profile.toJson()));
    return response;
  }

  static Future<http.Response> verifyOTP(OtpModel otp) async {
    final response = await http.post(Uri.parse(AppUrls.otp),
        headers: {
          'Content-Type': 'application/json',
          'authorization': authController.token
        },
        body: jsonEncode(otp.toJson()));
    return response;
  }

  static Future<String> resentOtp(String url) async {
    final response = await http.post(
      Uri.parse(url),
    );
    final data = jsonDecode(response.body);
    return data["message"];
  }

  static Future<String> forgetPassword(String email) async {
    final response = await http.post(Uri.parse(AppUrls.forgetPassword),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(email));
    final data = jsonDecode(response.body);
    return data["message"];
  }

  static Future<String> setNewPassword(
      PasswordResetModel password_reset_model) async {
    final response = await http.post(Uri.parse(AppUrls.forgetPassword),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(password_reset_model));
    final data = jsonDecode(response.body);
    return data["message"];
  }
}
