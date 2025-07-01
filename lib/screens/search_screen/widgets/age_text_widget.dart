import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../widgets/text_widget/text_widgets.dart';

class AgeTextWidget extends StatelessWidget {
  final String text;

  const AgeTextWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextWidget(
        text: text,
        fontColor: AppColors.white,
        fontWeight: FontWeight.w400,
        fontSize: 16,
      ),
    );
  }
}
