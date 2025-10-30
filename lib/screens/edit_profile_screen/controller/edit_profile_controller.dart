import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:permission_handler/permission_handler.dart';
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
import 'package:the_leaderboard/screens/profile_screen/profile_screen.dart';
import 'package:the_leaderboard/services/api/api_get_service.dart';
import 'package:the_leaderboard/services/api/api_patch_service.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';
import 'package:the_leaderboard/utils/app_logs.dart';
import 'package:twitter_login/twitter_login.dart';

class EditProfileController extends GetxController {
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

  final RxString selectedCountry = ''.obs;
  final RxString selectedCity = ''.obs;
  final RxString selectedGender = 'Male'.obs;
  List<String> cities = ["Sydney", "Melbourne", "Brisbane"];
  final List<String> genders = ['Male', 'Female', 'Other'];
  final phone = PhoneNumber().obs;

  final RxString phoneNumber = "".obs;
  final RxBool isValidPhonenumber = true.obs;
  // RxList<Country> countryList = <Country>[].obs;
  // RxList<City> cityList = <City>[].obs;
  final finalSelectedCountry = "".obs;
  RxBool isSaving = false.obs;

  Future<void> onInitial() async {
    // try {
    //   // countryList.value = await getAllCountries();
    //   if (countryList.isNotEmpty) {
    //     // Select first country by default
    //     selectedCountry.value = countryList.first.isoCode;

    //     // Load its cities
    //     await loadCities(countryList.first.isoCode);
    //   }
    // } catch (e) {
    //   appLog("Error loading countries: $e");
    // }
  }

  Future<void> loadCities(String countryCode) async {
    try {
      // final fetchedCities = await LocationRepo.getCountryCities(countryCode);

      // Use a Set to ensure uniqueness
      // final uniqueNames = <String>{};
      // final uniqueCities = fetchedCities.where((city) {
      //   if (uniqueNames.contains(city.name)) {
      //     return false; // skip duplicates
      //   } else {
      //     uniqueNames.add(city.name);
      //     return true; // keep first occurrence
      //   }
      // }).toList();

      // cityList.value = uniqueCities;

      // if (cityList.isNotEmpty) {
      //   selectedCity.value = cityList.first.name;
      // }
    } catch (e) {
      appLog("Error loading cities: $e");
    }
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
    appLog("City updated $value");
  }

  void updateGender(String value) {
    selectedGender.value = value;
    appLog("Gender updated $value");
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
    if (isSaving.value) return;
    isSaving.value = true;
    appLog("Changes are saving");
    // if (contactController.text.isNotEmpty &&
    //     contactController.text.length != 11) {
    //   Get.snackbar(
    //       "Invalid phone number", "Phone number should be 11 characters",
    //       colorText: AppColors.white);
    //   return;
    // }

    if (!(isValidPhonenumber.value)) {
      Get.snackbar(
        "Invalid Phone Number",
        "Please enter a valid phone number.",
        colorText: AppColors.white,
      );
      return;
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
      Map<String, dynamic> body = {
        "name": usernameController.text,
        "contact": phoneNumber.value,
        "gender": selectedGender.value,
        "age": ageController.text,
        "country": finalSelectedCountry.value,
        "city": selectedCity.value,
        "facebook": facebookController.text,
        "instagram": instagramController.text,
        "linkedin": linkedinController.text,
        "twitter": twitterController.text,
        "youtube": youtubeController.text,
        "bio": bioController.text
      };
      final url = "${AppUrls.updateUser}/${LocalStorage.userId}";
      // await ApiPatchService.formDataRequest(
      //     body: body, image: selectedImage.value?.path ?? "", url: url);
      await ApiPatchService.MultipartRequest1(
          url: url, imagePath: selectedImage.value?.path ?? "", body: body);
      // await ApiPatchService.updateProfile(selectedImage.value,
      //     usernameController.text,
      //     phoneNumber.value,
      //     selectedCountry.value,
      //     selectedCity.value,
      //     selectedGender.value,
      //     ageController.text,
      //     facebookController.text,
      //     instagramController.text,
      //     twitterController.text,
      //     linkedinController.text);
      Get.find<ProfileScreenController>().fetchProfile(isUpdating: true);
      Get.until((route) => route.settings.name == '/BottomNav');

      appLog("Succeed");
    } catch (e) {
      Get.snackbar(
        "Something went wrong",
        "Please check your internet connection",
        colorText: AppColors.white,
      );
      errorLog("Failed", e);
    }
    isSaving.value = false;
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
          userImage.value = userData.profileImg;
          usernameController.text = userData.name;
          // contactController.text = userData.contact;
          selectedGender.value = userData.gender;
          ageController.text = userData.age;
          facebookController.text = userData.facebook;
          instagramController.text = userData.instagram;
          twitterController.text = userData.twitter;
          linkedinController.text = userData.linkedin;
          youtubeController.text = userData.youtube;
          bioController.text = userData.bio;
          phone.value = await PhoneNumber.getRegionInfoFromPhoneNumber(userData.contact);
          // countryList.value = await getAllCountries();
          // final country = countryList.firstWhereOrNull(
          //   (c) => c.name.toLowerCase() == userData.country.toLowerCase(),
          // );
          // if (country != null) {
          //   appLog("Found country: ${country.name} and country code: ${country.isoCode}");
          //   await updateCountry(country.isoCode);
          //   // After cities loaded, select user’s saved city
          //   appLog("City list: $cityList");
          //   final city = cityList.firstWhereOrNull(
          //     (c) => c.name.toLowerCase() == userData.city.toLowerCase(),
          //   );
          //   appLog("Found city: ${city?.name} and default city: ${userData.city}");
          //   if (city != null) {
          //     updateCity(city.name);
          //   }
          //   // updateCountry(userData.country);
          //   // updateCity(userData.city);
          //   appLog(userData.city);
          // }
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
