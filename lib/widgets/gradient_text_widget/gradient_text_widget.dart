import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class GradientText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final int maxLines;
  final TextAlign textAlign;
  final List<Color> colors;
  final TextOverflow overflow;
  final bool hasGradientUnderline;

  const GradientText({
    super.key,
    required this.text,
    required this.fontSize,
    required this.fontWeight,
    this.maxLines = 1,
    this.textAlign = TextAlign.center,
    this.colors = const [
      AppColors.gradientColorStart,
      AppColors.gradientColorEnd,
    ],
    this.overflow = TextOverflow.ellipsis,
    this.hasGradientUnderline = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: Colors.white, // Base color, overridden by gradient
              ),
              maxLines: maxLines,
              textAlign: textAlign,
              overflow: overflow,
            ),
          ),
          if (hasGradientUnderline)
            Container(
              height: 1, // Thickness of the underline
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: colors,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
