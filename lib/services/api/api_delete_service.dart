import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';

class ApiDeleteService {
  static Future<http.Response?> apiDeleteService(String url) async {
    try {
      final response = await http.delete(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'authorization': StorageService.token
      });
      return response;
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong",
        colorText: AppColors.white,
      );
    }
    return null;
  }
}
