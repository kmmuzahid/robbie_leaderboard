import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/routes/app_routes.dart';
import 'package:the_leaderboard/widgets/text_button_widget/text_button_widget.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_icon_path.dart';
import '../../../constants/app_strings.dart';
import '../../../widgets/button_widget/button_widget.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_field_widget/text_field_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';
import 'controller/login_screen_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: LoginScreenController(),
      builder: (controller) => AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: AppColors.blueDark,
          body: Center(
            child: controller.isLoading.value
                ? const CircularProgressIndicator.adaptive()
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: TextWidget(
                            text: AppStrings.welcome,
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
                        const SpaceWidget(spaceHeight: 24),
                        // Add Remember Me Checkbox
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Transform.scale(
                                    scale: 0.9,
                                    child: Checkbox(
                                      value: controller.rememberMe.value,
                                      onChanged: (value) {
                                        controller.rememberMe.value =
                                            value ?? false;
                                      },
                                      activeColor: AppColors.blueLighter,
                                      checkColor: AppColors.blueDark,
                                    ),
                                  ),
                                ),
                                const SpaceWidget(spaceWidth: 8),
                                const TextWidget(
                                  text: AppStrings.rememberMe,
                                  fontColor: AppColors.blueLighter,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                              ],
                            ),
                            TextButtonWidget(
                              onPressed: () {
                                Get.toNamed(AppRoutes.forgotPasswordScreen);
                              },
                              text: AppStrings.forgotPassword,
                              textColor: AppColors.skyBlue,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.skyBlue,
                            ),
                          ],
                        ),
                        const SpaceWidget(spaceHeight: 24),
                        ButtonWidget(
                          onPressed: controller.login,
                          label: AppStrings.login,
                          buttonWidth: double.infinity,
                        ),
                        const SpaceWidget(spaceHeight: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const TextWidget(
                              text: AppStrings.dontHaveAccount,
                              fontColor: AppColors.blueLighter,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                            const SpaceWidget(spaceWidth: 4),
                            TextButtonWidget(
                              onPressed: () {
                                Get.toNamed(AppRoutes.registerScreen);
                              },
                              text: AppStrings.register,
                              textColor: AppColors.skyBlue,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.skyBlue,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
