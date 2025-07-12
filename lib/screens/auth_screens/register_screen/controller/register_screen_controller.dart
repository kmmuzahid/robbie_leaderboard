import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_country_city.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/register_model.dart';
import 'package:the_leaderboard/services/api/api_post_service.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';
import 'package:the_leaderboard/utils/app_logs.dart';
import '../../../../routes/app_routes.dart';

class RegisterScreenController extends GetxController {
  // Observable for checkbox state

  // TextEditingControllers for form fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController contactController = TextEditingController();

  final RxString selectedCountry = 'Australia'.obs;
  final RxString selectedCity = 'Sydney DC'.obs;
  final RxString selectedGender = 'Male'.obs;
  List<String> cities = ["Sydney", "Melbourne", "Brisbane"];
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

  // Rxn<RegisterModel> profile = Rxn<RegisterModel>();
  // Function to toggle checkbox

  // Function to handle registration
  void register() async {
    // Add your registration logic here
    // Example: Validate form fields and proceed
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String name = nameController.text;
    String country = selectedCountry.value;
    String city = selectedCity.value;
    String gender = selectedGender.value;
    String age = ageController.text;
    String contact = contactController.text;
    if (email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        name.isEmpty ||
        age.isEmpty ||
        contact.isEmpty) {
      Get.snackbar(
        'Form Incomplete',
        'Please fill in all fields.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar(
        'Password Mismatch',
        'Passwords do not match.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (password.length < 6) {
      Get.snackbar("Password is too short",
          "Please write a password with atleast 6 characters",
          colorText: AppColors.white, snackPosition: SnackPosition.BOTTOM);
      return;
    }
    appLog(
        "User is registering with $email, $password, $name, $country, $city, $gender, $age and $contact");
    final profile = RegisterModel(
      name: name,
      email: email,
      contact: contact,
      password: password,
      country: country,
      city: city,
      gender: gender,
      age: age,
    );
    try {
      final response = await ApiPostService.apiPostService(
          AppUrls.registerUser, profile.toJson());
      if (response != null) {
        final data = jsonDecode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          LocalStorage.token = data["data"]["token"];
          LocalStorage.myEmail = email;
          Get.snackbar("Success", data["message"], colorText: AppColors.white);
          // Proceed with registration (e.g., API call, navigation, etc.)
          Get.offNamed(AppRoutes.verifyOtpScreen);
        } else {
          Get.snackbar("Error", data["message"], colorText: AppColors.white);
        }
      }
      appLog("Succeed");
    } catch (e) {
      errorLog("Failed", e);
    }
    return;
  }

  @override
  void onClose() {
    // Dispose of controllers
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    ageController.dispose();
    contactController.dispose();
    super.onClose();
  }
}
