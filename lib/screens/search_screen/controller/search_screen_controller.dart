import 'package:country_state_city/country_state_city.dart';
import 'package:country_state_city/models/city.dart';
import 'package:country_state_city/models/country.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_country_city.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/leader_board_model.dart';
import 'package:the_leaderboard/screens/leaderboard_filtered_screen/leaderboard_filtered_screen.dart';
import 'package:the_leaderboard/services/api/api_get_service.dart';
import 'package:the_leaderboard/utils/app_common_function.dart';
import 'package:the_leaderboard/utils/app_logs.dart';

class SearchScreenController extends GetxController {
  // Observable variables
  final RxString selectedCountry = ''.obs;
  final RxString selectedCity = ''.obs;

  final RxString selectedGender = ''.obs;
  final RxInt minAge = 22.obs;
  final RxInt maxAge = 26.obs;
  RxList<Country> countryList = <Country>[].obs;
  RxList<City> cityList = <City>[].obs;

  final List<LeaderBoardModel?> sLeaderBoardList = [];
  final List<LeaderBoardModel?> sLeaderBoardListDaily = [];
  final List<LeaderBoardModel?> sLeaderBoardListMonthly = [];
  final List<LeaderBoardModel?> sCountryList = [];
  final List<LeaderBoardModel?> sCountryListDaily = [];
  final List<LeaderBoardModel?> sCountryListMonthly = [];
  final List<LeaderBoardModel?> sCreatorList = [];
  final List<LeaderBoardModel?> sCreatorListDaily = [];
  final List<LeaderBoardModel?> sCreatorListMonthly = [];

  final isLoadingLeaderBoardList = false.obs;
  final isLoadingLeaderBoardListDaily = false.obs;
  final isLoadingLeaderBoardListMonthly = false.obs;
  final isLoadingCountryList = false.obs;
  final isLoadingCountryListDaily = false.obs;
  final isLoadingCountryListMonthly = false.obs;
  final isLoadingCreatorList = false.obs;
  final isLoadingCreatorListDaily = false.obs;
  final isLoadingCreatorListMonthly = false.obs;

  clearSearch() {
    sLeaderBoardList.clear();
    sLeaderBoardListDaily.clear();
    sLeaderBoardListMonthly.clear();
    sCountryList.clear();
    sCountryListDaily.clear();
    sCountryListMonthly.clear();
    sCreatorList.clear();
    sCreatorListDaily.clear();
    sCreatorListMonthly.clear();
    update();
  }

  void _setAllLoadingStates(bool isLoading) {
    isLoadingLeaderBoardList.value = isLoading;
    isLoadingLeaderBoardListDaily.value = isLoading;
    isLoadingLeaderBoardListMonthly.value = isLoading;
    isLoadingCountryList.value = isLoading;
    isLoadingCountryListDaily.value = isLoading;
    isLoadingCountryListMonthly.value = isLoading;
    isLoadingCreatorList.value = isLoading;
    isLoadingCreatorListDaily.value = isLoading;
    isLoadingCreatorListMonthly.value = isLoading;
    update();
  }

  // Lists for dropdown options
  // List<String> cities = ["Sydney", "Melbourne", "Brisbane"];
  final List<String> genders = ['Male', 'Female', 'Other'];
  // final List<String> cities = ;

  final nameController = TextEditingController();

  Future<void> onInitial() async {
    try {
      countryList.value = await getAllCountries();
      update();
    } catch (e) {
      appLog("Error loading countries: $e");
    }
  }

  Future<void> updateCountry(String isoCode) async {
    if (countryList.isEmpty) return;
    cityList.clear();
    update();
    cityList.value = await LocationRepo.getCountryCities(isoCode);
    update();
  }

  void updateCity(String value) {
    if (cityList.isEmpty) return;
    selectedCity.value = value;
  }

  void updateGender(String value) {
    selectedGender.value = value;
    appLog("selected gender: $value");
  }

  void incrementMaxAge() {
    if (maxAge.value < 100) {
      maxAge.value++;
    }
  }

  void decrementMinAge() {
    if (minAge.value > 0) {
      minAge.value--;
    }
  }

  // Method for search action
  void search(BuildContext context) async {
    // Implement search logic or navigation
    if (nameController.text.isEmpty &&
        selectedCountry.isEmpty &&
        selectedCity.isEmpty &&
        selectedGender.isEmpty) {
      AppCommonFunction.showSnackbar(context, "Please write or select something");
      return;
    }
    final name = nameController.text.capitalizeFirst;

    // final body = "
    //     'name': nameController.text.capitalizeFirst,
    //   if (finalSelectedCountry.isNotEmpty)
    //     'country': finalSelectedCountry.value,
    //   if (selectedCity.isNotEmpty) 'city': selectedCity.value,
    //   if (selectedGender.isNotEmpty) 'gender': selectedGender.value
    //   "
    // };

    try {
      // Clear previous search results
      clearSearch();

      // Set all loading states to true
      _setAllLoadingStates(true);

      // Leaderboard data
      ApiGetService.fetchFilteredLeaderboardData(
        url: AppUrls.leaderBoardData,
        name: name!,
        country: selectedCountry.value,
        city: selectedCity.value,
        gender: selectedGender.value,
      ).then((value) {
        if (value.isNotEmpty) {
          sLeaderBoardList.assignAll(value);
        }
        isLoadingLeaderBoardList.value = false;
        update();
      }).catchError((error) {
        isLoadingLeaderBoardList.value = false;
        update();
        errorLog("Error fetching leaderboard data", error);
      });

      // Daily leaderboard
      ApiGetService.fetchFilteredLeaderboardData(
        url: AppUrls.rankDaily,
        name: name,
        country: selectedCountry.value,
        city: selectedCity.value,
        gender: selectedGender.value,
      ).then((value) {
        if (value.isNotEmpty) {
          sLeaderBoardListDaily.assignAll(value);
        }
        isLoadingLeaderBoardListDaily.value = false;
        update();
      }).catchError((error) {
        isLoadingLeaderBoardListDaily.value = false;
        update();
        errorLog("Error fetching daily leaderboard data", error);
      });

      // Monthly leaderboard
      ApiGetService.fetchFilteredLeaderboardData(
        url: AppUrls.rankMonthly,
        name: name,
        country: selectedCountry.value,
        city: selectedCity.value,
        gender: selectedGender.value,
      ).then((value) {
        if (value.isNotEmpty) {
          sLeaderBoardListMonthly.addAll(value);
        }
        isLoadingLeaderBoardListMonthly.value = false;
        update();
      }).catchError((error) {
        isLoadingLeaderBoardListMonthly.value = false;
        update();
        errorLog("Error fetching monthly leaderboard data", error);
      });

      // Country leaderboard
      ApiGetService.fetchFilteredLeaderboardData(
        url: AppUrls.countryLeaderboard,
        name: name,
        country: selectedCountry.value,
        city: selectedCity.value,
        gender: selectedGender.value,
      ).then((value) {
        if (value.isNotEmpty) {
          sCountryList.addAll(value);
        }
        isLoadingCountryList.value = false;
        update();
      }).catchError((error) {
        isLoadingCountryList.value = false;
        update();
        errorLog("Error fetching country leaderboard data", error);
      });

      // Country daily
      ApiGetService.fetchFilteredLeaderboardData(
        url: AppUrls.countryDaily,
        name: name,
        country: selectedCountry.value,
        city: selectedCity.value,
        gender: selectedGender.value,
      ).then((value) {
        if (value.isNotEmpty) {
          sCountryListDaily.addAll(value);
        }
        isLoadingCountryListDaily.value = false;
        update();
      });
      // Country monthly
      ApiGetService.fetchFilteredLeaderboardData(
        url: AppUrls.countryMonthly,
        name: name,
        country: selectedCountry.value,
        city: selectedCity.value,
        gender: selectedGender.value,
      ).then((value) {
        if (value.isNotEmpty) {
          sCountryListMonthly.addAll(value);
        }
        isLoadingCountryListMonthly.value = false;
        update();
      });
      // Creator leaderboard
      ApiGetService.fetchFilteredLeaderboardData(
        url: AppUrls.creatorLeaderboard,
        name: name,
        country: selectedCountry.value,
        city: selectedCity.value,
        gender: selectedGender.value,
      ).then((value) {
        if (value.isNotEmpty) {
          sCreatorList.addAll(value);
        }
        isLoadingCreatorList.value = false;
        update();
      });
      // Creator daily
      ApiGetService.fetchFilteredLeaderboardData(
        url: AppUrls.raisedDaily,
        name: name,
        country: selectedCountry.value,
        city: selectedCity.value,
        gender: selectedGender.value,
      ).then((value) {
        if (value.isNotEmpty) {
          sCreatorListDaily.addAll(value);
        }
        isLoadingCreatorListDaily.value = false;
        update();
      });
      // Creator monthly
      ApiGetService.fetchFilteredLeaderboardData(
        url: AppUrls.raisedMonthly,
        name: name,
        country: selectedCountry.value,
        city: selectedCity.value,
        gender: selectedGender.value,
      ).then((value) {
        if (value.isNotEmpty) {
          sCreatorListMonthly.addAll(value);
        }
        isLoadingCreatorListMonthly.value = false;
        update();
      });

      Get.to(const LeaderboardFilteredScreen());
    } catch (e) {
      isLoadingLeaderBoardList.value = false;
      isLoadingLeaderBoardListDaily.value = false;
      isLoadingLeaderBoardListMonthly.value = false;
      isLoadingCountryList.value = false;
      isLoadingCountryListDaily.value = false;
      isLoadingCountryListMonthly.value = false;
      isLoadingCreatorList.value = false;
      isLoadingCreatorListDaily.value = false;
      isLoadingCreatorListMonthly.value = false;
    } finally {
      // isLoadingLeaderBoardList.value = false;
      // isLoadingLeaderBoardListDaily.value = false;
      // isLoadingLeaderBoardListMonthly.value = false;
      // isLoadingCountryList.value = false;
      // isLoadingCountryListDaily.value = false;
      // isLoadingCountryListMonthly.value = false;
      // isLoadingCreatorList.value = false;
      // isLoadingCreatorListDaily.value = false;
      // isLoadingCreatorListMonthly.value = false;
      update();
    }
  }

  List<String> findCity(String country) {
    return AppCountryCity.countryCityMap[country]!;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    onInitial();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    nameController.dispose();
  }
}
