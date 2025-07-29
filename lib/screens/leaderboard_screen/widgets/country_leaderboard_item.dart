import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/gradient_text_widget/gradient_text_widget.dart';
import '../../../widgets/image_widget/image_widget.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';

class CountryLeaderboardItem extends StatelessWidget {
  const CountryLeaderboardItem(
      {super.key,
      required this.rank,
      required this.name,
      required this.amount,
      required this.image,
      required this.fromNetwork,
      this.backgrounColor});
  final int rank;
  final String name;
  final String amount;
  final String image;
  final bool fromNetwork;
  final Color? backgrounColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgrounColor,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              TextWidget(
                text: rank.toString().padLeft(2, '0'),
                fontColor: AppColors.goldLight,
                fontWeight: FontWeight.w500,
                fontSize: 12,
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
              SizedBox(
                width: ResponsiveUtils.width(180),
                child: TextWidget(
                  text: name.toUpperCase(),
                  fontColor: AppColors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlignment: TextAlign.start,
                ),
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
