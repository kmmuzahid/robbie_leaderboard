import 'package:flutter/material.dart';
import 'package:the_leaderboard/widgets/icon_widget/icon_widget.dart';
import 'package:the_leaderboard/widgets/space_widget/space_widget.dart';

import '../../constants/app_colors.dart';
import '../../utils/app_size.dart';

class ButtonWidget extends StatelessWidget {
  final String label;
  final String? icon;
  final double? iconHeight;
  final double? iconWidth;
  final Color textColor;
  final double fontSize;
  final VoidCallback? onPressed;
  final double buttonHeight;
  final double buttonWidth;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry buttonRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final LinearGradient? borderGradient;
  final FontWeight? fontWeight;

  const ButtonWidget({
    super.key,
    required this.label,
    this.icon,
    this.iconHeight,
    this.iconWidth,
    this.textColor = AppColors.blueDark,
    this.fontSize = 18,
    this.onPressed,
    this.buttonHeight = 56,
    this.buttonWidth = 339,
    this.padding,
    this.buttonRadius = const BorderRadius.all(Radius.circular(12)),
    this.backgroundColor,
    this.borderColor,
    this.borderGradient,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveUtils.initialize(context);
    return Container(
      height: ResponsiveUtils.height(buttonHeight),
      width: ResponsiveUtils.width(buttonWidth),
      decoration: borderColor == null && borderGradient != null
          ? BoxDecoration(
              gradient: borderGradient,
              borderRadius: buttonRadius,
            )
          : null,
      padding: borderColor == null && borderGradient != null
          ? const EdgeInsets.all(1) // Border width for gradient
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor, // Use solid color if provided
          gradient: backgroundColor == null
              ? const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColors.gradientColorStart,
                    AppColors.gradientColorEnd,
                  ],
                )
              : null, // No gradient if backgroundColor is set
          borderRadius: buttonRadius,
          border: borderColor != null
              ? Border.all(color: borderColor!, width: 1)
              : null,
        ),
        child: ClipRRect(
          borderRadius: buttonRadius,
          child: MaterialButton(
            onPressed: onPressed,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            child: Padding(
              padding: padding ?? EdgeInsets.zero,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    IconWidget(
                      icon: icon!,
                      height: ResponsiveUtils.height(iconHeight ?? 24),
                      width: ResponsiveUtils.width(iconWidth ?? 24),
                    ),
                    const SpaceWidget(spaceWidth: 2),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      color: textColor,
                      fontSize: ResponsiveUtils.width(fontSize),
                      fontWeight: fontWeight ?? FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
