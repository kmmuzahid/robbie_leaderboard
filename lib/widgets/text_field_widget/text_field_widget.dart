import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:the_leaderboard/widgets/icon_button_widget/icon_button_widget.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_icon_path.dart';
import '../../utils/app_size.dart';

class TextFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final String? suffixIcon;
  final TextInputType? keyboardType;
  final int maxLines; // Add maxLines as a parameter
  final VoidCallback? onTapSuffix;
  final bool? read;
  final List<TextInputFormatter>? inputFormat;
  const TextFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.suffixIcon,
    this.keyboardType,
    this.read = false,
    this.maxLines = 1, // Default value is 1
    this.onTapSuffix,
    this.inputFormat,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late bool obscureText;

  @override
  void initState() {
    super.initState();
    // Initialize obscureText based on suffixIcon being a password toggle
    obscureText = widget.suffixIcon == AppIconPath.visibilityOnIcon;
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveUtils.initialize(context);
    return Card(
      elevation: 5,
      color: AppColors.blue,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.blue,
          borderRadius: BorderRadius.circular(24),
        ),
        child: TextFormField(
          readOnly: widget.read!,
          controller: widget.controller,
          validator: widget.validator,
          obscureText: obscureText,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          style: TextStyle(
            color: AppColors.blueLighter,
            fontWeight: FontWeight.w400,
            fontSize: ResponsiveUtils.width(16),
          ),
          inputFormatters: widget.inputFormat,
          decoration: InputDecoration(
            fillColor: AppColors.blue,
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: AppColors.blueLighter,
              fontWeight: FontWeight.w400,
              fontSize: ResponsiveUtils.width(16),
            ),
            suffixIcon: widget.suffixIcon != null
                ? widget.suffixIcon == AppIconPath.visibilityOnIcon ||
                        widget.suffixIcon == AppIconPath.visibilityOffIcon
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(13),
                          child: SvgPicture.asset(
                            obscureText
                                ? AppIconPath.visibilityOnIcon
                                : AppIconPath.visibilityOffIcon,
                            height: ResponsiveUtils.width(18),
                            width: ResponsiveUtils.width(18),
                          ),
                        ),
                      )
                    : IconButtonWidget(
                        onTap: widget.onTapSuffix!,
                        icon: AppIconPath.calenderIcon,
                        color: AppColors.white,
                        size: 20)
                : null,
            contentPadding: EdgeInsets.all(ResponsiveUtils.width(18)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(
                color: AppColors.blue,
                width: ResponsiveUtils.width(1),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(
                color: AppColors.blue,
                width: ResponsiveUtils.width(1),
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(
                color: AppColors.blue,
                width: ResponsiveUtils.width(1),
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(
                color: AppColors.blue,
                width: ResponsiveUtils.width(1),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
