import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_country_city.dart';
import 'package:the_leaderboard/screens/bottom_nav/bottom_nav.dart';
import 'package:the_leaderboard/services/api/api_patch_service.dart';
import 'package:the_leaderboard/utils/app_logs.dart';

class EditProfileController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final Rx<File?> selectedImage = Rx<File?>(null);

  // Image picker instance
  final ImagePicker _picker = ImagePicker();

  final RxString selectedCountry = 'Australia'.obs;
  final RxString selectedCity = 'Sydney'.obs;
  final RxString selectedGender = 'Male'.obs;
  List<String> cities = ["Sydney", "Melbourne", "Brisbane"];
  final List<String> genders = ['Male', 'Female', 'Other'];

  void updateCountry(String value) {
    selectedCountry.value = value;
    cities = findCity(value);
    selectedCity.value = cities.first;
    appLog("Country updated");
  }

  void updateCity(String value) {
    selectedCity.value = value;
    appLog("City updated");
  }

  void updateGender(String value) {
    selectedGender.value = value;
    appLog("Gender updated");
  }

  List<String> findCity(String country) {
    return AppCountryCity.countryCityMap[country]!;
  }

  // Method to pick an image from the gallery
  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        appLog("Image is selected");
        selectedImage.value = File(image.path);
      }
    } catch (e) {
      errorLog("Failed", e);
      Get.snackbar("Error", "Error picking image",
          colorText: AppColors.white, snackPosition: SnackPosition.BOTTOM);
    }
  }

  void saveChange() async {
    appLog("Changes are saving");
    try {
      await ApiPatchService.updateProfile(
          usernameController.text,
          contactController.text,
          selectedCountry.value,
          selectedCity.value,
          selectedGender.value,
          ageController.text,
          roleController.text);
      await ApiPatchService.updateProfileImage(selectedImage.value);
      Get.offAll(const BottomNav());
      appLog("Succeed");
    } catch (e) {
      Get.snackbar(
          "Something went wrong", "Please check your internet connection",
          colorText: AppColors.white, snackPosition: SnackPosition.BOTTOM);
      errorLog("Failed", e);
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    usernameController.dispose();
    contactController.dispose();
    ageController.dispose();
    roleController.dispose();
  }
}
