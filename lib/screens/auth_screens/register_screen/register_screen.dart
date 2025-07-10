import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_country_city.dart';
import 'package:the_leaderboard/screens/auth_screens/register_screen/widgets/dropdown_button_widget.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_icon_path.dart';
import '../../../constants/app_strings.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/button_widget/button_widget.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_button_widget/text_button_widget.dart';
import '../../../widgets/text_field_widget/text_field_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';
import 'controller/register_screen_controller.dart';

class RegisterScreen extends StatelessWidget {  
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: RegisterScreenController(),
      builder: (controller) => AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: AppColors.blueDark,
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SpaceWidget(spaceHeight: 48),
                  const Center(
                    child: TextWidget(
                      text: AppStrings.createAccount,
                      fontColor: AppColors.blueLighter,
                      fontWeight: FontWeight.w600,
                      fontSize: 32,
                    ),
                  ),
                  const SpaceWidget(spaceHeight: 12),
                  const Center(
                    child: TextWidget(
                      text: AppStrings.enterPersonalData,
                      fontColor: AppColors.blueLighter,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                  const SpaceWidget(spaceHeight: 28),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TextWidget(
                      text: AppStrings.email,
                      fontColor: AppColors.greyDark,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  const SpaceWidget(spaceHeight: 8),
                  TextFieldWidget(
                    controller: controller.emailController,
                    hintText: 'Enter email',
                    maxLines: 1,
                  ),
                  const SpaceWidget(spaceHeight: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TextWidget(
                      text: AppStrings.password,
                      fontColor: AppColors.greyDark,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  const SpaceWidget(spaceHeight: 8),
                  TextFieldWidget(
                    controller: controller.passwordController,
                    hintText: 'Enter password',
                    maxLines: 1,
                    suffixIcon: AppIconPath.visibilityOnIcon,
                  ),
                  const SpaceWidget(spaceHeight: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TextWidget(
                      text: AppStrings.confirmPassword,
                      fontColor: AppColors.greyDark,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  const SpaceWidget(spaceHeight: 8),
                  TextFieldWidget(
                    controller: controller.confirmPasswordController,
                    hintText: 'Enter password',
                    maxLines: 1,
                    suffixIcon: AppIconPath.visibilityOnIcon,
                  ),
                  const SpaceWidget(spaceHeight: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TextWidget(
                      text: AppStrings.name,
                      fontColor: AppColors.greyDark,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  const SpaceWidget(spaceHeight: 8),
                  TextFieldWidget(
                      controller: controller.nameController,
                      hintText: "Enter name"),
                  const SpaceWidget(spaceHeight: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TextWidget(
                      text: AppStrings.country,
                      fontColor: AppColors.greyDark,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  const SpaceWidget(spaceHeight: 8),
                  Obx(
                    () => DropdownButtonWidget(
                      value: controller.selectedCountry.value,
                      items: AppCountryCity.countryCityMap.keys.toList(),
                      onChanged: (value) => controller.updateCountry(value!),
                    ),
                  ),
                  const SpaceWidget(spaceHeight: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TextWidget(
                      text: AppStrings.city,
                      fontColor: AppColors.greyDark,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  const SpaceWidget(spaceHeight: 8),
                  Obx(
                    () => DropdownButtonWidget(
                      value: controller.selectedCity.value,
                      items: controller.cities,
                      onChanged: (value) => controller.updateCity(value!),
                    ),
                  ),
                  const SpaceWidget(spaceHeight: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TextWidget(
                      text: AppStrings.gender,
                      fontColor: AppColors.greyDark,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  const SpaceWidget(spaceHeight: 8),
                  Obx(
                    () => DropdownButtonWidget(
                      value: controller.selectedGender.value,
                      items: controller.genders,
                      onChanged: (value) => controller.updateGender(value!),
                    ),
                  ),
                  const SpaceWidget(spaceHeight: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TextWidget(
                      text: AppStrings.age,
                      fontColor: AppColors.greyDark,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  const SpaceWidget(spaceHeight: 8),
                  TextFieldWidget(
                      controller: controller.ageController,
                      hintText: "Enter age"),
                  const SpaceWidget(spaceHeight: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TextWidget(
                      text: AppStrings.contact,
                      fontColor: AppColors.greyDark,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  const SpaceWidget(spaceHeight: 8),
                  TextFieldWidget(
                      controller: controller.contactController,
                      hintText: "Enter contact"),
                  const SpaceWidget(spaceHeight: 24),
                  ButtonWidget(
                    onPressed: controller.register,
                    label: AppStrings.register,
                    buttonWidth: double.infinity,
                  ),
                  const SpaceWidget(spaceHeight: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const TextWidget(
                        text: AppStrings.alreadyHaveAnAccount,
                        fontColor: AppColors.blueLighter,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                      const SpaceWidget(spaceWidth: 4),
                      TextButtonWidget(
                        onPressed: () {
                          Get.offAllNamed(AppRoutes.loginScreen);
                        },
                        text: AppStrings.login,
                        textColor: AppColors.skyBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.skyBlue,
                      ),
                    ],
                  ),
                  const SpaceWidget(spaceHeight: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
