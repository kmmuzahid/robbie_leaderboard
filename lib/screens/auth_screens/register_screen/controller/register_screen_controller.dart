import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:the_leaderboard/common/location_picker_controller.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/register_model.dart';
import 'package:the_leaderboard/screens/auth_screens/register_screen/widgets/show_terms_conditon_dailogue.dart';
import 'package:the_leaderboard/services/api/api_get_service.dart';
import 'package:the_leaderboard/services/api/api_post_service.dart';
import 'package:the_leaderboard/services/storage/storage_keys.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';
import 'package:the_leaderboard/utils/app_logs.dart';
import '../../../../routes/app_routes.dart';

class RegisterScreenController extends GetxController {
  // Observable for checkbox state
  final LocationPickerController locationPickerController = Get.find();

  // TextEditingControllers for form fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController contactController = TextEditingController();

  final TextEditingController referralController = TextEditingController(text: "");


  final RxString selectedGender = 'Male'.obs;
  final List<String> genders = ['Male', 'Female', 'Other'];

  final RxString phoneNumber = "".obs;
  final RxBool isValidPhonenumber = true.obs;

  Future<void> onInitial() async {
    try {
      fetchTermsAndConditions();
      // countryList.value = await getAllCountries();

      // if (countryList.isNotEmpty) {
      //   // Select first country by default
      //   selectedCountry.value = countryList.first.isoCode;
      //   updateCountry(selectedCountry.value);

      //   // Load its cities
      //   await loadCities(countryList.first.isoCode);
      // }
    } catch (e) {
      appLog("Error loading countries: $e");
    }
  }

  void updateGender(String value) {
    selectedGender.value = value;
  }

  final RxString termAndCondition = ''.obs;
  final RxBool isTermsAndCondtiosnLoading = true.obs;

  Future<void> fetchTermsAndConditions() async {
    if (termAndCondition.value.isNotEmpty) return;
    try {
      appLog("term and condition data is fetching");
      isTermsAndCondtiosnLoading.value = true;
      final response = await ApiGetService.apiGetService(AppUrls.termAndCondition);
      isTermsAndCondtiosnLoading.value = false;
      if (response != null) {
        final jsonbody = jsonDecode(response.body);
        if (response.statusCode == 200) {
          termAndCondition.value = jsonbody["data"]["text"];
        } else {
          Get.snackbar(
            "Error",
            jsonbody["message"],
            colorText: AppColors.white,
          );
          termAndCondition.value = "";
        }
      }
    } catch (e) {
      errorLog("Failed", e);
    }
  }

  void register() async {
    // Get trimmed and raw values
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String name = nameController.text.trim();
    String country = locationPickerController.countryInitController.text.trim();
    String city = locationPickerController.cityInitController.text.trim();
    String gender = selectedGender.value.trim();
    String age = ageController.text.trim();
    String contact = phoneNumber.value.trim();
    String referral = referralController.text.trim();

    // Required fields validation (city, gender, age, referral removed)
    if (email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        name.isEmpty ||
        country.isEmpty ||
        contact.isEmpty) {
      Get.closeAllSnackbars();
      Get.snackbar('Form Incomplete', 'Please fill in all required fields.',
          colorText: AppColors.white);
      return;
    }

    if (password != confirmPassword) {
      Get.closeAllSnackbars();
      Get.snackbar(
        'Password Mismatch',
        'The passwords you entered don\'t match. Please try again.',
      );
      return;
    }

    if (password.length < 6) {
      Get.closeAllSnackbars();
      Get.snackbar(
        "Password Too Short",
        "Please enter a password with at least 6 characters.",
        colorText: AppColors.white,
      );
      return;
    }

    if (!isValidPhonenumber.value) {
      Get.closeAllSnackbars();
      Get.snackbar(
        "Invalid Phone Number",
        "Please enter a valid phone number.",
        colorText: AppColors.white,
      );
      return;
    }

    if (name.length > 16) {
      Get.closeAllSnackbars();
      Get.snackbar(
        "Name is too long",
        "Name should be maximum 16 characters",
        colorText: AppColors.white,
      );
      return;
    }

    appLog(
        "User is registering with $email, $password, $name, $country, $city, $gender, $age and $contact");

    // Allow empty strings or null for optional fields
    final profile = RegisterModel(
      name: name,
      email: email,
      contact: contact,
      password: password,
      country: country,
      city: city.isNotEmpty ? city : null,
      gender: gender.isNotEmpty ? gender : null,
      age: age.isNotEmpty ? age : null,
      userCode: referral.isNotEmpty ? referral : null,
    );

    await fetchTermsAndConditions();

    final isAccepted = await showTermsDialog(Get.context!, this);
    if (isAccepted == false) {
      return;
    }

    try {
      final response = await ApiPostService.apiPostService(AppUrls.registerUser, profile.toJson());
      if (response != null) {
        final data = jsonDecode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          LocalStorage.token = data["data"]["token"];
          LocalStorage.myEmail = email;
          LocalStorage.setString(LocalStorageKeys.myEmail, email);
          Get.closeAllSnackbars();
          Get.snackbar("Success", data["message"], colorText: AppColors.white);
          Get.offNamed(AppRoutes.verifyOtpScreen);
        } else {
          Get.closeAllSnackbars();
          Get.snackbar("Error", data["message"], colorText: AppColors.white);
        }
      }
      appLog("Succeed");
    } catch (e) {
      errorLog("Failed", e);
    }
    return;
  }

  void onSelectDateBirth(BuildContext context) async {
    final temp = await showDatePicker(
        initialDate: DateTime.now(),
        context: context,
        firstDate: DateTime(1900),
        lastDate: DateTime(3000));
    appLog(temp);
    if (temp != null) {
      final date = DateFormat("yyyy-MM-dd").format(temp);
      ageController.text = date;
    }
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
    referralController.dispose();
    super.onClose();
  }
}
