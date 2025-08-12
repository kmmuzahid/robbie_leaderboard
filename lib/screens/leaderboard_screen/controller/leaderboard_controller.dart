import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/country_leaderboard_model.dart';
import 'package:the_leaderboard/models/leader_board_model.dart';
import 'package:the_leaderboard/services/api/api_get_service.dart';
import 'package:the_leaderboard/utils/app_logs.dart';

class LeaderboardController extends GetxController {
  final RxList<LeaderBoardModel?> leaderBoardList = <LeaderBoardModel>[].obs;
  final RxList<LeaderBoardModel?> creatorList = <LeaderBoardModel>[].obs;
  final RxList<CountryLeaderboardModel?> countryList =
      <CountryLeaderboardModel>[].obs;

  final RxBool isLoading = true.obs;

  final ScrollController scrollController = ScrollController();
  final double eachItemHeight = 50.0;
  Timer? refreshTimer;

  void fetchData() {
    fetchLeaderBoardData();
    fetchCountryData();
    fetchCreatorData();
    refreshTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      fetchLeaderBoardData();
      fetchCountryData();
      fetchCreatorData(); // repeat fetch
    });
  }

  void fetchLeaderBoardData() async {
    try {
      appLog("leaderboard data is fetching");
      isLoading.value = true;
      final response =
          await ApiGetService.apiGetService(AppUrls.leaderBoardData);
      isLoading.value = false;
      if (response != null) {
        final jsonbody = jsonDecode(response.body);
        if (response.statusCode == 200) {
          final List data = jsonbody["data"];
          leaderBoardList.value =
              data.map((e) => LeaderBoardModel.fromJson(e)).toList();
          appLog(leaderBoardList.map(
            (element) => element!.profileImg,
          ));
          leaderBoardList.sort(
            (a, b) => a!.currentRank.compareTo(b!.currentRank),
          );
        } else {
          Get.snackbar("Error", jsonbody["message"],
              colorText: AppColors.white);
        }
      }
      appLog("Succeed");
    } catch (e) {
      errorLog("Failed", e);
    }
    return;
  }

  void fetchCreatorData() async {
    try {
      appLog("creator data is fetching");
      isLoading.value = true;
      final response =
          await ApiGetService.apiGetService(AppUrls.creatorLeaderboard);
      isLoading.value = false;
      if (response != null) {
        final jsonbody = jsonDecode(response.body);
        if (response.statusCode == 200) {
          final List data = jsonbody["data"];
          creatorList.value =
              data.map((e) => LeaderBoardModel.fromJson(e)).toList();
          appLog(creatorList.map(
            (element) => element!.profileImg,
          ));
          creatorList.sort(
            (a, b) => a!.currentRank.compareTo(b!.currentRank),
          );
        } else {
          Get.snackbar("Error", jsonbody["message"],
              colorText: AppColors.white);
        }
      }
      appLog("Succeed");
    } catch (e) {
      errorLog("Failed", e);
    }
    return;
  }

  void fetchCountryData() async {
    try {
      appLog("leaderboard data is fetching");
      isLoading.value = true;
      final response =
          await ApiGetService.apiGetService(AppUrls.countryLeaderboard);
      isLoading.value = false;
      if (response != null) {
        final jsonbody = jsonDecode(response.body);
        appLog(response.body);
        if (response.statusCode == 200) {
          final List data = jsonbody["data"]["data"];
          countryList.value =
              data.map((e) => CountryLeaderboardModel.fromJson(e)).toList();

          countryList.sort(
            (a, b) => b!.totalInvest.compareTo(a!.totalInvest),
          );
        } else {
          Get.snackbar("Error", jsonbody["message"],
              colorText: AppColors.white);
        }
      }
      appLog("Succeed");
    } catch (e) {
      errorLog("Failed", e);
    }
    return;
  }
}
