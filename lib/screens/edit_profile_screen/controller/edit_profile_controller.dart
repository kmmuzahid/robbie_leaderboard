import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/routes/app_routes.dart';
import 'package:the_leaderboard/services/api/api_patch_service.dart';

class EditProfileController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();
  final TextEditingController twitterController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController roleController = TextEditingController();

  void saveChange() async {
    await ApiPatchService.updateProfile(
        usernameController.text,
        contactController.text,
        countryController.text,
        cityController.text,
        genderController.text,
        ageController.text,
        roleController.text);
    Get.toNamed(AppRoutes.settingsScreen);
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    usernameController.dispose();
    contactController.dispose();
    countryController.dispose();
    cityController.dispose();
    genderController.dispose();
    ageController.dispose();
    roleController.dispose();
    instagramController.dispose();
    twitterController.dispose();
  }
}
