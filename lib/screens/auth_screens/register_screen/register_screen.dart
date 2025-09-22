import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:the_leaderboard/constants/app_country_city.dart';
import 'package:the_leaderboard/screens/auth_screens/register_screen/widgets/dropdown_button_widget.dart';

import 'package:the_leaderboard/widgets/phone_number_field_widget/phone_number_field_widget.dart';

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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final controller = Get.put(RegisterScreenController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.onInitial();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
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
                  hintText: 'Enter Email',
                  keyboardType: TextInputType.emailAddress,
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
                  hintText: 'Enter Password',
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
                  hintText: 'Enter Password Again',
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
                    hintText: "Enter Name"),
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
                    hintText: 'PLease select your country',
                    items: controller.countryList
                        .map((c) => DropdownMenuItem(
                              value: c.isoCode,
                              child: TextWidget(
                                text: c.name,
                                fontColor: AppColors.white,
                              ),
                            ))
                        .toList(),
                    onChanged: (value) => controller.updateCountry(value!),
                  ),
                ),
                const SpaceWidget(spaceHeight: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: TextWidget(
                    text: "${AppStrings.city} (Optional)",
                    fontColor: AppColors.greyDark,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
                const SpaceWidget(spaceHeight: 8),
                Obx(
                  () => DropdownButtonWidget(
                    hintText: 'Please select your city',
                    items: controller.cityList
                        .map((c) => DropdownMenuItem(
                              value: c.name,
                              child: TextWidget(
                                text: c.name,
                                fontColor: AppColors.white,
                              ),
                            ))
                        .toList(),
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
                DropdownButtonWidget(
                  hintText: 'Please select your gender',
                  items: controller.genders
                      .map((e) => DropdownMenuItem<String>(
                          value: e,
                          child: TextWidget(
                            text: e,
                            fontColor: AppColors.white,
                          )))
                      .toList(),
                  onChanged: (value) => controller.updateGender(value!),
                ),
                const SpaceWidget(spaceHeight: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: TextWidget(
                    text: AppStrings.dateOfBirth,
                    fontColor: AppColors.greyDark,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
                const SpaceWidget(spaceHeight: 8),
                TextFieldWidget(
                  controller: controller.ageController,
                  hintText: "Enter Date of Birth",
                  keyboardType: TextInputType.datetime,
                  suffixIcon: AppIconPath.calenderIcon,
                  onTapSuffix: () => controller.onSelectDateBirth(context),
                ),
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
                PhoneNumberFieldWidget(
                  initialValue: PhoneNumber(isoCode: "ZA"),
                  controller: controller.contactController,
                  onInputChanged: (p0) {
                    controller.phoneNumber.value = p0.phoneNumber!;
                  },
                  onInputValidated: (p0) {
                    controller.isValidPhonenumber.value = p0;
                  },
                ),
                // TextFieldWidget(
                //     controller: controller.contactController,
                //     hintText: "Enter Contact"),
                const SpaceWidget(spaceHeight: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: TextWidget(
                    text: "${AppStrings.referral} (Optional)",
                    fontColor: AppColors.greyDark,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
                const SpaceWidget(spaceHeight: 8),
                TextFieldWidget(
                    controller: controller.referralController,
                    hintText: "Enter Inviter Code (if any)"),
                const SpaceWidget(spaceHeight: 24),
                ButtonWidget(
                  onPressed: controller.register,
                  label: AppStrings.register,
                  buttonWidth: double.infinity,
                ),
                const SpaceWidget(spaceHeight: 24),

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
    );
  }
}
