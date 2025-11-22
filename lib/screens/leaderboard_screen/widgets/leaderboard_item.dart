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
  final String rank;
  final String name;
  final String amount;
  final String image;
  final bool isUp;
  final VoidCallback onPressed;
  final bool fromNetwork;
  final Color? backgrounColor;
  final String shoutTitle;

  const LeaderboardItem(
      {super.key,
      required this.rank,
      required this.name,
      required this.amount,
      required this.image,
      required this.isUp,
      required this.onPressed,
      required this.fromNetwork,
      required this.shoutTitle,
      this.backgrounColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        color: backgrounColor ?? AppColors.blue,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Rank and arrow indicator
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextWidget(
                  text: rank,
                  fontColor: AppColors.goldLight,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                Icon(
                  isUp ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: isUp ? AppColors.green : AppColors.redDark,
                  size: 20,
                ),
              ],
            ),
            
            const SizedBox(width: 12),

            // Profile image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ImageWidget(
                height: 44,
                width: 44,
                imagePath: image,
                fit: BoxFit.cover,
                fromNetwork: fromNetwork,
              ),
            ),

            const SizedBox(width: 12),

            // Name and shout title
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextWidget(
                          textAlignment: TextAlign.left,
                          text: name,
                          fontColor: AppColors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                     
                      GradientText(
                        text: amount,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  TextWidget(
                    text: shoutTitle,
                    fontColor: AppColors.white.withOpacity(0.8),
                    fontSize: 12,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
            // ButtonWidget(
            //   label: AppStrings.viewProfile,
            //   backgroundColor: AppColors.blueDark,
            //   textColor: AppColors.white,
            //   buttonWidth: 100,
            //   buttonHeight: 24,
            //   borderGradient: const LinearGradient(
            //     colors: [AppColors.gradientColorStart, AppColors.gradientColorEnd],
            //   ),
            //   buttonRadius: BorderRadius.circular(4),
            //   fontSize: 10,
            //   fontWeight: FontWeight.w600,
            // ),
          ],
        ),
             
      ),
         
     
    );
  }
}
