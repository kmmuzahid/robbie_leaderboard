import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';

class ApiDeleteService {
  static Future<String> deleteUser() async {
    final url = "${AppUrls.deleteUser}/${LocalStorage.userId}";
    final response = await http.delete(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'authorization': LocalStorage.token
    });
    if (response.statusCode == 200) {
      final jsonbody = jsonDecode(response.body);
      return jsonbody["message"];
    } else {
      errorMessageForDelete(response.statusCode);
      return "";
    }
  }

  static void errorMessageForDelete(int statusCode) {
    switch (statusCode) {
      case 400:
        Get.snackbar("Bad Request", "The delete request was invalid.");
        break;

      case 401:
        Get.snackbar(
            "Unauthorized", "You are not authorized to delete this item.");
        break;

      case 403:
        Get.snackbar(
            "Forbidden", "You don't have permission to delete this item.");
        break;

      case 404:
        Get.snackbar("Not Found", "The item was not found or already deleted.");
        break;

      case 409:
        Get.snackbar(
            "Conflict", "Cannot delete: item is in use or has dependencies.");
        break;

      case 500:
        Get.snackbar("Server Error",
            "An error occurred while deleting. Try again later.");
        break;

      default:
        Get.snackbar(
            "Error", "Unexpected error occurred (Status Code: $statusCode)");
    }
  }
}
