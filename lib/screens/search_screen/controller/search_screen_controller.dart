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
import 'package:the_leaderboard/utils/app_logs.dart';

class SearchScreenController extends GetxController {
  // Observable variables
  final RxString selectedCountry = 'Australia'.obs;
  final RxString selectedCity = 'Sydney'.obs;
  final RxString selectedGender = 'Male'.obs;
  final RxInt minAge = 22.obs;
  final RxInt maxAge = 26.obs;
  RxList<Country> countryList = <Country>[].obs;
  RxList<City> cityList = <City>[].obs;
  final finalSelectedCountry = "".obs;

  // Lists for dropdown options
  List<String> cities = ["Sydney", "Melbourne", "Brisbane"];
  final List<String> genders = ['Male', 'Female', 'Other'];
  // final List<String> cities = ;

  final nameController = TextEditingController();

  Future<void> onInitial() async {
    try {
      countryList.value = await getAllCountries();
      if (countryList.isNotEmpty) {
        // Select first country by default
        selectedCountry.value = countryList.first.isoCode;
        updateCountry(selectedCountry.value);

        // Load its cities
        await loadCities(countryList.first.isoCode);
      }
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

      if (cityList.isNotEmpty) {
        selectedCity.value = cityList.first.name;
      }
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
    } catch (e) {
      appLog(e); // TODO
    }
  }

  void updateCity(String value) {
    selectedCity.value = value;
  }

  void updateGender(String value) {
    selectedGender.value = value;
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
  void search() async {
    // Implement search logic or navigation
    if (nameController.text.isEmpty) {
      Get.snackbar("Please a name", "",
          colorText: AppColors.white, snackPosition: SnackPosition.BOTTOM);
      return;
    }
    final name = nameController.text.capitalizeFirst!;
    try {
      appLog(
          "user is searching with $name, ${finalSelectedCountry.value}, ${selectedCity.value} and ${selectedGender.value}");
      bool isloading = true;
      final responseLeaderboard =
          await ApiGetService.fetchFilteredLeaderboardData(
        url: AppUrls.leaderBoardData,
        name: name,
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
      final responseCreator = await ApiGetService.fetchFilteredLeaderboardData(
        url: AppUrls.creatorLeaderboard,
        name: name,
        country: finalSelectedCountry.value,
        city: selectedCity.value,
        gender: selectedGender.value,
      );
      appLog(responseCreator);
      appLog(responseCountry);
      appLog(responseLeaderboard);
      isloading = false;
      if (responseLeaderboard.isNotEmpty ||
          responseCountry.isNotEmpty ||
          responseCreator.isNotEmpty) {
        Get.to(LeaderboardFilteredScreen(
            leaderBoardList: responseLeaderboard,
            countryList: responseCountry,
            creatorList: responseCreator,
            isLoading: isloading));
      } else {
        Get.snackbar("Error", "No user found", colorText: AppColors.white);
      }
    } catch (e) {
      errorLog("Failed", e);
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
