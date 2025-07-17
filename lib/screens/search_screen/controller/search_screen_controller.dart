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

  // Lists for dropdown options
  List<String> cities = ["Sydney", "Melbourne", "Brisbane"];
  final List<String> genders = ['Male', 'Female', 'Other'];
  // final List<String> cities = ;

  final nameController = TextEditingController();

  // Methods to update values
  void updateCountry(String value) {
    selectedCountry.value = value;
    cities = findCity(value);
    selectedCity.value = cities.first;
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
          "user is searching with $name, ${selectedCountry.value}, ${selectedCity.value} and ${selectedGender.value}");
      bool isloading = true;
      final responseLeaderboard =
          await ApiGetService.fetchFilteredLeaderboardData(
        url: AppUrls.leaderBoardData,
        name: name,
        country: selectedCountry.value,
        city: selectedCity.value,
        gender: selectedGender.value,
      );
      final responseCountry = await ApiGetService.fetchFilteredLeaderboardData(
        url: AppUrls.countryLeaderboard,
        name: name,
        country: selectedCountry.value,
        city: selectedCity.value,
        gender: selectedGender.value,
      );
      final responseCreator = await ApiGetService.fetchFilteredLeaderboardData(
        url: AppUrls.creatorLeaderboard,
        name: name,
        country: selectedCountry.value,
        city: selectedCity.value,
        gender: selectedGender.value,
      );
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
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    nameController.dispose();
  }
}
