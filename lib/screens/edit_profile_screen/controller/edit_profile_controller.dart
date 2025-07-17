import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_country_city.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/profile_model.dart';
import 'package:the_leaderboard/screens/bottom_nav/bottom_nav.dart';
import 'package:the_leaderboard/services/api/api_get_service.dart';
import 'package:the_leaderboard/services/api/api_patch_service.dart';
import 'package:the_leaderboard/utils/app_logs.dart';

class EditProfileController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final facebookController = TextEditingController();
  final instagramController = TextEditingController();
  final twitterController = TextEditingController();
  final linkedinController = TextEditingController();
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxString userImage = "".obs;
  final RxBool isLoading = true.obs;
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
    appLog("Country updated $value");
  }

  void updateCity(String value) {
    selectedCity.value = value;
    appLog("City updated $value");
  }

  void updateGender(String value) {
    selectedGender.value = value;
    appLog("Gender updated $value");
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
    if (contactController.text.isNotEmpty &&
        contactController.text.length != 11) {
      Get.snackbar(
          "Invalid phone number", "Phone number should be 11 characters",
          colorText: AppColors.white);
      return;
    }
    if (ageController.text.isNotEmpty && int.parse(ageController.text) < 0) {
      Get.snackbar("Age can't be negative", "Please write your correct age",
          colorText: AppColors.white);
      return;
    }
    try {
      await ApiPatchService.updateProfile(
          usernameController.text,
          contactController.text,
          selectedCountry.value,
          selectedCity.value,
          selectedGender.value,
          ageController.text,
          facebookController.text,
          instagramController.text,
          twitterController.text,
          linkedinController.text);
      if (selectedImage.value != null) {
        await ApiPatchService.updateProfileImage(selectedImage.value);
      }
      Get.offAll(const BottomNav());
      appLog("Succeed");
    } catch (e) {
      Get.snackbar(
          "Something went wrong", "Please check your internet connection",
          colorText: AppColors.white, snackPosition: SnackPosition.BOTTOM);
      errorLog("Failed", e);
    }
  }

  void fetchProfile() async {
    isLoading.value = true;
    final response = await ApiGetService.apiGetService(AppUrls.profile);
    isLoading.value = false;
    if (response != null) {
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final userData = ProfileResponseModel.fromJson(data["data"]).user;
        if (userData != null) {
          userImage.value = userData.profileImg;
          usernameController.text = userData.name;
          contactController.text = userData.contact;
          selectedGender.value = userData.gender;
          ageController.text = userData.age;
          facebookController.text = userData.facebook;
          instagramController.text = userData.instagram;
          twitterController.text = userData.twitter;
          linkedinController.text = userData.linkedin;
          updateCountry(userData.country);
          updateCity(userData.city);
          appLog(userData.city);
        }
      }
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchProfile();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    usernameController.dispose();
    contactController.dispose();
    ageController.dispose();
    facebookController.dispose();
    instagramController.dispose();
    twitterController.dispose();
    linkedinController.dispose();
  }
}
