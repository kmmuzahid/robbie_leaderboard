import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_leaderboard/constants/app_country_city.dart';
import 'package:the_leaderboard/screens/bottom_nav/bottom_nav.dart';
import 'package:the_leaderboard/services/api/api_patch_service.dart';

class EditProfileController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final Rx<File?> selectedImage = Rx<File?>(null);

  // Image picker instance
  final ImagePicker _picker = ImagePicker();

  final RxString selectedCountry = 'Australia'.obs;
  final RxString selectedCity = 'Washington DC'.obs;
  final RxString selectedGender = 'Male'.obs;
  List<String> cities = [];
  final List<String> genders = ['Male', 'Female', 'Other'];

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

  List<String> findCity(String country) {
    return AppCountryCity.countryCityMap[country]!;
  }

  // Method to pick an image from the gallery
  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar("Error", "Error picking image");
    }
  }

  void saveChange() async {
    await ApiPatchService.updateProfile(
        usernameController.text,
        contactController.text,
        selectedCountry.value,
        selectedCity.value,
        selectedGender.value,
        ageController.text,
        roleController.text);
    await ApiPatchService.updateProfileImage(selectedImage.value);
    Get.offAll(BottomNav());
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
