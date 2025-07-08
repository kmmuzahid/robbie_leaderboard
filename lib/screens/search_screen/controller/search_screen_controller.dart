import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/screens/leaderboard_filtered_screen/leaderboard_filtered_screen.dart';
import 'package:the_leaderboard/services/api/api_get_service.dart';

class SearchScreenController extends GetxController {
  // Observable variables
  final RxString selectedCountry = 'Australia'.obs;
  final RxString selectedCity = 'Washington DC'.obs;
  final RxString selectedGender = 'Male'.obs;
  final RxInt minAge = 22.obs;
  final RxInt maxAge = 26.obs;

  // Lists for dropdown options
  final List<String> countries = ['Australia', 'USA', 'Canada', 'Bangladesh'];
  List<String> cities = ['Washington DC', 'Sydney', 'Melbourne'];
  final List<String> genders = ['Male', 'Female', 'Other'];
  // final List<String> cities = ;

  final nameController = TextEditingController();

  // Methods to update values
  void updateCountry(String value) {
    selectedCountry.value = value;
    cities = findCity(value);
    selectedCity.value = "Dhaka";
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
      Get.snackbar("oops!", "No user found");
    }
  }

  List<String> findCity(String country) {
    print(country);
    switch (country) {
      case "Bangladesh":
        {
          return [
            "Dhaka",
            "Chattogram",
            "Khulna",
            "Barishal",
            "Rangpur",
            "Dinajpur"
          ];
        }
      default:
        return ['Washington DC', 'Sydney', 'Melbourne'];
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    nameController.dispose();
  }
}
