import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';

class ApiPostService {
  static Future<http.Response?> apiPostService(String url, dynamic body) async {
    try {
      final response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            "authorization": LocalStorage.token
          },
          body: jsonEncode(body));

      return response;
    } catch (e) {
      Get.snackbar("Error", "Something went wrong", colorText: AppColors.white);
    }
    return null;
  }

  // static Future<Map<String, dynamic>?> loginUser(User user) async {
  //   try {
  //     final response = await http.post(Uri.parse(AppUrls.login),
  //         headers: {'Content-Type': 'application/json'},
  //         body: jsonEncode(user.toJson()));

  //     final data = jsonDecode(response.body);
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       Get.snackbar("Success", data["message"], colorText: AppColors.white);
  //       return data;
  //     } else {
  //       Get.snackbar("Error", data["message"] ?? "Login Failed");
  //       return null;
  //     }
  //   } catch (e) {
  //     Get.snackbar("Error", "Something went wrong");

  //     return null;
  //   }
  // }

  // static Future<Map<String, dynamic>?> registerUser(
  //     RegisterModel profile) async {
  //   final response = await http.post(Uri.parse(AppUrls.registerUser),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode(profile.toJson()));

  //   final data = jsonDecode(response.body);
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     Get.snackbar("Success", data["message"], colorText: AppColors.white);
  //     return data;
  //   } else {
  //     Get.snackbar("Error", data["message"] ?? "Registration Failed",
  //         colorText: AppColors.white);
  //     return null;
  //   }
  // }

  // static Future<Map<String, dynamic>?> createUser(OtpModel otp) async {
  //   final response = await http.post(Uri.parse(AppUrls.createUser),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         "authorization": LocalStorage.token
  //       },
  //       body: jsonEncode(otp.toJson()));
  //   final data = jsonDecode(response.body);
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     Get.snackbar("Success", data["message"],
  //         snackPosition: SnackPosition.BOTTOM, colorText: AppColors.white);
  //     return data;
  //   } else {
  //     Get.snackbar("Error", data["message"] ?? "Login Failed",
  //         snackPosition: SnackPosition.BOTTOM, colorText: AppColors.white);
  //     return null;
  //   }
  // }

  // static Future<Map<String, dynamic>?> verifyOTP(VerifyOtpModel otp) async {
  //   final response = await http.post(Uri.parse(AppUrls.verifyOtp),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'authorization': LocalStorage.token
  //       },
  //       body: jsonEncode(otp.toJson()));
  //   final data = jsonDecode(response.body);
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     Get.snackbar("Success", data["message"],
  //         snackPosition: SnackPosition.BOTTOM, colorText: AppColors.white);
  //     return data;
  //   } else {
  //     Get.snackbar("Error", data["message"] ?? "Something went wrong",
  //         snackPosition: SnackPosition.BOTTOM, colorText: AppColors.white);
  //     return null;
  //   }
  // }

  // static Future<void> resentOtp(String url) async {
  //   final response = await http.post(
  //     Uri.parse(url),
  //   );
  //   final data = jsonDecode(response.body);
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     Get.snackbar("Success", data["message"],
  //         snackPosition: SnackPosition.BOTTOM, colorText: AppColors.white);
  //   } else {
  //     Get.snackbar("Error", data["message"] ?? "Something went wrong",
  //         snackPosition: SnackPosition.BOTTOM, colorText: AppColors.white);
  //   }
  // }

  // static Future<void> forgetPassword(String email) async {
  //   final response = await http.post(Uri.parse(AppUrls.forgetPassword),
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode({"email": email}));
  //   final data = jsonDecode(response.body);
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     Get.snackbar("Success", data["message"],
  //         snackPosition: SnackPosition.BOTTOM, colorText: AppColors.white);
  //   } else {
  //     Get.snackbar("Error", data["message"] ?? "Something went wrong",
  //         snackPosition: SnackPosition.BOTTOM, colorText: AppColors.white);
  //   }
  // }

  // static Future<void> setNewPassword(String password) async {
  //   final response = await http.post(Uri.parse(AppUrls.setNewPassword),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'authorization': LocalStorage.token
  //       },
  //       body: jsonEncode({"newPassword": password}));
  //   final data = jsonDecode(response.body);
  //   final token = data["data"]["accessToken"];
  //   LocalStorage.token = token;
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     Get.snackbar("Success", data["message"],
  //         snackPosition: SnackPosition.BOTTOM, colorText: AppColors.white);
  //   } else {
  //     Get.snackbar("Error", data["message"] ?? "Something went wrong",
  //         snackPosition: SnackPosition.BOTTOM, colorText: AppColors.white);
  //   }
  // }

  // static Future<void> sentReport(String text) async {
  //   final response = await http.post(Uri.parse(AppUrls.reportProblem),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'authorization': LocalStorage.token
  //       },
  //       body: jsonEncode({"text": text}));
  //   final data = jsonDecode(response.body);
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     Get.snackbar("Success", data["message"],
  //         snackPosition: SnackPosition.BOTTOM, colorText: AppColors.white);
  //   } else {
  //     Get.snackbar("Error", data["message"] ?? "Something went wrong",
  //         snackPosition: SnackPosition.BOTTOM, colorText: AppColors.white);
  //   }
  // }

  // static Future<void> changePassword(
  //     String oldPassword, String newPassword) async {
  //   final response = await http.post(Uri.parse(AppUrls.changePassword),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'authorization': LocalStorage.token
  //       },
  //       body: jsonEncode(
  //           {"oldPassword": oldPassword, "newPassword": newPassword}));
  //   final data = jsonDecode(response.body);
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     Get.snackbar("Success", data["message"],
  //         snackPosition: SnackPosition.BOTTOM, colorText: AppColors.white);
  //   } else {
  //     Get.snackbar("Error", data["message"] ?? "Something went wrong",
  //         snackPosition: SnackPosition.BOTTOM, colorText: AppColors.white);
  //   }
  // }

  // static Future<void> createTicket(int quantity) async {
  //   final response = await http.post(Uri.parse(AppUrls.createTicket),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'authorization': LocalStorage.token
  //       },
  //       body: jsonEncode({"qty": quantity}));
  //   final data = jsonDecode(response.body);
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     Get.snackbar("Success", data["message"],
  //         snackPosition: SnackPosition.BOTTOM, colorText: AppColors.white);
  //   } else {
  //     Get.snackbar("Error", data["message"] ?? "Something went wrong",
  //         snackPosition: SnackPosition.BOTTOM, colorText: AppColors.white);
  //   }
  // }

  // static Future<void> withdrawAmount(int amount) async {
  //   final response = await http.post(Uri.parse(AppUrls.withdrawAmount),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'authorization': LocalStorage.token
  //       },
  //       body: jsonEncode({"amount": amount}));
  //   final data = jsonDecode(response.body);
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     Get.snackbar("Success", data["message"],
  //         snackPosition: SnackPosition.BOTTOM, colorText: AppColors.white);
  //   } else {
  //     Get.snackbar("Error", data["message"] ?? "Something went wrong",
  //         snackPosition: SnackPosition.BOTTOM, colorText: AppColors.white);
  //   }
  // }

  // static Future<String> joinLeaderboard(int amount) async {
  //   final response = await http.post(Uri.parse(AppUrls.joinLeaderboard),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'authorization': LocalStorage.token
  //       },
  //       body: jsonEncode({"amount": amount}));
  //   final data = jsonDecode(response.body);
  //   print(data);
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     Get.snackbar("Success", data["message"],
  //         snackPosition: SnackPosition.BOTTOM, colorText: AppColors.white);
  //     return data["data"];
  //   } else {
  //     Get.snackbar("Error", data["message"] ?? "Something went wrong",
  //         snackPosition: SnackPosition.BOTTOM, colorText: AppColors.white);
  //     return "";
  //   }
  // }
}
