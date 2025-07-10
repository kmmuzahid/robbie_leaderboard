import 'package:flutter/material.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/widgets/text_widget/text_widgets.dart';

class TitleTextWidget extends StatelessWidget {
  final String text;

  const TitleTextWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextWidget(
      text: text,
      fontColor: AppColors.greyLight,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    );
  }
}
