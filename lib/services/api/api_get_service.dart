import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/faq_model.dart';
import 'package:the_leaderboard/models/hall_of_fame_single_payment_model.dart';
import 'package:the_leaderboard/models/notification_model.dart';
import 'package:the_leaderboard/models/profile_model.dart';
import 'package:the_leaderboard/models/term_and_condition_model.dart';
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
      return [];
    }
  }

  static Future<Map<String, dynamic>> fetchHallofFrameSinglePayment() async {
    final response = await http.get(Uri.parse(AppUrls.highestInvestor),
        headers: {
          'Content-Type': 'application/json',
          'authorization': LocalStorage.token
        });
    if (response.statusCode == 200) {
      final jsonbody = jsonDecode(response.body);
      final data = jsonbody["data"];
      return {"name": data["name"], "totalInvested": data["totalInvested"]};
    } else {
      return {};
    }
  }

  static Future<Map<String, dynamic>> fetchHallofFrameConsistentlyTop() async {
    final response = await http.get(Uri.parse(AppUrls.consecutiveToper),
        headers: {
          'Content-Type': 'application/json',
          'authorization': LocalStorage.token
        });
    if (response.statusCode == 200) {
      final jsonbody = jsonDecode(response.body);
      final data = jsonbody["data"];
      return {"name": data["name"], "timesRankedTop": data["timesRankedTop"]};
    } else {
      return {};
    }
  }

  static Future<Map<String, dynamic>> fetchHallofFrameEngagedProfile() async {
    final response = await http.get(Uri.parse(AppUrls.mostViewed), headers: {
      'Content-Type': 'application/json',
      'authorization': LocalStorage.token
    });
    if (response.statusCode == 200) {
      final jsonbody = jsonDecode(response.body);
      final data = jsonbody["data"];
      return {
        "name": data["name"],
        "profileImg": data["profileImg"],
        "views": data["views"].toString()
      };
    } else {
      return {};
    }
  }

  // static Future<HallOfFameModel?> fetchHallofFrame(String url) async {
  //   final response = await http.get(Uri.parse(url), headers: {
  //     'Content-Type': 'application/json',
  //     'authorization': LocalStorage.token
  //   });
  //   if (response.statusCode == 200) {
  //     final jsonbody = jsonDecode(response.body);
  //     return HallOfFameModel.fromJson(jsonbody["data"]);
  //   } else {
  //     return null;
  //   }
  // }
}
