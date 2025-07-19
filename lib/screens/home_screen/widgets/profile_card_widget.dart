import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_icon_path.dart';
import '../../../constants/app_strings.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/button_widget/button_widget.dart';
import '../../../widgets/icon_widget/icon_widget.dart';
import '../../../widgets/image_widget/image_widget.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';

class ProfileCardWidget extends StatelessWidget {
  final String profileImagePath;
  final String name;
  final int rankNumber;
  final String totalRaisedAmount;
  final String totalSpentAmount;
  final VoidCallback onViewProfilePressed;
  final VoidCallback onJoinLeaderboardPressed;
  final VoidCallback onSharePressed;
  final bool fromNetwork;

  const ProfileCardWidget(
      {super.key,
      required this.profileImagePath,
      required this.name,
      required this.rankNumber,
      required this.totalRaisedAmount,
      required this.totalSpentAmount,
      required this.onViewProfilePressed,
      required this.onJoinLeaderboardPressed,
      required this.onSharePressed,
      required this.fromNetwork});

  @override
  Widget build(BuildContext context) {
    ResponsiveUtils.initialize(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ImageWidget(
                    height: 50,
                    width: 50,
                    imagePath: profileImagePath,
                    fromNetwork: fromNetwork,
                  ),
                  const SpaceWidget(spaceWidth: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: ResponsiveUtils.width(170),
                        child: TextWidget(
                          text: name,
                          fontColor: AppColors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlignment: TextAlign.start,
                        ),
                      ),
                      const SpaceWidget(spaceHeight: 4),
                      ButtonWidget(
                        onPressed: onViewProfilePressed,
                        label: AppStrings.viewProfile,
                        backgroundColor: AppColors.blue,
                        textColor: AppColors.blueLighter,
                        buttonWidth: 100,
                        buttonHeight: 24,
                        //borderColor: AppColors.blueLighter,
                        borderGradient: const LinearGradient(
                          colors: [
                            AppColors.gradientColorStart,
                            AppColors.gradientColorEnd
                          ],
                        ),
                        buttonRadius: BorderRadius.circular(4),
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ],
              ),
              TextWidget(
                text: "${AppStrings.rank} #$rankNumber",
                fontColor: AppColors.white,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ],
          ),
          const SpaceWidget(spaceHeight: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  IconWidget(
                    icon: AppIconPath.totalRaisedIcon,
                    width: 18,
                    height: 18,
                  ),
                  SpaceWidget(spaceWidth: 8),
                  TextWidget(
                    text: AppStrings.totalRaised,
                    fontColor: AppColors.blueLighter,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ],
              ),
              TextWidget(
                text: totalRaisedAmount,
                fontColor: AppColors.blueLighter,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ],
          ),
          const SpaceWidget(spaceHeight: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  IconWidget(
                    icon: AppIconPath.totalSpentIcon,
                    width: 18,
                    height: 18,
                  ),
                  SpaceWidget(spaceWidth: 8),
                  TextWidget(
                    text: AppStrings.totalSpent,
                    fontColor: AppColors.blueLighter,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ],
              ),
              TextWidget(
                text: totalSpentAmount,
                fontColor: AppColors.blueLighter,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ],
          ),
          const SpaceWidget(spaceHeight: 12),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: ButtonWidget(
                  onPressed: onJoinLeaderboardPressed,
                  label: AppStrings.joinLeaderboard,
                  buttonWidth: AppSize.width(value: 192),
                  buttonHeight: 36,
                  buttonRadius: BorderRadius.circular(8),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SpaceWidget(spaceWidth: 8),
              Expanded(
                flex: 1,
                child: ButtonWidget(
                  onPressed: onSharePressed,
                  label: AppStrings.share,
                  buttonWidth: AppSize.width(value: 192),
                  buttonHeight: 36,
                  buttonRadius: BorderRadius.circular(8),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  icon: AppIconPath.shareIcon,
                  iconWidth: 16,
                  iconHeight: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
