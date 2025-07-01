import 'package:get/get.dart';

class SearchScreenController extends GetxController {
  // Observable variables
  final RxString selectedCountry = 'Australia'.obs;
  final RxString selectedCity = 'Washington DC'.obs;
  final RxString selectedGender = 'Male'.obs;
  final RxInt minAge = 22.obs;
  final RxInt maxAge = 26.obs;

  // Lists for dropdown options
  final List<String> countries = ['Australia', 'USA', 'Canada'];
  final List<String> cities = ['Washington DC', 'Sydney', 'Melbourne'];
  final List<String> genders = ['Male', 'Female', 'Other'];

  // Methods to update values
  void updateCountry(String value) {
    selectedCountry.value = value;
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
  void search() {
    // Implement search logic or navigation
    Get.back();
  }
}
