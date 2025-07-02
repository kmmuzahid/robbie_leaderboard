import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/otp_model.dart';
import 'package:the_leaderboard/models/register_model.dart';
import 'package:the_leaderboard/models/user_model.dart';
import 'package:the_leaderboard/models/verify_otp_model.dart';
import 'package:the_leaderboard/screens/auth_screens/auth_controller.dart';

class ApiPostService {
  static final authController = Get.find<AuthController>();

  static Future<http.Response> loginUser(User user) async {
    final response = await http.post(Uri.parse(AppUrls.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()));
    return response;
  }

  static Future<http.Response> registerUser(RegisterModel profile) async {
    final response = await http.post(Uri.parse(AppUrls.registerUser),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(profile.toJson()));
    return response;
  }
  static Future<http.Response> createUser(OtpModel otp) async {
    final response = await http.post(Uri.parse(AppUrls.createUser),
        headers: {'Content-Type': 'application/json', "authorization": authController.token},
        body: jsonEncode(otp.toJson()));
    return response;
  }

  static Future<http.Response> verifyOTP(VerifyOtpModel otp) async {
    print(authController.token);
    final response = await http.post(Uri.parse(AppUrls.verifyOtp),
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
        body: jsonEncode({"email": email}));
    final data = jsonDecode(response.body);
    return data["message"];
  }

  static Future<String> setNewPassword(
      String password) async {
    final response = await http.post(Uri.parse(AppUrls.setNewPassword),
        headers: {
          'Content-Type': 'application/json',
          'authorization': authController.token
        },
        body: jsonEncode({"newPassword" : password}));   
    final data = jsonDecode(response.body);
    authController.setAccessToken(data["data"]["accessToken"]);
    return data["message"];
  }
   static Future<String> sentReport(
      String text) async {
    final response = await http.post(Uri.parse(AppUrls.reportProblem),
        headers: {
          'Content-Type': 'application/json',
          'authorization': authController.token
        },
        body: jsonEncode({"text" : text}));   
    final data = jsonDecode(response.body);   
    return data["message"];
  }
}
