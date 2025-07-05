import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/current_ruffle_model.dart';
import 'package:the_leaderboard/models/faq_model.dart';
import 'package:the_leaderboard/models/hall_of_fame_single_payment_model.dart';
import 'package:the_leaderboard/models/hall_of_frame_consisntantly_top_model.dart';
import 'package:the_leaderboard/models/hall_of_frame_most_engaged_model.dart';
import 'package:the_leaderboard/models/notification_model.dart';
import 'package:the_leaderboard/models/profile_model.dart';
import 'package:the_leaderboard/models/term_and_condition_model.dart';
import 'package:the_leaderboard/models/user_ticket_model.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';

class ApiGetService {
  static Future<ProfileUserModel?> fetchProfile() async {
    final response = await http.get(Uri.parse(AppUrls.profile), headers: {
      'Content-Type': 'application/json',
      'authorization': LocalStorage.token
    });

    if (response.statusCode == 200) {
      final jsonbody = jsonDecode(response.body);
      return ProfileUserModel.fromJson(jsonbody["data"]["user"]);
    } else {
      errorMessage(response.statusCode);
      return null;
    }
  }

  static Future<ProfileResponseModel?> fetchHomeData() async {
    final response = await http.get(Uri.parse(AppUrls.profile), headers: {
      'Content-Type': 'application/json',
      'authorization': LocalStorage.token
    });
    if (response.statusCode == 200) {
      final jsonbody = jsonDecode(response.body);
      return ProfileResponseModel.fromJson(jsonbody["data"]);
    } else {
      errorMessage(response.statusCode);
      return null;
    }
  }

  static Future<List<FaqModel?>> fetchFaq() async {
    final response = await http.get(Uri.parse(AppUrls.faq), headers: {
      'Content-Type': 'application/json',
      'authorization': LocalStorage.token
    });
    if (response.statusCode == 200) {
      final jsonbody = jsonDecode(response.body);
      final List data = jsonbody["data"];

      return data.map((e) => FaqModel.fromJson(e)).toList();
    } else {
      errorMessage(response.statusCode);
      return [];
    }
  }

  static Future<List<TermAndConditionModel?>> fetchTermAndCondition() async {
    final response = await http.get(Uri.parse(AppUrls.termAndCondition),
        headers: {
          'Content-Type': 'application/json',
          'authorization': LocalStorage.token
        });
    if (response.statusCode == 200) {
      final jsonbody = jsonDecode(response.body);
      final List data = jsonbody["data"];
      return data.map((e) => TermAndConditionModel.fromJson(e)).toList();
    } else {
      errorMessage(response.statusCode);
      return [];
    }
  }

  static Future<List<NotificationModel?>> fetchNotification() async {
    final response = await http.get(Uri.parse(AppUrls.notification), headers: {
      'Content-Type': 'application/json',
      'authorization': LocalStorage.token
    });
    print(response.body);
    if (response.statusCode == 200) {
      final jsonbody = jsonDecode(response.body);
      final List data = jsonbody["data"];
      return data.map((e) => NotificationModel.fromJson(e)).toList();
    } else {
      errorMessage(response.statusCode);
      return [];
    }
  }

  static Future<HallOfFameSinglePaymentModel?>
      fetchHallofFrameSinglePayment() async {
    final response = await http.get(Uri.parse(AppUrls.highestInvestor),
        headers: {
          'Content-Type': 'application/json',
          'authorization': LocalStorage.token
        });
    if (response.statusCode == 200) {
      final jsonbody = jsonDecode(response.body);
      return HallOfFameSinglePaymentModel.fromJson(jsonbody["data"]);
    } else {
      errorMessage(response.statusCode);
      return null;
    }
  }

  static Future<HallOfFrameConsisntantlyTopModel?>
      fetchHallofFrameConsistentlyTop() async {
    final response = await http.get(Uri.parse(AppUrls.consecutiveToper),
        headers: {
          'Content-Type': 'application/json',
          'authorization': LocalStorage.token
        });
    if (response.statusCode == 200) {
      final jsonbody = jsonDecode(response.body);
      return HallOfFrameConsisntantlyTopModel.fromJson(jsonbody["data"]);
    } else {
      errorMessage(response.statusCode);
      return null;
    }
  }

  static Future<HallOfFrameMostEngagedModel?>
      fetchHallofFrameEngagedProfile() async {
    final response = await http.get(Uri.parse(AppUrls.mostViewed), headers: {
      'Content-Type': 'application/json',
      'authorization': LocalStorage.token
    });
    if (response.statusCode == 200) {
      final jsonbody = jsonDecode(response.body);
      return HallOfFrameMostEngagedModel.fromJson(jsonbody["data"]);
    } else {
      errorMessage(response.statusCode);
      return null;
    }
  }

  static Future<CurrentRuffleModel?> fetchCurrentRuffleData() async {
    final response = await http.get(Uri.parse(AppUrls.currentRuffle), headers: {
      'Content-Type': 'application/json',
      'authorization': LocalStorage.token
    });
    final jsonbody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      Get.snackbar("Success", jsonbody["message"]);
      return CurrentRuffleModel.fromJson(jsonbody["data"]);
    } else {
      Get.snackbar("Error", jsonbody["message"]);
      return null;
    }
  }

  static Future<UserTicketsModel?> fetchUserTicket() async {
    final response = await http.get(Uri.parse(AppUrls.myTicket), headers: {
      'Content-Type': 'application/json',
      'authorization': LocalStorage.token
    });
    final jsonbody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      Get.snackbar("Success", jsonbody["message"]);
      return UserTicketsModel.fromJson(jsonbody["data"]);
    } else {
      Get.snackbar("Error", jsonbody["message"]);
      return null;
    }
  }

  static void errorMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        Get.snackbar("Bad Request", "The request was invalid.");
        break;

      case 401:
        Get.snackbar("Unauthorized", "Invalid or expired token.");
        break;

      case 403:
        Get.snackbar("Forbidden", "You do not have permission.");
        break;

      case 404:
        Get.snackbar("Not Found", "Data not found.");
        break;

      case 500:
        Get.snackbar("Server Error", "Something went wrong on the server.");
        break;

      default:
        Get.snackbar("Error", "Unexpected error (Status Code: $statusCode)");
    }
  }
}
