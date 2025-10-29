import 'package:flutter/material.dart';
import 'package:the_leaderboard/common/leaderboard_animation.dart';
import 'package:the_leaderboard/constants/app_image_path.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/utils/app_size.dart';

import '../../../constants/app_colors.dart';
import '../../../widgets/gradient_text_widget/gradient_text_widget.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';

class TopRankedItem extends StatelessWidget {
  final String rankLabel;
  final String name;
  final String amount;
  final String image;
  final Color rankColor;
  final double avatarSize;
  final bool fromOnline;

  const TopRankedItem(
      {super.key,
      required this.rankLabel,
      required this.name,
      required this.amount,
      required this.image,
      required this.rankColor,
      required this.avatarSize,
      required this.fromOnline});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSize.width(value: 120),
      child: Column(
        children: [
          Container(
                decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: rankColor.withOpacity(0.7),
                    blurRadius: 1.0,
                    spreadRadius: 2.0,
                  ),
                  BoxShadow(
                    color: rankColor.withOpacity(0.4),
                    blurRadius: 2.0,
                    spreadRadius: 5.0,
                  ),
                ],
              ),
              child: AuraGlowWrapper(
                auraColor: rankColor,
                rankLabel: rankLabel,
                avatarSize: avatarSize,
                fromOnline: fromOnline,
                image: image,
              )),
            
          
          const SpaceWidget(spaceHeight: 8),
          TextWidget(
            text: name,
            overflow: TextOverflow.ellipsis,
            fontColor: AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          const SpaceWidget(spaceHeight: 4),
          GradientText(
            text: amount,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}
