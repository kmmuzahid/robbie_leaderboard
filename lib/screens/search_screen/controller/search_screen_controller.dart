import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_country_city.dart';
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
    try {
      appLog(
          "user is searching with ${nameController.text}, ${selectedCountry.value}, ${selectedCity.value} and ${selectedGender.value}");
      bool isloading = true;
      final response = await ApiGetService.fetchFilteredLeaderboardData(
        name: nameController.text,
        country: selectedCountry.value,
        city: selectedCity.value,
        gender: selectedGender.value,
      );
      isloading = false;
      if (response.isNotEmpty) {
        Get.to(LeaderboardFilteredScreen(
            leaderBoardList: response, isLoading: isloading));
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
