import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/screens/change_password_screen/controller/change_password_controller.dart';

import '../../constants/app_colors.dart';
import '../../widgets/appbar_widget/appbar_widget.dart';
import '../../widgets/button_widget/button_widget.dart';
import '../../widgets/space_widget/space_widget.dart';
import '../../widgets/text_widget/text_widgets.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  // Controllers for text fields

  // Helper method to build a text field
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
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

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ChangePasswordController(),
      builder: (controller) => AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: AppColors.blueDark,
          appBar: const AppbarWidget(
            title: "Change Password",
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Old Password
                _buildTextField(
                  label: " Old Password",
                  controller: controller.oldPasswordController,
                ),
                const SpaceWidget(spaceHeight: 12),
                _buildTextField(
                  label: "New Password",
                  controller: controller.newPasswordController,
                ),
                const SpaceWidget(spaceHeight: 12),
                _buildTextField(
                  label: "Confirm new password",
                  controller: controller.confirmNewPasswordController,
                ),
                const SpaceWidget(spaceHeight: 24),
                // Save Changes Button
              ],
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
