import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:the_leaderboard/common/input_helper.dart';
import 'package:the_leaderboard/common/location_picker_controller.dart';
import 'package:the_leaderboard/common/permission_handler_helper.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_country_city.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/profile_model.dart';
import 'package:the_leaderboard/routes/app_routes.dart';
import 'package:the_leaderboard/screens/bottom_nav/bottom_nav.dart';
import 'package:the_leaderboard/screens/edit_profile_screen/widgets/show_modal_bottom_sheet_widget.dart';
import 'package:the_leaderboard/screens/home_screen/controller/home_screen_controller.dart';
import 'package:the_leaderboard/screens/home_screen/home_screen.dart';
import 'package:the_leaderboard/screens/profile_screen/controller/profile_screen_controller.dart';
import 'package:the_leaderboard/screens/profile_screen/controller/shout_controller.dart';
import 'package:the_leaderboard/screens/profile_screen/profile_screen.dart';
import 'package:the_leaderboard/services/api/api_get_service.dart';
import 'package:the_leaderboard/services/api/api_patch_service.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';
import 'package:the_leaderboard/utils/app_logs.dart';
import 'package:the_leaderboard/widgets/phone_number_field_widget/phone_number_field_widget.dart';
import 'package:twitter_login/twitter_login.dart';

class EditProfileController extends GetxController {
  final LocationPickerController locationPickerController = Get.find();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final facebookController = TextEditingController();
  final instagramController = TextEditingController();
  final twitterController = TextEditingController();
  final linkedinController = TextEditingController();
  final youtubeController = TextEditingController();
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxString userImage = "".obs;
  final RxBool isLoading = true.obs;
  // Image picker instance
  final ImagePicker _picker = ImagePicker();

  final bioController = TextEditingController();
  final RxString selectedGender = 'Male'.obs;

  final List<String> genders = ['Male', 'Female', 'Other'];
  final phone = PhoneNumber().obs;

  final RxBool isValidPhonenumber = true.obs;
  RxBool isSaving = false.obs;

  PhoneNumber? phoneNumber;
  void updatePhoneNumber(PhoneNumber value) {
    phoneNumber = value;
  }

  void updateGender(String value) {
    selectedGender.value = value;
  }

  List<String> findCity(String country) {
    return AppCountryCity.countryCityMap[country]!;
  }

  void onClickEditImage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return ShowModalBottomSheetWidget(
          onTakePhoto: onTakePhoto,
          onChooseFromGallery: pickImage,
        );
      },
    );
  }

  void onTakePhoto() async {
    try {
      final status = await const PermissionHandlerHelper(permission: Permission.camera).getStatus();

      if (status == false) return;

      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
        update();
      }
    } catch (e) {
      appLog(e);
    }
  }

  // Method to pick an image from the gallery
  Future<void> pickImage() async {
    final status = await const PermissionHandlerHelper(permission: Permission.photos).getStatus();
    if (!status) return;
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        appLog("Image is selected");
        selectedImage.value = File(image.path);
      }
    } catch (e) {
      errorLog("Failed", e);
      Get.snackbar(
        "Error",
        "Error picking image",
        colorText: AppColors.white,
      );
    }
  }

  void saveChange() async {
    Get.find<ShoutController>().updateShout(showMessge: false);
    if (isSaving.value) return;

    // if (contactController.t dddext.isNotEmpty &&
    //     contactController.text.length != 11) {
    //   Get.snackbar(
    //       "Invalid phone number", "Phone number should be 11 characters",
    //       colorText: AppColors.white);
    //   return;
    // }
    String contactNo = '';
    if (phoneNumber?.isoCode != null && contactController.text.isNotEmpty) {
      int phoneLenght = getMaxPhoneLength(phoneNumber!.isoCode!);
      if (phoneNumber!.phoneNumber!.length != ((phoneLenght + phoneNumber!.dialCode!.length) - 1)) {
        Get.snackbar(
          "Invalid Phone Number",
          "Please enter a valid phone number.",
          colorText: AppColors.white,
        );
        return;
      } else {
        contactNo = phoneNumber!.phoneNumber!;
      }
    }
    if (facebookController.text.isNotEmpty && !isValidFacebookProfileUrl(facebookController.text)) {
      Get.snackbar(
        "Invalid Facebook Url",
        "Please enter your valid facebook url",
        colorText: AppColors.white,
      );
      return;
    }
    if (instagramController.text.isNotEmpty &&
        !isValidInstagramProfileUrl(instagramController.text)) {
      Get.snackbar(
        "Invalid Instagram Url",
        "Please enter your valid instagram url",
        colorText: AppColors.white,
      );
      return;
    }
    if (twitterController.text.isNotEmpty && !isValidTwitterProfileUrl(twitterController.text)) {
      Get.snackbar(
        "Invalid Twitter Url",
        "Please enter your valid twitter url",
        colorText: AppColors.white,
      );
      return;
    }
    if (linkedinController.text.isNotEmpty && !isValidLinkedInProfileUrl(linkedinController.text)) {
      Get.snackbar(
        "Invalid Linkedin Url",
        "Please enter your valid linkedin url",
        colorText: AppColors.white,
      );
      return;
    }
    if (youtubeController.text.isNotEmpty && !isValidYouTubeChannelUrl(youtubeController.text)) {
      Get.snackbar(
        "Invalid Youtube Url",
        "Please enter your valid youtube channel url",
        colorText: AppColors.white,
      );
      return;
    }

    try {
      final dateOfBirth =
          InputHelper.validate(ValidationType.validateDate, ageController.text) == null
              ? ageController.text
              : "";
      if (ageController.text.isNotEmpty && dateOfBirth.isNotEmpty) {
        Get.snackbar(
          "Invalid Date",
          "Please enter a valid date or keep empty.",
          colorText: AppColors.white,
        );
        isSaving.value = false;
        return;
      }
      Map<String, dynamic> body = {
        "name": usernameController.text,
        if (contactNo.isNotEmpty) "contact": contactNo,
        "gender": selectedGender.value,
        "age": dateOfBirth,
        "country": locationPickerController.countryInitController.text.trim(),
        "city": locationPickerController.cityInitController.text.trim(),
        "facebook": facebookController.text,
        "instagram": instagramController.text,
        "linkedin": linkedinController.text,
        "twitter": twitterController.text,
        "youtube": youtubeController.text,
        "bio": bioController.text
      };
      isSaving.value = true;
      final result = await ApiPatchService.multipartRequestWithDio(
          url: AppUrls.updateUser, image: selectedImage.value, body: body);
      if (result?.statusCode == 200) {
        await Get.find<ProfileScreenController>().fetchProfile(isUpdating: true);
        await Get.find<HomeScreenController>().fetchHomeData(true);
        isSaving.value = false;
        if (Get.arguments != null && Get.arguments['onSuccess'] != null) {
          Get.arguments['onSuccess']();
        }
        Get.back(closeOverlays: true);
      } else {}
      isSaving.value = false;

      appLog("Succeed");
    } catch (e) {
      Get.snackbar(
        "Something went wrong",
        "Please check your internet connection",
        colorText: AppColors.white,
      );
      errorLog("Failed", e);
    } finally {
      isSaving.value = false;
    }
  }

  void fetchProfile() async {
    isLoading.value = true;
    final response = await ApiGetService.apiGetService(AppUrls.profile);
    isLoading.value = false;
    if (response != null) {
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        appLog("response from profile: $data");
        final userData = ProfileResponseModel.fromJson(data["data"]).user;
        if (userData != null) {
          final pH = userData.contact.isNotEmpty
              ? await PhoneNumber.getRegionInfoFromPhoneNumber(userData.contact)
              : null;
          locationPickerController.init(userData.country, userData.city);
          userImage.value = userData.profileImg;
          usernameController.text = userData.name;
          selectedGender.value = userData.gender;
          ageController.text = userData.age;
          facebookController.text = userData.facebook;
          instagramController.text = userData.instagram;
          twitterController.text = userData.twitter;
          linkedinController.text = userData.linkedin;
          youtubeController.text = userData.youtube;
          bioController.text = userData.bio;
          phone.value = pH ?? PhoneNumber();
        }
      }
    }
  }

  void connectWithTwitter() async {
    try {
      final twitterLogin = TwitterLogin(
        apiKey: 'xYM1UuCQGOtbYNyJQmn839Iea',
        apiSecretKey: 'mKJGWhkpuOEyDpVAqhhzvvnl7PD1mzpKZj2wWl7Rff8NrBPxFE',
        redirectURI: 'myapp://',
      );

      // Trigger the sign-in flow
      final authResult = await twitterLogin.login();

      // Create a credential from the access token
      final twitterAuthCredential = TwitterAuthProvider.credential(
        accessToken: authResult.authToken!,
        secret: authResult.authTokenSecret!,
      );

      // Once signed in, return the UserCredential
      final userCred = await FirebaseAuth.instance.signInWithCredential(
        twitterAuthCredential,
      );

      appLog("After twitter login, the usercred: $userCred");
    } catch (e) {
      errorLog("From twitter auth", e);
    }
  }

  /// Returns true if [input] is a valid Facebook profile URL.
  bool isValidFacebookProfileUrl(String input) {
    final url = input.trim().toLowerCase();

    // Check if it contains "facebook.com" and is a valid URL
    return url.contains('facebook.com') && Uri.tryParse(url)?.hasAbsolutePath == true;
  }

  /// Returns true if [input] is a valid Instagram profile URL.
  bool isValidInstagramProfileUrl(String input) {
    final url = input.trim().toLowerCase();

    // Check if it contains "instagram.com" and is a valid URL
    return url.contains('instagram.com') && Uri.tryParse(url)?.hasAbsolutePath == true;
  }

  /// Returns true if [input] is a valid Twitter (X) profile URL.
  bool isValidTwitterProfileUrl(String input) {
    final url = input.trim().toLowerCase();

    // Check if it contains "twitter.com" and is a valid URL
    return url.contains('x.com') && Uri.tryParse(url)?.hasAbsolutePath == true;
  }

  /// Returns true if [input] is a valid LinkedIn personal profile URL.
  bool isValidLinkedInProfileUrl(String input) {
    final url = input.trim().toLowerCase();

    // Check if it contains "linkedin.com/in/" and is a valid URL
    return url.contains('linkedin.com/in/') && Uri.tryParse(url)?.hasAbsolutePath == true;
  }

  /// Returns true if [input] is a valid YouTube channel/profile URL.
  bool isValidYouTubeChannelUrl(String input) {
    final url = input.trim().toLowerCase();

    // Check if it contains "youtube.com" and is a valid URL
    return url.contains('youtube.com') && Uri.tryParse(url)?.hasAbsolutePath == true;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchProfile();
    // onInitial();
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
    youtubeController.dispose();
    bioController.dispose();
  }
}
