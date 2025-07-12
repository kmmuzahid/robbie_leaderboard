import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/screens/auth_screens/forgot_verify_otp_screen/widgets/otp_field_widget.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../widgets/auth_appbar_widget/auth_appbar_widget.dart';
import '../../../widgets/button_widget/button_widget.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_button_widget/text_button_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';
import 'controller/forgot_verify_otp_screen_controller.dart';

class ForgotVerifyOtpScreen extends StatelessWidget {
  const ForgotVerifyOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller

    return GetBuilder(
      init: ForgotVerifyOtpController(),
      builder: (controller) => AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: AppColors.blueDark,
          appBar: const AuthAppbarWidget(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpaceWidget(spaceHeight: 82),
                const Center(
                  child: TextWidget(
                    text: AppStrings.enterOtp,
                    fontColor: AppColors.blueLighter,
                    fontWeight: FontWeight.w600,
                    fontSize: 32,
                  ),
                ),
                const SpaceWidget(spaceHeight: 12),
                const Center(
                  child: TextWidget(
                    text: AppStrings.enterOtpDescription,
                    fontColor: AppColors.blueLighter,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
                const SpaceWidget(spaceHeight: 16),

                // Timer widget

                const SpaceWidget(spaceHeight: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: TextWidget(
                    text: AppStrings.enterCode,
                    fontColor: AppColors.greyDark,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
                const SpaceWidget(spaceHeight: 8),
                Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        OtpInputFieldWidget(
                          controller: controller.otpTextEditingController1,
                        ),
                        OtpInputFieldWidget(
                          controller: controller.otpTextEditingController2,
                        ),
                        OtpInputFieldWidget(
                          controller: controller.otpTextEditingController3,
                        ),
                        OtpInputFieldWidget(
                          controller: controller.otpTextEditingController4,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (p0) {
                            FocusManager.instance.primaryFocus?.unfocus(
                                disposition:
                                    UnfocusDisposition.previouslyFocusedChild);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(() => controller.isTimerRunning.value
                    ? const SpaceWidget(spaceHeight: 12)
                    : const SizedBox.shrink()),
                Obx(
                  () => controller.isTimerRunning.value
                      ? Row(
                          children: [
                            const TextWidget(
                              text: AppStrings.codeWillExpire,
                              fontColor: AppColors.greyDarker,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                            const SpaceWidget(spaceWidth: 4),
                            TextWidget(
                              text: controller.formattedTime,
                              fontColor: AppColors.orange,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
                const SpaceWidget(spaceHeight: 24),
                ButtonWidget(
                  onPressed: controller.verifyOtp,
                  label: AppStrings.verifyCode,
                  buttonWidth: double.infinity,
                ),
                const SpaceWidget(spaceHeight: 32),
                Obx(
                  () => controller.isTimerRunning.value
                      ? const SizedBox.shrink() // Hide when timer is running
                      : Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const TextWidget(
                                text: AppStrings.didntGetCode,
                                fontColor: AppColors.greyDark,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                              const SpaceWidget(spaceWidth: 4),
                              TextButtonWidget(
                                onPressed: controller.resendOtp,
                                text: AppStrings.sendAgain,
                                textColor: AppColors.skyBlue,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
