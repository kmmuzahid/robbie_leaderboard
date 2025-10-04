import 'package:country_state_city/country_state_city.dart';
import 'package:country_state_city/models/city.dart';
import 'package:country_state_city/models/country.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_country_city.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
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
  final finalSelectedCountry = "".obs;

  final isLoading = false.obs;

  // Lists for dropdown options
  List<String> cities = ["Sydney", "Melbourne", "Brisbane"];
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

  Future<void> loadCities(String countryCode) async {
    try {
      final fetchedCities = await getCountryCities(countryCode);

      // Use a Set to ensure uniqueness
      final uniqueNames = <String>{};
      final uniqueCities = fetchedCities.where((city) {
        if (uniqueNames.contains(city.name)) {
          return false; // skip duplicates
        } else {
          uniqueNames.add(city.name);
          return true; // keep first occurrence
        }
      }).toList();

      cityList.value = uniqueCities;

      // if (cityList.isNotEmpty) {
      //   selectedCity.value = cityList.first.name;
      // }
    } catch (e) {
      appLog("Error loading cities: $e");
    }
  }

  Future<void> updateCountry(String isoCode) async {
    try {
      cityList.clear();
      selectedCountry.value = isoCode;
      countryList.value = await getAllCountries();
      final country = countryList.firstWhereOrNull(
        (c) => c.isoCode == isoCode,
      );

      appLog(
          "Found country: ${country!.name} and country code: ${country.isoCode} and default isoCode: $isoCode");

      finalSelectedCountry.value = country.name;
      await loadCities(isoCode);
      appLog("Country updated: $isoCode");
      update();
    } catch (e) {
      appLog(e); // TODO
    }
  }

  void updateCity(String value) {
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
        finalSelectedCountry.isEmpty &&
        selectedCity.isEmpty &&
        selectedGender.isEmpty) {
      AppCommonFunction.showSnackbar(
          context, "Please write or select something");
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
      // appLog(
      //     "user is searching with $name, ${finalSelectedCountry.value}, ${selectedCity.value} and ${selectedGender.value}");
      isLoading.value = true;
      update();
      final responseLeaderboard =
          await ApiGetService.fetchFilteredLeaderboardData(
        url: AppUrls.leaderBoardData,
        name: name!,
        country: finalSelectedCountry.value,
        city: selectedCity.value,
        gender: selectedGender.value,
      );
      final responseLeaderboardDaily =
          await ApiGetService.fetchFilteredLeaderboardData(
        url: AppUrls.rankDaily,
        name: name!,
        country: finalSelectedCountry.value,
        city: selectedCity.value,
        gender: selectedGender.value,
      );
      final responseLeaderboardMonthly =
          await ApiGetService.fetchFilteredLeaderboardData(
        url: AppUrls.rankMonthly,
        name: name!,
        country: finalSelectedCountry.value,
        city: selectedCity.value,
        gender: selectedGender.value,
      );
      final responseCountry = await ApiGetService.fetchFilteredLeaderboardData(
        url: AppUrls.countryLeaderboard,
        name: name,
        country: finalSelectedCountry.value,
        city: selectedCity.value,
        gender: selectedGender.value,
      );
      final responseCountryDaily =
          await ApiGetService.fetchFilteredLeaderboardData(
        url: AppUrls.countryDaily,
        name: name,
        country: finalSelectedCountry.value,
        city: selectedCity.value,
        gender: selectedGender.value,
      );
      final responseCountryMonthly =
          await ApiGetService.fetchFilteredLeaderboardData(
        url: AppUrls.countryMonthly,
        name: name,
        country: finalSelectedCountry.value,
        city: selectedCity.value,
        gender: selectedGender.value,
      );
      final responseCreator = await ApiGetService.fetchFilteredLeaderboardData(
        url: AppUrls.creatorLeaderboard,
        name: name,
        country: finalSelectedCountry.value,
        city: selectedCity.value,
        gender: selectedGender.value,
      );
      final responseCreatorDaily =
          await ApiGetService.fetchFilteredLeaderboardData(
        url: AppUrls.raisedDaily,
        name: name,
        country: finalSelectedCountry.value,
        city: selectedCity.value,
        gender: selectedGender.value,
      );
      final responseCreatorMonthly =
          await ApiGetService.fetchFilteredLeaderboardData(
        url: AppUrls.raisedMonthly,
        name: name,
        country: finalSelectedCountry.value,
        city: selectedCity.value,
        gender: selectedGender.value,
      );
      // appLog(responseCreator);
      // appLog(responseCountry);
      // appLog(responseLeaderboard);

      if (responseLeaderboard.isNotEmpty ||
          responseCountry.isNotEmpty ||
          responseCreator.isNotEmpty ||
          responseLeaderboardDaily.isNotEmpty ||
          responseLeaderboardMonthly.isNotEmpty ||
          responseCreatorDaily.isNotEmpty ||
          responseCreatorMonthly.isNotEmpty ||
          responseCountryDaily.isNotEmpty ||
          responseCountryMonthly.isNotEmpty) {
        Get.to(LeaderboardFilteredScreen(
            leaderBoardList: responseLeaderboard,
            leaderBoardListDaily: responseLeaderboardDaily,
            leaderBoardListMonthly: responseLeaderboardMonthly,
            countryList: responseCountry,
            countryListDaily: responseCountryDaily,
            countryListMonthly: responseCountryMonthly,
            creatorList: responseCreator,
            creatorListDaily: responseCreatorDaily,
            creatorListMonthly: responseCreatorMonthly,
            isLoading: isLoading.value));
      } else {
        AppCommonFunction.showSnackbar(context, "No user found");
      }
    } catch (e) {
      errorLog("Failed", e);
    } finally {
      isLoading.value = false;
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
