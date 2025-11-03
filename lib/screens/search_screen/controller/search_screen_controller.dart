import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_country_state/flutter_country_state.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/common/location_picker_controller.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_country_city.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/country_leaderboard_model.dart';
import 'package:the_leaderboard/models/leader_board_model.dart';
import 'package:the_leaderboard/models/leader_board_model_raised.dart';
import 'package:the_leaderboard/screens/leaderboard_filtered_screen/leaderboard_filtered_screen.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/controller/leaderboard_controller.dart';
import 'package:the_leaderboard/services/api/api_get_service.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';
import 'package:the_leaderboard/utils/app_logs.dart';
import 'package:the_leaderboard/utils/debouncer.dart';

class SearchScreenController extends GetxController with GetTickerProviderStateMixin {
  String selectedGenderKey = 'Select Gender';

  final double eachItemHeight = 50.0;
  late ScrollController scrollController;
  late TabController tabController;
  final CommonDebouncer debouncer = CommonDebouncer(delay: const Duration(milliseconds: 500));

  final String userId = StorageService.userId;
  // Controllers
  final LocationPickerController locationPickerController = Get.find();
  late TextEditingController nameController;

  // Search parameters
  final RxString selectedGender = ''.obs;
  final Rx<LeaderboardType> leaderboardType = LeaderboardType.leaderboard.obs;
  final Rx<LeaderboardTime> leaderboardTime = LeaderboardTime.allTime.obs;

  //leaderboard
  final RxList<LeaderBoardModel> leaderBoardList = <LeaderBoardModel>[].obs;
  final RxList<LeaderBoardModel> leaderBoardDailyList = <LeaderBoardModel>[].obs;
  final RxList<LeaderBoardModel> leaderBoardMonthlyList = <LeaderBoardModel>[].obs;
  //creator
  final RxList<LeaderBoardModelRaised> creatorList = <LeaderBoardModelRaised>[].obs;
  final RxList<LeaderBoardModelRaised> creatorDailyList = <LeaderBoardModelRaised>[].obs;
  final RxList<LeaderBoardModelRaised?> creatorMonthlyList = <LeaderBoardModelRaised>[].obs;
  //country
  final RxList<CountryLeaderboardModel> countryList = <CountryLeaderboardModel>[].obs;
  final RxList<CountryLeaderboardModel> countryDailyList = <CountryLeaderboardModel>[].obs;
  final RxList<CountryLeaderboardModel> countryMonthlyList = <CountryLeaderboardModel>[].obs;

  // Loading states
  final isLoading = false.obs;
  String searchToken = '';
  int _currentSearchId = 0; // Tracks active search sessions

  // Dropdown options
  final List<String> genders = ['Male', 'Female', 'Other'];

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
  void dispose() {
    debouncer.dispose();
    nameController.dispose();
    scrollController.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  void onInit() {
    nameController = TextEditingController();
    scrollController = ScrollController();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      if (tabController.index == 0) {
        leaderboardTime.value = LeaderboardTime.allTime;
      } else if (tabController.index == 1) {
        leaderboardTime.value = LeaderboardTime.daily;
      } else {
        leaderboardTime.value = LeaderboardTime.monthly;
      }
      search();
    });
    super.onInit();
  }

  onTypeChange({LeaderboardType? leaderboardType, LeaderboardTime? leaderboardTime}) {
    this.leaderboardType.value = leaderboardType ?? this.leaderboardType.value;
    this.leaderboardTime.value = leaderboardTime ?? this.leaderboardTime.value;
    search();
  }

  void updateTimePeriod(LeaderboardTime value) {
    leaderboardTime.value = value;
    search();
  }

  void clearFilter() {
    nameController.clear();
    selectedGenderKey = DateTime.now().toString();
    selectedGender.value = '';
    locationPickerController.clear();

    leaderboardType.value = LeaderboardType.leaderboard;
    leaderboardTime.value = LeaderboardTime.allTime;
    clearSearchResult();
    update();
  }

  void clearSearchResult() {
    //clear all list

    leaderBoardList.clear();
    leaderBoardDailyList.clear();
    leaderBoardMonthlyList.clear();
    creatorList.clear();
    creatorDailyList.clear();
    creatorMonthlyList.clear();
    countryList.clear();
    countryDailyList.clear();
    countryMonthlyList.clear();
    update();
  }

  void updateSearchType(LeaderboardType type) {
    leaderboardType.value = type;
  }

  void updateGender(String? value) {
    appLog("selected gender: $value");
    if (value == null) return;
    selectedGender.value = value;
  }

  void onSearchChange(String value) {
    final trimmed = value.trim();

    // Cancel pending debounce (ignore outdated queued searches)
    debouncer.cancel();

    // Increment the search ID to invalidate ongoing searches
    _currentSearchId++;
    searchToken = trimmed;

    // When typing, stop any loading UI immediately
    update();

    // Empty text → fetch all immediately
    if (trimmed.isEmpty) {
      clearSearchResult();
      search();
      return;
    }

    isLoading.value = false;
    // Debounce normal searches
    final int localSearchId = _currentSearchId;
    debouncer.run(() {
      // Only run if this search is still the latest
      if (localSearchId == _currentSearchId) {
        search();
      }
    });
  }

  Future<void> search() async {
    // Track the search session
    final int searchId = _currentSearchId;

    // if (isLoading.value) return;

    final newSearchToken = nameController.text.trim();
    searchToken = newSearchToken;


    try {
      isLoading.value = true;
      update();

      final name = nameController.text;
      final country = locationPickerController.countryInitController.text;
      final city = locationPickerController.cityInitController.text;
      final gender = selectedGender.value;

      final endpoint = _endpoints[leaderboardType.value] ?? AppUrls.leaderBoardData;
      final timeSuffix = _timeSuffixes[leaderboardTime.value] ?? '';

      final response = await ApiGetService.apiGetServiceQuery(
        '$endpoint$timeSuffix',
        queryParameters: {
          if (name.isNotEmpty) 'searchTerm': name,
          if (country.isNotEmpty) 'country': country,
          if (city.isNotEmpty) 'city': city,
          if (gender.isNotEmpty) 'gender': gender.toLowerCase(),
        },
      );

      // ✅ Ignore results from outdated searches
      if (searchId != _currentSearchId) return;

      if (response != null && response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        if (jsonBody['success'] == true) {
          final List<dynamic> data = jsonBody['data'] ?? [];
          _updateListsWithData(data);
        }
      }
    } catch (e) {
      if (searchId == _currentSearchId) {
        Get.snackbar(
          'Error',
          'An error occurred while fetching data',
          backgroundColor: AppColors.red,
          colorText: AppColors.white,
        );
      }
    } finally {
      // Only hide loading if this is still the active search
      if (searchId == _currentSearchId) {
        isLoading.value = false;
        update();
      }
    }
  }

  // Helper method to update the appropriate list
  Future<void> _updateListsWithData(
    List<dynamic> data,
  ) async {
    switch (leaderboardType.value) {
      case LeaderboardType.leaderboard:
        if (leaderboardTime.value == LeaderboardTime.allTime) {
          leaderBoardList.value = data.map((e) => LeaderBoardModel.fromJson(e)).toList();
        } else if (leaderboardTime.value == LeaderboardTime.daily) {
          leaderBoardDailyList.value = data.map((e) => LeaderBoardModel.fromJson(e)).toList();
        } else {
          leaderBoardMonthlyList.value = data.map((e) => LeaderBoardModel.fromJson(e)).toList();
        }
        break;

      case LeaderboardType.eventLeaderboard:
        if (leaderboardTime.value == LeaderboardTime.allTime) {
          countryList.value = data.map((e) => CountryLeaderboardModel.fromJson(e)).toList();
        } else if (leaderboardTime.value == LeaderboardTime.daily) {
          countryDailyList.value = data.map((e) => CountryLeaderboardModel.fromJson(e)).toList();
        } else {
          countryMonthlyList.value = data.map((e) => CountryLeaderboardModel.fromJson(e)).toList();
        }
        break;

      case LeaderboardType.creatorLeaderboard:
        if (leaderboardTime.value == LeaderboardTime.allTime) {
          creatorList.value = data.map((e) => LeaderBoardModelRaised.fromJson(e)).toList();
        } else if (leaderboardTime.value == LeaderboardTime.daily) {
          creatorDailyList.value = data.map((e) => LeaderBoardModelRaised.fromJson(e)).toList();
        } else {
          creatorMonthlyList.value = data.map((e) => LeaderBoardModelRaised.fromJson(e)).toList();
        }
        break;
    }
  }

  // List<String> findCity(String country) {
  //   return AppCountryCity.countryCityMap[country]!;
  // }
}
