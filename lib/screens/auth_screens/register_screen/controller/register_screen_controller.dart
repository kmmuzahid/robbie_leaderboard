import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/models/register_model.dart';
import 'package:the_leaderboard/services/api/api_post_service.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';
import '../../../../routes/app_routes.dart';

class RegisterScreenController extends GetxController {
  // Observable for checkbox state

  // TextEditingControllers for form fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController contactController = TextEditingController();

  // Function to toggle checkbox

  // Function to handle registration
  void register() async {
    // Add your registration logic here
    // Example: Validate form fields and proceed
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String name = nameController.text;
    String country = countryController.text;
    String city = cityController.text;
    String gender = genderController.text;
    String age = ageController.text;
    String contact = contactController.text;
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
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

    final data = await ApiPostService.registerUser(profile);
    if (data != null) {
      LocalStorage.token = data["data"]["token"];
      LocalStorage.myEmail = email;
      // Proceed with registration (e.g., API call, navigation, etc.)
      Get.offNamed(AppRoutes.verifyOtpScreen);
    }
  }

  @override
  void onClose() {
    // Dispose of controllers
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    countryController.dispose();
    cityController.dispose();
    genderController.dispose();
    ageController.dispose();
    contactController.dispose();
    super.onClose();
  }
}
