import 'dart:convert';

import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/screens/auth_screens/auth_controller.dart';

class ApiPatchService {
  static final authController = Get.find<AuthController>();

  static Future<void> updateProfile(
      String? name,
      String? contact,
      String? country,
      String? city,
      String? gender,
      String? age,
      String? role) async {
    final url = "${AppUrls.updateUser}/${authController.getUserId}";
    try {
      if (name != null) {
        await http.patch(Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'authorization': authController.token
            },
            body: jsonEncode({"name": name}));
      }
      if (country != null) {
        await http.patch(Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({"country": country}));
      }
      if (contact != null) {
        await http.patch(Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({"contact": contact}));
      }
      if (city != null) {
        await http.patch(Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({"city": city}));
      }
      if (gender != null) {
        await http.patch(Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({"gender": gender}));
      }
      if (age != null) {
        await http.patch(Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({"age": age}));
      }
      if (role != null) {
        await http.patch(Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({"role": role}));
      }
      Get.snackbar("Success", "Successfully updated");
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    }
  }
}
