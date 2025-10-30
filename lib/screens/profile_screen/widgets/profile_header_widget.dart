import 'package:flutter/material.dart';
import 'package:the_leaderboard/utils/app_size.dart';
import 'package:the_leaderboard/widgets/shimmer_loading_widget/shimmer_loading.dart';

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
  // final VoidCallback discordButtonOnPressed;
  final VoidCallback? facebookButtonOnPressed;
  final VoidCallback? linkedinButtonOnPressed;
  final VoidCallback? youtubeButtonOnPressed;
  final bool isLoading;
  final bool fromNetwork;

  const ProfileHeaderWidget(
      {super.key,
      required this.image,
      required this.name,
      required this.email,
      required this.balance,
      required this.withdrawButtonOnPressed,
      required this.tweeterButtonOnPressed,
      required this.instagramButtonOnPressed,
      this.youtubeButtonOnPressed,
      this.facebookButtonOnPressed,
      this.linkedinButtonOnPressed,
      required this.isLoading,
      required this.fromNetwork});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.blueDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Profile Picture
          ImageWidget(
            height: 60,
            width: 60,
            imagePath: image,
            fromNetwork: fromNetwork,
          ),
          const SpaceWidget(spaceHeight: 8),
          // Name
          isLoading
              ? const ShimmerLoading(width: 200, height: 30)
              : TextWidget(
                  text: name,
                  fontColor: AppColors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
          const SpaceWidget(spaceHeight: 2),
          // Email
          isLoading
              ? const ShimmerLoading(width: 250, height: 20)
              : TextWidget(
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
              color: AppColors.blue,
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
                    isLoading
                        ? const ShimmerLoading(width: 100, height: 20)
                        : GradientText(
                            text: balance,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                  ],
                ),
                ButtonWidget(
                  onPressed: withdrawButtonOnPressed,
                  backgroundColor: AppColors.blueLighter,
                  label: "Withdraw",
                  buttonWidth: AppSize.width(value: 102),
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
              _iconButton(onPressed: tweeterButtonOnPressed, imagePath: AppImagePath.tweeterImage),
              SpaceWidget(spaceWidth: AppSize.width(value: 16)),
              _iconButton(
                  onPressed: instagramButtonOnPressed, imagePath: AppImagePath.instagramImage),
              const SpaceWidget(spaceWidth: 16),
              _iconButton(onPressed: youtubeButtonOnPressed, imagePath: AppImagePath.youtubeImage),
              SpaceWidget(spaceWidth: AppSize.width(value: 16)),
              _iconButton(
                  onPressed: facebookButtonOnPressed, imagePath: AppImagePath.facebookImage),
              const SpaceWidget(spaceWidth: 16),
              _iconButton(
                  onPressed: linkedinButtonOnPressed, imagePath: AppImagePath.linkedinImage),
            ],
          ),
          //
        ]));
  }

  Widget _iconButton({required VoidCallback? onPressed, required String imagePath}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 45,
        height: 45,
        padding: EdgeInsets.all(imagePath == AppImagePath.tweeterImage ? 2 : 0),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(5), color: AppColors.white),
        child: ImageWidget(
          height: 35,
          width: 35,
          fit: BoxFit.fill,
          imagePath: imagePath,
        ),
      ),
    );
  }
}
