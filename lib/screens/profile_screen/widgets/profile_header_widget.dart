import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_image_path.dart';
import '../../../widgets/button_widget/button_widget.dart';
import '../../../widgets/gradient_text_widget/gradient_text_widget.dart';
import '../../../widgets/image_widget/image_widget.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String image;
  final String name;
  final String email;
  final String balance;
  final VoidCallback withdrawButtonOnPressed;
  final VoidCallback tweeterButtonOnPressed;
  final VoidCallback instagramButtonOnPressed;

  const ProfileHeaderWidget({
    super.key,
    required this.image,
    required this.name,
    required this.email,
    required this.balance,
    required this.withdrawButtonOnPressed,
    required this.tweeterButtonOnPressed,
    required this.instagramButtonOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Profile Picture
          ImageWidget(
            height: 60,
            width: 60,
            imagePath: image,
          ),
          const SpaceWidget(spaceHeight: 8),
          // Name
          TextWidget(
            text: name,
            fontColor: AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
          const SpaceWidget(spaceHeight: 2),
          // Email
          TextWidget(
            text: email,
            fontColor: AppColors.greyDarker,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          const SpaceWidget(spaceHeight: 16),
          // Balance and Withdraw Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.blueDarker,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextWidget(
                      text: "Total Balance",
                      fontColor: AppColors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                    const SpaceWidget(spaceHeight: 2),
                    GradientText(
                      text: balance,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ],
                ),
                ButtonWidget(
                  onPressed: withdrawButtonOnPressed,
                  label: "Withdraw",
                  buttonWidth: 102,
                  buttonHeight: 32,
                  textColor: AppColors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  buttonRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
          const SpaceWidget(spaceHeight: 16),
          // Social Media Icons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: tweeterButtonOnPressed,
                child: const ImageWidget(
                  height: 45,
                  width: 45,
                  imagePath: AppImagePath.tweeterImage,
                ),
              ),
              const SpaceWidget(spaceWidth: 16),
              InkWell(
                onTap: instagramButtonOnPressed,
                child: const ImageWidget(
                  height: 45,
                  width: 45,
                  imagePath: AppImagePath.instagramImage,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
