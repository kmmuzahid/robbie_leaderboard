import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_icon_path.dart';
import '../../../constants/app_strings.dart';
import '../../../widgets/auth_appbar_widget/auth_appbar_widget.dart';
import '../../../widgets/button_widget/button_widget.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_field_widget/text_field_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';
import 'controller/create_new_password_screen_controller.dart';

class CreateNewPasswordScreen extends StatelessWidget {  
  const CreateNewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CreateNewPasswordScreenController(),
      builder: (controller) => AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: AppColors.blueDark,
          appBar: const AuthAppbarWidget(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpaceWidget(spaceHeight: 82),
                const Center(
                  child: TextWidget(
                    text: AppStrings.createNewPassword,
                    fontColor: AppColors.blueLighter,
                    fontWeight: FontWeight.w600,
                    fontSize: 32,
                  ),
                ),
                const SpaceWidget(spaceHeight: 12),
                const Center(
                  child: TextWidget(
                    text: AppStrings.newPasswordDescription,
                    fontColor: AppColors.blueLighter,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
                const SpaceWidget(spaceHeight: 32),
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
                const SpaceWidget(spaceHeight: 24),
                ButtonWidget(
                  onPressed: controller.createNewPassword,
                  label: AppStrings.submit,
                  buttonWidth: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
