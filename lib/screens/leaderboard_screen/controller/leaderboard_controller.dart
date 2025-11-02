import 'dart:async';
import 'dart:convert';

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

enum LeaderboardType {
  leaderboard,
  eventLeaderboard,
  creatorLeaderboard,
}

enum LeaderboardTime {
  allTime,
  daily,
  monthly,
}

class LeaderboardController extends GetxController {
  //leaderboard
  final RxList<LeaderBoardModel?> leaderBoardList = <LeaderBoardModel>[].obs;
  final RxList<LeaderBoardModel?> leaderBoardDailyList = <LeaderBoardModel>[].obs;
  final RxList<LeaderBoardModel?> leaderBoardMonthlyList = <LeaderBoardModel>[].obs;
  //creator
  final RxList<LeaderBoardModelRaised?> creatorList = <LeaderBoardModelRaised>[].obs;
  final RxList<LeaderBoardModelRaised?> creatorDailyList = <LeaderBoardModelRaised>[].obs;
  final RxList<LeaderBoardModelRaised?> creatorMonthlyList = <LeaderBoardModelRaised>[].obs;
  //country
  final RxList<CountryLeaderboardModel> countryList = <CountryLeaderboardModel>[].obs;
  final RxList<CountryLeaderboardModel> countryDailyList = <CountryLeaderboardModel>[].obs;
  final RxList<CountryLeaderboardModel> countryMonthlyList = <CountryLeaderboardModel>[].obs;

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

  final leaderboardType = LeaderboardType.leaderboard.obs;
  final leaderboardTime = LeaderboardTime.allTime.obs;

  // API endpoints
  final Map<LeaderboardType, String> _endpoints = {
    LeaderboardType.leaderboard: AppUrls.leaderBoardData,
    LeaderboardType.creatorLeaderboard: AppUrls.creatorLeaderboard,
    LeaderboardType.eventLeaderboard: AppUrls.countryLeaderboard,
  };

  // Time-based URL suffixes
  final Map<LeaderboardTime, String> _timeSuffixes = {
    LeaderboardTime.daily: '/today',
    LeaderboardTime.monthly: '/monthly',
    LeaderboardTime.allTime: '/',
  };

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  onTypeChange({LeaderboardType? leaderboardType, LeaderboardTime? leaderboardTime}) {
    this.leaderboardType.value = leaderboardType ?? this.leaderboardType.value;
    this.leaderboardTime.value = leaderboardTime ?? this.leaderboardTime.value;
    fetchData();
  }

  Future<void> fetchData({bool isUpdating = false}) async {
    try {
      final type = leaderboardType.value;
      final time = leaderboardTime.value;

      if (type == LeaderboardType.leaderboard) {
        await _fetchLeaderboardData(time);
      } else if (type == LeaderboardType.eventLeaderboard) {
        await _fetchCountryData(time);
      } else if (type == LeaderboardType.creatorLeaderboard) {
        await _fetchCreatorData(time);
      }

      await _fetchUserProfile();
    } catch (e) {
      errorLog("Error in leaderboard controller", e);
      _showError("Failed to load data");
    }
  }

  Future<void> _fetchLeaderboardData(LeaderboardTime time) async {
    final url = '${_endpoints[LeaderboardType.leaderboard]}${_timeSuffixes[time]}';
    await _fetchData<LeaderBoardModel>(
      url: url,
      onLoading: (loading) => _updateLoadingState(time, loading, isLeaderboard: true),
      onSuccess: (data) => _updateLeaderboardList(time, data),
      onError: (message) => _handleError('leaderboard', message),
      fromJson: (json) => LeaderBoardModel.fromJson(json),
    );
  }

  Future<void> _fetchCreatorData(LeaderboardTime time) async {
    final url = '${_endpoints[LeaderboardType.creatorLeaderboard]}${_timeSuffixes[time]}';
    await _fetchData<LeaderBoardModelRaised>(
      url: url,
      onLoading: (loading) => _updateLoadingState(time, loading, isCreator: true),
      onSuccess: (data) => _updateCreatorList(time, data),
      onError: (message) => _handleError('creator leaderboard', message),
      fromJson: (json) => LeaderBoardModelRaised.fromJson(json),
    );
  }

  Future<void> _fetchCountryData(LeaderboardTime time) async {
    final url = '${_endpoints[LeaderboardType.eventLeaderboard]}${_timeSuffixes[time]}';
    await _fetchData<CountryLeaderboardModel>(
      url: url,
      onLoading: (loading) => _updateLoadingState(time, loading, isCountry: true),
      onSuccess: (data) => _updateCountryList(time, data),
      onError: (message) => _handleError('country leaderboard', message),
      fromJson: (json) => CountryLeaderboardModel.fromJson(json),
    );
  }

  String url = "";

  Future<void> _fetchData<T>({
    required String url,
    required Function(bool) onLoading,
    required Function(List<T>) onSuccess,
    required Function(String) onError,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    if (this.url == url) return;
    this.url = url;
    try {
      onLoading(true);
      final response = await ApiGetService.apiGetServiceQuery(url);
      // print(url);
      // print(response?.body);
      if (response != null) {
        final jsonBody = jsonDecode(response.body);
        if (response.statusCode == 200 && jsonBody['success'] == true) {
          final data = List<Map<String, dynamic>>.from(jsonBody['data'] ?? [])
              .map((item) => fromJson(item))
              .toList();
          onSuccess(data);
        } else {
          onError(jsonBody['message'] ?? 'Failed to fetch data');
        }
      } else {
        onError('No response from server');
      }
    } catch (e) {
      onError(e.toString());
    } finally {
      this.url = "";
      onLoading(false);
    }
  }

  void _updateLoadingState(
    LeaderboardTime time,
    bool loading, {
    bool isLeaderboard = false,
    bool isCreator = false,
    bool isCountry = false,
  }) {
    if (isLeaderboard) {
      switch (time) {
        case LeaderboardTime.allTime:
          isLoading.value = loading;
          break;
        case LeaderboardTime.daily:
          isLoadingToday.value = loading;
          break;
        case LeaderboardTime.monthly:
          isLoadingMonthly.value = loading;
          break;
      }
    } else if (isCreator) {
      switch (time) {
        case LeaderboardTime.allTime:
          isLoadingCreator.value = loading;
          break;
        case LeaderboardTime.daily:
          isLoadingCreatorToday.value = loading;
          break;
        case LeaderboardTime.monthly:
          isLoadingCreatorMonthly.value = loading;
          break;
      }
    } else if (isCountry) {
      switch (time) {
        case LeaderboardTime.allTime:
          isLoadingCountry.value = loading;
          break;
        case LeaderboardTime.daily:
          isLoadingCountryToday.value = loading;
          break;
        case LeaderboardTime.monthly:
          isLoadingCountryMonthly.value = loading;
          break;
      }
    }
  }

  void _updateLeaderboardList(LeaderboardTime time, List<LeaderBoardModel> list) {
    switch (time) {
      case LeaderboardTime.allTime:
        leaderBoardList.value = list;
        break;
      case LeaderboardTime.daily:
        leaderBoardDailyList.value = list;
        break;
      case LeaderboardTime.monthly:
        leaderBoardMonthlyList.value = list;
        break;
    }
  }

  void _updateCreatorList(LeaderboardTime time, List<LeaderBoardModelRaised> list) {
    switch (time) {
      case LeaderboardTime.allTime:
        creatorList.value = list;
        break;
      case LeaderboardTime.daily:
        creatorDailyList.value = list;
        break;
      case LeaderboardTime.monthly:
        creatorMonthlyList.value = list;
        break;
    }
  }

  void _updateCountryList(LeaderboardTime time, List<CountryLeaderboardModel> list) {
    switch (time) {
      case LeaderboardTime.allTime:
        countryList.value = list;
        break;
      case LeaderboardTime.daily:
        countryDailyList.value = list;
        break;
      case LeaderboardTime.monthly:
        countryMonthlyList.value = list;
        break;
    }
  }

  void _handleError(String type, String message) {
    _showError('Error in fetching $type: $message');
  }

  void _showError(String message) {
    Get.closeAllSnackbars();
    Get.snackbar(
      'Error',
      message,
      colorText: AppColors.white,
      backgroundColor: AppColors.red,
    );
  }

  Future<void> _fetchUserProfile() async {
    try {
      await Get.find<ProfileScreenController>().fetchProfile();
      userId.value = StorageService.userId;
      appLog("User ID: ${userId.value}");
    } catch (e) {
      errorLog("Error fetching user profile", e);
    }
  }
}
