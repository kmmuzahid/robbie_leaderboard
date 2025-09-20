import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../widgets/gradient_text_widget/gradient_text_widget.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';

class AffiliateStatusWidget extends StatelessWidget {
  final String totalRaisedValue;
  final String positionValue;
  final String profileViewValue;

  const AffiliateStatusWidget({
    super.key,
    required this.totalRaisedValue,
    required this.positionValue,
    required this.profileViewValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.blueDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextWidget(
            text: "Affiliate Status",
            fontColor: AppColors.white,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          const SpaceWidget(spaceHeight: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const TextWidget(
                        text: "Total Spent",
                        fontColor: AppColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      const SpaceWidget(spaceHeight: 4),
                      GradientText(
                        text: totalRaisedValue,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ],
                  ),
                ),
              ),
              const SpaceWidget(spaceWidth: 6),
              Expanded(
                flex: 1,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const TextWidget(
                        text: "Position",
                        fontColor: AppColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      const SpaceWidget(spaceHeight: 4),
                      GradientText(
                        text: positionValue,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ],
                  ),
                ),
              ),
              const SpaceWidget(spaceWidth: 6),
              Expanded(
                flex: 1,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const TextWidget(
                        text: "Profile View",
                        fontColor: AppColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      const SpaceWidget(spaceHeight: 4),
                      GradientText(
                        text: profileViewValue,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SpaceWidget(spaceHeight: 8),
          // Creator Code
        ],
      ),
    );
  }
}
