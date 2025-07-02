import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/services/api/api_patch_service.dart';

class EditProfileController extends GetxController {
  final TextEditingController fullNameController = TextEditingController();
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
  }  
}
