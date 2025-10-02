import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/button_widget/button_widget.dart';
import '../../../widgets/gradient_text_widget/gradient_text_widget.dart';
import '../../../widgets/image_widget/image_widget.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';

class LeaderboardItem extends StatelessWidget {
  final int rank;
  final String name;
  final String amount;
  final String image;
  final bool isUp;
  final VoidCallback onPressed;
  final bool fromNetwork;
  final Color? backgrounColor;

  const LeaderboardItem(
      {super.key,
      required this.rank,
      required this.name,
      required this.amount,
      required this.image,
      required this.isUp,
      required this.onPressed,
      required this.fromNetwork,
      this.backgrounColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgrounColor ?? AppColors.blue,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextWidget(
                    text: rank.toString().padLeft(2, '0'),
                    fontColor: AppColors.goldLight,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                  Icon(
                    isUp ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: isUp ? AppColors.green : AppColors.redDark,
                    size: 24,
                  ),
                ],
              ),
              const SpaceWidget(spaceWidth: 16),
              ImageWidget(
                height: 44,
                width: 44,
                imagePath: image,
                fit: BoxFit.cover,
                fromNetwork: fromNetwork,
              ),
              const SpaceWidget(spaceWidth: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: ResponsiveUtils.width(180),
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
                  const SpaceWidget(spaceHeight: 8),
                  ButtonWidget(
                    onPressed: onPressed,
                    label: AppStrings.viewProfile,
                    backgroundColor: AppColors.blueDark,
                    textColor: AppColors.white,
                    buttonWidth: 100,
                    buttonHeight: 24,
                    borderGradient: const LinearGradient(
                      colors: [
                        AppColors.gradientColorStart,
                        AppColors.gradientColorEnd
                      ],
                    ),
                    buttonRadius: BorderRadius.circular(4),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ],
          ),
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
