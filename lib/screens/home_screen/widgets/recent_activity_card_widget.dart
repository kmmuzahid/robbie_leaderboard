import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../widgets/gradient_text_widget/gradient_text_widget.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';

class RecentActivityCardWidget extends StatelessWidget {
  final String action;
  final String value;
  final String time;

  const RecentActivityCardWidget({
    super.key,
    required this.action,
    required this.value,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GradientText(
                text: action,
                fontWeight: FontWeight.w400,
                fontSize: 16,
                hasGradientUnderline: true,
                colors: const [
                  AppColors.gradientColorStart,
                  AppColors.gradientColorEnd,
                ],
              ),
              const SpaceWidget(spaceWidth: 8),
              TextWidget(
                text: value,
                fontColor: AppColors.white,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ],
          ),
          const SpaceWidget(spaceHeight: 2),
          TextWidget(
            text: time,
            fontColor: AppColors.greyDark,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ],
      ),
    );
  }
}
