import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';

class ApiPatchService {
  static Future<void> updateProfile(
    String? name,
    String? contact,
    String? country,
    String? city,
    String? gender,
    String? age,
    String? role,
  ) async {
    final url = "${AppUrls.updateUser}/${LocalStorage.userId}";

    try {
      final Map<String, dynamic> updateData = {};

      if (name != null) updateData['name'] = name;
      if (contact != null) updateData['contact'] = contact;
      if (country != null) updateData['country'] = country;
      if (city != null) updateData['city'] = city;
      if (gender != null) updateData['gender'] = gender;
      if (age != null) updateData['age'] = age;
      if (role != null) updateData['role'] = role;

      if (updateData.isEmpty) {
        Get.snackbar("Info", "No data to update");
        return;
      }

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'authorization': LocalStorage.token,
        },
        body: jsonEncode(updateData),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        Get.snackbar("Success", "Profile updated successfully");
      } else {
        errorMessageForPatch(response.statusCode);
        Get.snackbar("Error",
            "Failed to update profile. Status code: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }

  static void errorMessageForPatch(int statusCode) {
    switch (statusCode) {
      case 400:
        Get.snackbar("Bad Request", "The update data was invalid.");
        break;

      case 401:
        Get.snackbar("Unauthorized", "You are not authorized to update this.");
        break;

      case 403:
        Get.snackbar("Forbidden", "You don't have permission to update.");
        break;

      case 404:
        Get.snackbar("Not Found", "The item you want to update was not found.");
        break;

      case 409:
        Get.snackbar("Conflict", "Update conflict occurred. Try again.");
        break;

      case 500:
        Get.snackbar(
            "Server Error", "Failed to update. Server error occurred.");
        break;

      default:
        Get.snackbar("Error", "Unexpected error (Status Code: $statusCode)");
    }
  }
}
