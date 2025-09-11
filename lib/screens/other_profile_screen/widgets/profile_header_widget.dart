import 'package:flutter/material.dart';
import 'package:the_leaderboard/constants/app_image_path.dart';
import 'package:the_leaderboard/utils/app_size.dart';

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
  final VoidCallback? youtubeButtonOnPressed;
  final bool socialButtonOn;
  final bool twitterUrlOn;
  final bool facebookUrlOn;
  final bool instagramUrlOn;
  final bool linkedinUrlOn;
  final bool discordUrlOn;
  final bool youtubeUrlOn;

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
      this.discordUrlOn = false,
      this.youtubeButtonOnPressed,
      this.youtubeUrlOn = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.blueDark,
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

          const SpaceWidget(spaceHeight: 16),
          if (socialButtonOn)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (twitterUrlOn) ...[
                  InkWell(
                    onTap: twitterButtonOnPressed,
                    child: const ImageWidget(
                      height: 45,
                      width: 45,
                      imagePath: AppImagePath.tweeterImage,
                    ),
                  ),
                  SpaceWidget(spaceWidth: AppSize.width(value: 16)),
                ],
                if (instagramUrlOn) ...[
                  InkWell(
                    onTap: instagramButtonOnPressed,
                    child: const ImageWidget(
                      height: 45,
                      width: 45,
                      imagePath: AppImagePath.instagramImage,
                    ),
                  ),
                  SpaceWidget(spaceWidth: AppSize.width(value: 16)),
                ],
                if (youtubeUrlOn) ...[
                  InkWell(
                    onTap: youtubeButtonOnPressed,
                    child: const ImageWidget(
                      height: 45,
                      width: 45,
                      imagePath: AppImagePath.youtubeImage,
                    ),
                  ),
                  SpaceWidget(spaceWidth: AppSize.width(value: 16)),
                ],
                if (facebookUrlOn) ...[
                  InkWell(
                    onTap: facebookButtonOnPressed,
                    child: const ImageWidget(
                      height: 45,
                      width: 45,
                      imagePath: AppImagePath.facebookImage,
                    ),
                  ),
                  SpaceWidget(spaceWidth: AppSize.width(value: 16)),
                ],
                if (linkedinUrlOn) ...[
                  InkWell(
                    onTap: linkedinButtonOnPressed,
                    child: const ImageWidget(
                      height: 45,
                      width: 45,
                      imagePath: AppImagePath.linkedinImage,
                    ),
                  ),
                ]
              ],
            ),
        ]));
    // Balance and Withdraw Button
  }
}
