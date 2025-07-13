import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_country_city.dart';
import 'package:the_leaderboard/constants/app_icon_path.dart';
import 'package:the_leaderboard/constants/app_image_path.dart';
import 'package:the_leaderboard/screens/edit_profile_screen/controller/edit_profile_controller.dart';
import 'package:the_leaderboard/screens/edit_profile_screen/widgets/dropdown_button_widget.dart';
import 'package:the_leaderboard/widgets/icon_widget/icon_widget.dart';
import 'package:the_leaderboard/widgets/image_widget/image_widget.dart';
import 'package:the_leaderboard/widgets/shimmer_loading_widget/shimmer_loading.dart';

import '../../constants/app_colors.dart';
import '../../widgets/appbar_widget/appbar_widget.dart';
import '../../widgets/button_widget/button_widget.dart';
import '../../widgets/space_widget/space_widget.dart';
import '../../widgets/text_widget/text_widgets.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required EditProfileController profileController
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          text: label,
          fontColor: AppColors.greyLight,
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        const SpaceWidget(spaceHeight: 8),
        profileController.isLoading.value? const ShimmerLoading(width: double.infinity, height: 55):
        TextField(
          controller: controller,
          style: const TextStyle(color: AppColors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.blue,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
      {required String label,
      required String value,
      required List<String> items,
       required EditProfileController profileController,
      required void Function(String?) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          text: label,
          fontColor: AppColors.greyLight,
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        const SpaceWidget(spaceHeight: 8),
        profileController.isLoading.value? const ShimmerLoading(width: double.infinity, height: 55):
        DropdownButtonWidget(value: value, items: items, onChanged: onChanged)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: EditProfileController(),
      builder: (controller) => AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: AppColors.blueDark,
          appBar: const AppbarWidget(
            title: "Edit Profile",
            centerTitle: true,
          ),
          body: Obx(
            () => SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Picture
                  Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: controller.selectedImage.value != null
                              ? Image.file(
                                  controller.selectedImage.value!,
                                  fit: BoxFit.cover,
                                  width: 80,
                                  height: 80,
                                )
                              : const ImageWidget(
                                  height: 80,
                                  width: 80,
                                  imagePath: AppImagePath.profileImage,
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: -2,
                        right: -2,
                        child: GestureDetector(
                          onTap: controller.pickImage, // Call the image picker
                          child: const IconWidget(
                            height: 30,
                            width: 30,
                            icon: AppIconPath.editImageButtonIcon,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SpaceWidget(spaceHeight: 24),

                  // Username
                  _buildTextField(
                    label: "Username",
                    controller: controller.usernameController,
                    profileController: controller
                  ),
                  const SpaceWidget(spaceHeight: 12),
                  _buildTextField(
                    label: "Contact",
                    controller: controller.contactController, profileController: controller
                  ),
                  const SpaceWidget(spaceHeight: 12),
                  _buildDropdownField(
                    label: "Gender",
                    value: controller.selectedGender!.value,
                    items: controller.genders,
                    onChanged: (p0) => controller.updateGender(p0!), profileController: controller
                  ),

                  const SpaceWidget(spaceHeight: 12),
                  _buildTextField(
                    label: "Age",
                    controller: controller.ageController, profileController: controller
                  ),
                  const SpaceWidget(spaceHeight: 12),
                  _buildDropdownField(
                    label: "Country",
                    value: controller.selectedCountry.value,
                    items: AppCountryCity.countryCityMap.keys.toList(),
                    onChanged: (p0) => controller.updateCountry(p0!), profileController: controller
                  ),

                  const SpaceWidget(spaceHeight: 12),
                  _buildDropdownField(
                    label: "City",
                    value: controller.selectedCity.value,
                    items: controller.cities,
                    onChanged: (p0) => controller.updateCity(p0!), profileController: controller
                  ),

                  const SpaceWidget(spaceHeight: 12),
                  // Country

                  // Save Changes Button
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: ButtonWidget(
              onPressed: controller.saveChange,
              label: "Save Changes",
              buttonWidth: double.infinity,
            ),
          ),
        ),
      ),
    );
  }
}
