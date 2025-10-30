import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/register_model.dart';
import 'package:the_leaderboard/screens/auth_screens/register_screen/widgets/show_terms_conditon_dailogue.dart';
import 'package:the_leaderboard/screens/terms_condition_screen/terms_conditions_screen.dart';
import 'package:the_leaderboard/services/api/api_get_service.dart';
import 'package:the_leaderboard/services/api/api_post_service.dart';
import 'package:the_leaderboard/services/storage/storage_keys.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';
import 'package:the_leaderboard/utils/app_logs.dart';
import '../../../../routes/app_routes.dart';

class RegisterScreenController extends GetxController {
  // Observable for checkbox state

  // TextEditingControllers for form fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final countryController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final TextEditingController referralController = TextEditingController(text: "");
  final RxString selectedCountry = ''.obs;
  final RxString selectedCity = ''.obs;
  final RxString selectedGender = 'Male'.obs;
  List<String> cities = ["Sydney DC", "Melbourne", "Brisbane"];
  final List<String> genders = ['Male', 'Female', 'Other'];

  final RxString phoneNumber = "".obs;
  final RxBool isValidPhonenumber = true.obs;
  // RxList<Country> countryList = <Country>[].obs;
  // RxList<City> cityList = <City>[].obs;
  final finalSelectedCountry = "".obs;

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

  Future<void> loadCities(String countryCode) async {
    // try {
    // final fetchedCities = await LocationRepo.getCountryCities(countryCode);

      // Use a Set to ensure uniqueness
    // final uniqueNames = <String>{};
    //   final uniqueCities = fetchedCities.where((city) {
    //     if (uniqueNames.contains(city.name)) {
    //       return false; // skip duplicates
    //     } else {
    //       uniqueNames.add(city.name);
    //       return true; // keep first occurrence
    //     }
    //   }).toList();

    //   cityList.value = uniqueCities;

    //   if (cityList.isNotEmpty) {
    //     selectedCity.value = cityList.first.name;
    //   }
    // } catch (e) {
    //   appLog("Error loading cities: $e");
    // }
  }

  Future<void> updateCountry(String isoCode) async {
    // try {
    //   cityList.clear();
    //   selectedCountry.value = isoCode;
    //   countryList.value = await getAllCountries();
    //   final country = countryList.firstWhereOrNull(
    //     (c) => c.isoCode == isoCode,
    //   );

    //   appLog(
    //       "Found country: ${country!.name} and country code: ${country.isoCode} and default isoCode: $isoCode");

    //   finalSelectedCountry.value = country.name;
    //   await loadCities(isoCode);
    //   appLog("Country updated: $isoCode");
    // } catch (e) {
    //   appLog(e); // TODO
    // }
  }

  void updateCity(String value) {
    selectedCity.value = value;
  }

  void updateGender(String value) {
    selectedGender.value = value;
  }

  // List<String> findCity(String country) {
  //   return cityList
  //       .where((city) => city.countryName == country)
  //       .map((city) => city.name)
  //       .toList();
  // }

  // Rxn<RegisterModel> profile = Rxn<RegisterModel>();
  // Function to toggle checkbox

  // Function to handle registration
  // void register() async {
  //   // Add your registration logic here
  //   // Example: Validate form fields and proceed
  //   String email = emailController.text.trim();
  //   String password = passwordController.text.trim();
  //   String confirmPassword = confirmPasswordController.text.trim();
  //   String name = nameController.text;
  //   String country = finalSelectedCountry.value;
  //   String city = selectedCity.value;
  //   String gender = selectedGender.value;
  //   String age = ageController.text;
  //   String contact = phoneNumber.value;
  //   String referral = referralController.text;

  //   if (email.isEmpty ||
  //       password.isEmpty ||
  //       confirmPassword.isEmpty ||
  //       name.isEmpty ||
  //       age.isEmpty ||
  //       finalSelectedCountry.isEmpty ||
  //       contact.isEmpty ||
  //       selectedGender.isEmpty) {
  //     Get.closeAllSnackbars();
  //     Get.snackbar('Form Incomplete', 'Please fill in all fields.',
  //         colorText: AppColors.white);
  //     return;
  //   }

  //   if (password != confirmPassword) {
  //     Get.closeAllSnackbars();
  //     Get.snackbar(
  //       'Password Mismatch',
  //       'The passwords you entered don\'t match. Please try again.',

  //     );

  //     return;
  //   }
  //   if (password.length < 6) {
  //     Get.closeAllSnackbars();
  //     Get.snackbar(
  //       "Password Too Short",
  //       "Please enter a password with at least 6 characters.",
  //       colorText: AppColors.white,
  //     );

  //     return;
  //   }
  //   if (!isValidPhonenumber.value) {
  //     Get.closeAllSnackbars();
  //     Get.snackbar(
  //       "Invalid Phone Number",
  //       "Please enter a valid phone number.",
  //       colorText: AppColors.white,

  //     );
  //     return;
  //   }

  //   if (name.length > 16) {
  //     Get.closeAllSnackbars();
  //     Get.snackbar(
  //       "Name is too long",
  //       "Name should be maximum 16 characters",
  //       colorText: AppColors.white,
  //     );

  //     return;
  //   }
  //   appLog(
  //       "User is registering with $email, $password, $name, $country, $city, $gender, $age and $contact");
  //   final profile = RegisterModel(
  //       name: name,
  //       email: email,
  //       contact: contact,
  //       password: password,
  //       country: country,
  //       city: city,
  //       gender: gender,
  //       age: age,
  //       userCode: referral);
  //   try {
  //     final response = await ApiPostService.apiPostService(
  //         AppUrls.registerUser, profile.toJson());
  //     if (response != null) {
  //       final data = jsonDecode(response.body);
  //       if (response.statusCode == 200 || response.statusCode == 201) {
  //         LocalStorage.token = data["data"]["token"];
  //         LocalStorage.myEmail = email;
  //         LocalStorage.setString(LocalStorageKeys.myEmail, email);
  //         Get.closeAllSnackbars();
  //         Get.snackbar("Success", data["message"], colorText: AppColors.white);
  //         // Proceed with registration (e.g., API call, navigation, etc.)
  //         Get.offNamed(AppRoutes.verifyOtpScreen);
  //       } else {
  //         Get.closeAllSnackbars();
  //         Get.snackbar("Error", data["message"], colorText: AppColors.white);
  //       }
  //     }
  //     appLog("Succeed");
  //   } catch (e) {
  //     errorLog("Failed", e);
  //   }
  //   return;
  // }

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
    String country = finalSelectedCountry.value.trim();
    String city = selectedCity.value.trim();
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
    countryController.dispose();
    stateController.dispose();
    cityController.dispose();
    super.onClose();
  }
}
