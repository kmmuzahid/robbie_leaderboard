import 'dart:async';
import 'dart:convert';

import 'package:country_state_city/country_state_city.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/country_leaderboard_model.dart';
import 'package:the_leaderboard/models/leader_board_model.dart';
import 'package:the_leaderboard/models/leader_board_model_raised.dart';
import 'package:the_leaderboard/screens/profile_screen/controller/profile_screen_controller.dart';
import 'package:the_leaderboard/services/api/api_get_service.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';
import 'package:the_leaderboard/utils/app_logs.dart';

class LeaderboardController extends GetxController {
  final RxList<LeaderBoardModel?> leaderBoardList = <LeaderBoardModel>[].obs;
  final RxList<LeaderBoardModelRaised?> creatorList =
      <LeaderBoardModelRaised>[].obs;
  final RxList<CountryLeaderboardModel> countryList =
      <CountryLeaderboardModel>[].obs;
  final RxList<LeaderBoardModel?> leaderBoardDailyList =
      <LeaderBoardModel>[].obs;
  final RxList<LeaderBoardModelRaised?> creatorDailyList =
      <LeaderBoardModelRaised>[].obs;
  final RxList<CountryLeaderboardModel> countryDailyList =
      <CountryLeaderboardModel>[].obs;
  final RxList<LeaderBoardModel?> leaderBoardMonthlyList =
      <LeaderBoardModel>[].obs;
  final RxList<LeaderBoardModelRaised?> creatorMonthlyList =
      <LeaderBoardModelRaised>[].obs;
  final RxList<CountryLeaderboardModel> countryMonthlyList =
      <CountryLeaderboardModel>[].obs;

  final RxBool isLoading = false.obs;
  final isLoadingCreator = false.obs;
  final isLoadingCountry = false.obs;

  final RxBool isLoadingToday = false.obs;
  final isLoadingCreatorToday = false.obs;
  final isLoadingCountryToday = false.obs;

  final RxBool isLoadingMonthly = false.obs;
  final isLoadingCreatorMonthly = false.obs;
  final isLoadingCountryMonthly = false.obs;

  final ScrollController scrollController = ScrollController();
  final double eachItemHeight = 50.0;
  Timer? refreshTimer;
  final userId = "".obs;
  final isoCodes = <String>[].obs;

  void fetchData() async {
    try {
      fetchLeaderBoardData();
      fetchCountryData();
      fetchCreatorData();
      fetchLeaderBoardDataDaily();
      fetchLeaderBoardDataMonthly();
      fetchCreatorDataDaily();
      fetchCreatorDataMonthly();
      fetchCountryDataDaily();
      fetchCountryDataMonth();
      Get.put(ProfileScreenController());
      await Get.find<ProfileScreenController>().fetchProfile();
      userId.value = LocalStorage.userId;
      appLog("The userid is: ${userId.value}");

      appLog(
          "The length: \nleaderboard ${leaderBoardList.length}, ${leaderBoardDailyList.length},${leaderBoardMonthlyList.length} \n Creator: ${creatorList.length},${creatorDailyList.length},${creatorMonthlyList.length} \n Country: ${countryList.length},${countryDailyList.length},${countryMonthlyList.length},");
    } catch (e) {
      errorLog("Error in leaderboad controller", e);
    }

    // refreshTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
    //   fetchLeaderBoardData();
    //   fetchCountryData();
    //   fetchCreatorData(); // repeat fetch
    // });
  }

  void fetchLeaderBoardData() async {
    try {
      appLog("leaderboard data is fetching");
      isLoading.value = true;
      final response =
          await ApiGetService.apiGetService(AppUrls.leaderBoardData);

      if (response != null) {
        final jsonbody = jsonDecode(response.body);
        if (response.statusCode == 200) {
          final List data = jsonbody["data"];
          if (data.isNotEmpty) {
            leaderBoardList.value =
                data.map((e) => LeaderBoardModel.fromJson(e)).toList();
            appLog(leaderBoardList.map(
              (element) => element!.profileImg,
            ));
            leaderBoardList.sort(
              (a, b) => a!.currentRank.compareTo(b!.currentRank),
            );
          }
        } else {
          Get.closeAllSnackbars();
          Get.snackbar("Error", jsonbody["message"],
              colorText: AppColors.white);
        }
      }
      appLog("Succeed");
    } catch (e) {
      errorLog("fetchLeaderBoardData", e);
    } finally {
      isLoading.value = false;
    }
    return;
  }

  void fetchLeaderBoardDataDaily() async {
    try {
      appLog("leaderboard data is fetching");
      isLoadingToday.value = true;
      final response = await ApiGetService.apiGetService(AppUrls.rankDaily);

      if (response != null) {
        final jsonbody = jsonDecode(response.body);
        if (response.statusCode == 200) {
          final List data = jsonbody["data"];
          if (data.isNotEmpty) {
            leaderBoardDailyList.value =
                data.map((e) => LeaderBoardModel.fromJson(e)).toList();

            leaderBoardDailyList.sort(
              (a, b) => a!.currentRank.compareTo(b!.currentRank),
            );
          }
        } else {
          Get.closeAllSnackbars();
          Get.snackbar("Error", jsonbody["message"],
              colorText: AppColors.white);
        }
      }
      appLog("Succeed");
    } catch (e) {
      errorLog("fetchLeaderBoardDataDaily", e);
    } finally {
      isLoadingToday.value = false;
    }
    return;
  }

  void fetchLeaderBoardDataMonthly() async {
    try {
      appLog("leaderboard data is fetching");
      isLoadingMonthly.value = true;
      final response = await ApiGetService.apiGetService(AppUrls.rankMonthly);

      if (response != null) {
        final jsonbody = jsonDecode(response.body);
        if (response.statusCode == 200) {
          final List data = jsonbody["data"];
          if (data.isNotEmpty) {
            leaderBoardMonthlyList.value =
                data.map((e) => LeaderBoardModel.fromJson(e)).toList();

            leaderBoardMonthlyList.sort(
              (a, b) => a!.currentRank.compareTo(b!.currentRank),
            );
          }
        } else {
          Get.closeAllSnackbars();
          Get.snackbar("Error", jsonbody["message"],
              colorText: AppColors.white);
        }
      }
      appLog("Succeed");
    } catch (e) {
      errorLog("fetchLeaderBoardDataMonthly", e);
    } finally {
      isLoadingMonthly.value = false;
    }
    return;
  }

  void fetchCreatorData() async {
    try {
      appLog("creator data is fetching");
      isLoadingCreator.value = true;
      final response =
          await ApiGetService.apiGetService(AppUrls.creatorLeaderboard);

      if (response != null) {
        final jsonbody = jsonDecode(response.body);
        appLog("Creator alltime data $jsonbody");
        if (response.statusCode == 200) {
          final List data = jsonbody["data"];
          if (data.isNotEmpty) {
            creatorList.value =
                data.map((e) => LeaderBoardModelRaised.fromJson(e)).toList();
            appLog(creatorList.map(
              (element) => element!.profileImg,
            ));
            creatorList.sort(
              (a, b) => a!.currentRaisedRank.compareTo(b!.currentRaisedRank),
            );
          }
        } else {
          Get.closeAllSnackbars();
          Get.snackbar("Error", jsonbody["message"],
              colorText: AppColors.white);
        }
      }
      appLog("Succeed");
    } catch (e) {
      errorLog("fetchCreatorData", e);
    } finally {
      isLoadingCreator.value = false;
    }
    return;
  }

  void fetchCreatorDataDaily() async {
    try {
      appLog("creator data is fetching");
      isLoadingCreatorToday.value = true;
      final response = await ApiGetService.apiGetService(AppUrls.raisedDaily);

      if (response != null) {
        final jsonbody = jsonDecode(response.body);
        if (response.statusCode == 200) {
          final List data = jsonbody["data"];
          if (data.isNotEmpty) {
            creatorDailyList.value =
                data.map((e) => LeaderBoardModelRaised.fromJson(e)).toList();

            creatorDailyList.sort(
              (a, b) => a!.currentRaisedRank.compareTo(b!.currentRaisedRank),
            );
          }
        } else {
          Get.closeAllSnackbars();
          Get.snackbar("Error", jsonbody["message"],
              colorText: AppColors.white);
        }
      }
      appLog("Succeed");
    } catch (e) {
      errorLog("fetchCreatorDataDaily", e);
    } finally {
      isLoadingCreatorToday.value = false;
    }
    return;
  }

  void fetchCreatorDataMonthly() async {
    try {
      appLog("creator data is fetching");
      isLoadingCreatorMonthly.value = true;
      final response = await ApiGetService.apiGetService(AppUrls.raisedMonthly);

      if (response != null) {
        final jsonbody = jsonDecode(response.body);
        if (response.statusCode == 200) {
          final List data = jsonbody["data"];
          if (data.isNotEmpty) {
            creatorMonthlyList.value =
                data.map((e) => LeaderBoardModelRaised.fromJson(e)).toList();

            creatorMonthlyList.sort(
              (a, b) => a!.currentRaisedRank.compareTo(b!.currentRaisedRank),
            );
          }
        } else {
          Get.closeAllSnackbars();
          Get.snackbar("Error", jsonbody["message"],
              colorText: AppColors.white);
        }
      }
      appLog("Succeed");
    } catch (e) {
      errorLog("fetchCreatorDataMonthly", e);
    } finally {
      isLoadingCreatorMonthly.value = false;
    }
    return;
  }

  void fetchCountryData() async {
    try {
      appLog("leaderboard data is fetching");
      isLoadingCountry.value = true;
      final response =
          await ApiGetService.apiGetService(AppUrls.countryLeaderboard);

      if (response != null) {
        final jsonbody = jsonDecode(response.body);
        appLog(response.body);
        if (response.statusCode == 200) {
          final List data = jsonbody["data"]["data"];
          if (data.isNotEmpty) {
            countryList.value =
                data.map((e) => CountryLeaderboardModel.fromJson(e)).toList();

            countryList.sort(
              (a, b) => b!.totalInvest.compareTo(a!.totalInvest),
            );
          }
          await getAllIsoCode();
        } else {
          Get.closeAllSnackbars();
          Get.snackbar("Error in fetching country", jsonbody["message"],
              colorText: AppColors.white);
        }
      }
      appLog("Succeed");
    } catch (e) {
      errorLog("fetchCountryData", e);
    } finally {
      isLoadingCountry.value = false;
    }
    return;
  }

  void fetchCountryDataDaily() async {
    try {
      appLog("leaderboard data is fetching");
      isLoadingCountryToday.value = true;
      final response = await ApiGetService.apiGetService(AppUrls.countryDaily);

      if (response != null) {
        final jsonbody = jsonDecode(response.body);
        appLog(response.body);
        if (response.statusCode == 200) {
          final List data = jsonbody["data"]["data"];
          if (data.isNotEmpty) {
            countryDailyList.value =
                data.map((e) => CountryLeaderboardModel.fromJson(e)).toList();

            countryDailyList.sort(
              (a, b) => b!.totalInvest.compareTo(a!.totalInvest),
            );
          }
          await getAllIsoCode();
        } else {
          Get.closeAllSnackbars();
          Get.snackbar("Error in fetching country", jsonbody["message"],
              colorText: AppColors.white);
        }
      }
      appLog("Succeed");
    } catch (e) {
      errorLog("fetchCountryDataDaily", e);
    } finally {
      isLoadingCountryToday.value = false;
    }
    return;
  }

  void fetchCountryDataMonth() async {
    try {
      appLog("leaderboard data is fetching");
      isLoadingCountryMonthly.value = true;
      final response =
          await ApiGetService.apiGetService(AppUrls.countryMonthly);

      if (response != null) {
        final jsonbody = jsonDecode(response.body);
        appLog(response.body);
        if (response.statusCode == 200) {
          final List data = jsonbody["data"]["data"];
          if (data.isNotEmpty) {
            countryMonthlyList.value =
                data.map((e) => CountryLeaderboardModel.fromJson(e)).toList();

            countryMonthlyList.sort(
              (a, b) => b!.totalInvest.compareTo(a!.totalInvest),
            );
          }
          await getAllIsoCode();
        } else {
          Get.closeAllSnackbars();
          Get.snackbar("Error in fetching country", jsonbody["message"],
              colorText: AppColors.white);
        }
      }
      appLog("Succeed");
    } catch (e) {
      errorLog("fetchCountryDataMonth", e);
    } finally {
      isLoadingCountryMonthly.value = false;
    }
    return;
  }

  Future<void> getAllIsoCode() async {
    appLog("The size of country leaderboard: ${countryList.length}");
    final temp = await getAllCountries();
    isoCodes.value = List.generate(
        countryList.length,
        (index) =>
            temp
                .firstWhereOrNull(
                  (element) =>
                      element.name.toLowerCase() ==
                      countryList[index].country.toLowerCase(),
                )
                ?.isoCode ??
            "ZA");
    appLog("The size of isocodes ${isoCodes.length}");
    // for (int i = 0; i < countryList.length; i++) {
    //   isoCodes.add(temp
    //       .firstWhere(
    //         (element) =>
    //             element.name.toLowerCase() ==
    //             countryList[i].country.toLowerCase(),
    //       )
    //       .isoCode);
    // }
    appLog(countryList);
    appLog("The couuntrycode: ${countryList.first.isoCode}");
  }
}
