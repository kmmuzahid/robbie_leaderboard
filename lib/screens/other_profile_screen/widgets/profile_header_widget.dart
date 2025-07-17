import 'package:flutter/material.dart';
import 'package:the_leaderboard/constants/app_image_path.dart';

import '../../../constants/app_colors.dart';
import '../../../widgets/image_widget/image_widget.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String image;
  final String name;
  final String email;
  final bool fromNetwork;
  final VoidCallback? twitterButtonOnPressed;
  final VoidCallback? instagramButtonOnPressed;
  final VoidCallback? discordButtonOnPressed;
  final VoidCallback? facebookButtonOnPressed;
  final VoidCallback? linkedinButtonOnPressed;
  final bool socialButtonOn;
  final bool twitterUrlOn;
  final bool facebookUrlOn;
  final bool instagramUrlOn;
  final bool linkedinUrlOn;
  final bool discordUrlOn;

  const ProfileHeaderWidget(
      {super.key,
      required this.image,
      required this.name,
      required this.email,
      required this.fromNetwork,
      this.twitterButtonOnPressed,
      this.instagramButtonOnPressed,
      this.discordButtonOnPressed,
      this.facebookButtonOnPressed,
      this.linkedinButtonOnPressed,
      this.socialButtonOn = false,
      this.facebookUrlOn = false,
      this.instagramUrlOn = false,
      this.linkedinUrlOn = false,
      this.twitterUrlOn = false,
      this.discordUrlOn = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.blue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(children: [
          // Profile Picture
          ImageWidget(
            height: 60,
            width: 60,
            imagePath: image,
            fromNetwork: fromNetwork,
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
          if (socialButtonOn)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (twitterUrlOn)
                  InkWell(
                    onTap: twitterButtonOnPressed,
                    child: const ImageWidget(
                      height: 45,
                      width: 45,
                      imagePath: AppImagePath.tweeterImage,
                    ),
                  ),
                const SpaceWidget(spaceWidth: 16),
                if (instagramUrlOn)
                  InkWell(
                    onTap: instagramButtonOnPressed,
                    child: const ImageWidget(
                      height: 45,
                      width: 45,
                      imagePath: AppImagePath.instagramImage,
                    ),
                  ),
                const SpaceWidget(spaceWidth: 16),
                if (discordUrlOn)
                  InkWell(
                    onTap: discordButtonOnPressed,
                    child: const ImageWidget(
                      height: 45,
                      width: 45,
                      imagePath: AppImagePath.discordImage,
                    ),
                  ),
                const SpaceWidget(spaceWidth: 16),
                if (facebookUrlOn)
                  InkWell(
                    onTap: facebookButtonOnPressed,
                    child: const ImageWidget(
                      height: 45,
                      width: 45,
                      imagePath: AppImagePath.facebookImage,
                    ),
                  ),
                const SpaceWidget(spaceWidth: 16),
                if (linkedinUrlOn)
                  InkWell(
                    onTap: linkedinButtonOnPressed,
                    child: const ImageWidget(
                      height: 45,
                      width: 45,
                      imagePath: AppImagePath.linkedinImage,
                    ),
                  ),
              ],
            ),
        ]));
    // Balance and Withdraw Button
  }
}
