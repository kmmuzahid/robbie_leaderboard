import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_leaderboard/screens/bottom_nav/bottom_nav.dart';
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

  final Rx<File?> selectedImage = Rx<File?>(null);

  // Image picker instance
  final ImagePicker _picker = ImagePicker();

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
        countryController.text,
        cityController.text,
        genderController.text,
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
    countryController.dispose();
    cityController.dispose();
    genderController.dispose();
    ageController.dispose();
    roleController.dispose();
    instagramController.dispose();
    twitterController.dispose();
  }
}
