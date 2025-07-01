import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../widgets/text_widget/text_widgets.dart';

class FAQCard extends StatelessWidget {
  final String questionText;
  final String answerText;

  const FAQCard({
    super.key,
    required this.questionText,
    required this.answerText,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: AppColors.blue,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        backgroundColor: AppColors.blue,
        collapsedBackgroundColor: AppColors.blue,
        expansionAnimationStyle: const AnimationStyle(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        iconColor: AppColors.white,
        showTrailingIcon: true,
        collapsedIconColor: AppColors.white,
        title: TextWidget(
          text: questionText,
          fontColor: AppColors.white,
          fontWeight: FontWeight.w500,
          fontSize: 14,
          textAlignment: TextAlign.start,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextWidget(
              text: answerText,
              fontColor: AppColors.white,
              fontWeight: FontWeight.w400,
              fontSize: 14,
              textAlignment: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}
