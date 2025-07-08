import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/current_ruffle_model.dart';
import 'package:the_leaderboard/models/faq_model.dart';
import 'package:the_leaderboard/models/hall_of_fame_single_payment_model.dart';
import 'package:the_leaderboard/models/hall_of_frame_consisntantly_top_model.dart';
import 'package:the_leaderboard/models/hall_of_frame_most_engaged_model.dart';
import 'package:the_leaderboard/models/leader_board_model.dart';
import 'package:the_leaderboard/models/notification_model.dart';
import 'package:the_leaderboard/models/profile_model.dart';
import 'package:the_leaderboard/models/term_and_condition_model.dart';
import 'package:the_leaderboard/models/user_ticket_model.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';

class ApiGetService {
  static Future<ProfileUserModel?> fetchProfile() async {
    try {
      final response = await http.get(Uri.parse(AppUrls.profile), headers: {
        'Content-Type': 'application/json',
        'authorization': LocalStorage.token
      });
      final jsonbody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Get.snackbar("Success", jsonbody["message"]);
        return ProfileUserModel.fromJson(jsonbody["data"]["user"]);
      } else {
        Get.snackbar("Error", jsonbody["message"], colorText: AppColors.white);
        return null;
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong", colorText: AppColors.white);
      return null;
    }
  }

  static Future<ProfileResponseModel?> fetchHomeData() async {
    try {
      final response = await http.get(Uri.parse(AppUrls.profile), headers: {
        'Content-Type': 'application/json',
        'authorization': LocalStorage.token
      });
      final jsonbody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Get.snackbar("Success", jsonbody["message"]);
        return ProfileResponseModel.fromJson(jsonbody["data"]);
      } else {
        Get.snackbar("Error", jsonbody["message"], colorText: AppColors.white);
      }
    } catch (e) {
      print("error form $e");
    }
    return null;
  }

  static Future<List<FaqModel?>> fetchFaq() async {
    try {
      final response = await http.get(Uri.parse(AppUrls.faq), headers: {
        'Content-Type': 'application/json',
        'authorization': LocalStorage.token
      });
      final jsonbody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Get.snackbar("Success", jsonbody["message"]);
        final List data = jsonbody["data"];
        return data.map((e) => FaqModel.fromJson(e)).toList();
      } else {
        Get.snackbar("Error", jsonbody["message"], colorText: AppColors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong", colorText: AppColors.white);
    }
    return [];
  }

  static Future<List<TermAndConditionModel?>> fetchTermAndCondition() async {
    try {
      final response = await http.get(Uri.parse(AppUrls.termAndCondition),
          headers: {
            'Content-Type': 'application/json',
            'authorization': LocalStorage.token
          });
      final jsonbody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Get.snackbar("Success", jsonbody["message"]);
        final List data = jsonbody["data"];
        return data.map((e) => TermAndConditionModel.fromJson(e)).toList();
      } else {
        Get.snackbar("Error", jsonbody["message"], colorText: AppColors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong", colorText: AppColors.white);
    }
    return [];
  }

  static Future<List<NotificationModel?>> fetchNotification() async {
    try {
      final response = await http.get(Uri.parse(AppUrls.notification),
          headers: {
            'Content-Type': 'application/json',
            'authorization': LocalStorage.token
          });
      print(response.body);
      final jsonbody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Get.snackbar("Success", jsonbody["message"]);
        final List data = jsonbody["data"];
        return data.map((e) => NotificationModel.fromJson(e)).toList();
      } else {
        Get.snackbar("Error", jsonbody["message"], colorText: AppColors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong", colorText: AppColors.white);
    }
    return [];
  }

  static Future<HallOfFameSinglePaymentModel?>
      fetchHallofFrameSinglePayment() async {
    try {
      final response = await http.get(Uri.parse(AppUrls.highestInvestor),
          headers: {
            'Content-Type': 'application/json',
            'authorization': LocalStorage.token
          });
      final jsonbody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Get.snackbar("Success", jsonbody["message"]);
        return HallOfFameSinglePaymentModel.fromJson(jsonbody["data"]);
      } else {
        Get.snackbar("Error", jsonbody["message"], colorText: AppColors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong", colorText: AppColors.white);
    }
    return null;
  }

  static Future<HallOfFrameConsisntantlyTopModel?>
      fetchHallofFrameConsistentlyTop() async {
    try {
      final response = await http.get(Uri.parse(AppUrls.consecutiveToper),
          headers: {
            'Content-Type': 'application/json',
            'authorization': LocalStorage.token
          });
      final jsonbody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Get.snackbar("Success", jsonbody["message"]);
        return HallOfFrameConsisntantlyTopModel.fromJson(jsonbody["data"]);
      } else {
        Get.snackbar("Error", jsonbody["message"], colorText: AppColors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong", colorText: AppColors.white);
    }
    return null;
  }

  static Future<HallOfFrameMostEngagedModel?>
      fetchHallofFrameEngagedProfile() async {
    try {
      final response = await http.get(Uri.parse(AppUrls.mostViewed), headers: {
        'Content-Type': 'application/json',
        'authorization': LocalStorage.token
      });
      final jsonbody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Get.snackbar("Success", jsonbody["message"]);
        return HallOfFrameMostEngagedModel.fromJson(jsonbody["data"]);
      } else {
        Get.snackbar("Error", jsonbody["message"], colorText: AppColors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong", colorText: AppColors.white);
    }
    return null;
  }

  static Future<CurrentRuffleModel?> fetchCurrentRuffleData() async {
    try {
      final response = await http.get(Uri.parse(AppUrls.currentRuffle),
          headers: {
            'Content-Type': 'application/json',
            'authorization': LocalStorage.token
          });
      final jsonbody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Get.snackbar("Success", jsonbody["message"]);
        return CurrentRuffleModel.fromJson(jsonbody["data"]);
      } else {
        Get.snackbar("Error", jsonbody["message"], colorText: AppColors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong", colorText: AppColors.white);
    }
    return null;
  }

  static Future<UserTicketsModel?> fetchUserTicket() async {
    try {
      final response = await http.get(Uri.parse(AppUrls.myTicket), headers: {
        'Content-Type': 'application/json',
        'authorization': LocalStorage.token
      });
      final jsonbody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Get.snackbar("Success", jsonbody["message"]);
        return UserTicketsModel.fromJson(jsonbody["data"]);
      } else {
        Get.snackbar("Error", jsonbody["message"], colorText: AppColors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong", colorText: AppColors.white);
    }
    return null;
  }

  static Future<List<LeaderBoardModel?>> fetchLeaderboardData() async {
    try {
      final response = await http.get(Uri.parse(AppUrls.leaderBoardData),
          headers: {
            'Content-Type': 'application/json',
            'authorization': LocalStorage.token
          });

      final jsonbody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Get.snackbar("Success", jsonbody["message"]);
        final List data = jsonbody["data"];
        return data.map((e) => LeaderBoardModel.fromJson(e)).toList();
      } else {
        Get.snackbar("Error", jsonbody["message"], colorText: AppColors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong", colorText: AppColors.white);
    }
    return [];
  }

  static Future<ProfileUserModel?> fetchOtherProfile(String userId) async {
    final url = "${AppUrls.otherUserProfile}/$userId";
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'authorization': LocalStorage.token
      });
      final jsonbody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Get.snackbar("Success", jsonbody["message"]);
        return ProfileUserModel.fromJson(jsonbody["data"]["user"]);
      } else {
        Get.snackbar("Error", jsonbody["message"], colorText: AppColors.white);
        return null;
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong", colorText: AppColors.white);
      return null;
    }
  }
}
