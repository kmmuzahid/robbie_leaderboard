import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../constants/app_colors.dart';
import '../../../../../utils/app_size.dart';

class OtpInputFieldWidget extends StatelessWidget {
  const OtpInputFieldWidget({
    super.key,
    this.isLast = false,
    this.textInputAction = TextInputAction.next,
    this.fillColor,
    this.borderColor = AppColors.blue,
    this.controller,
    this.onFieldSubmitted,
  });

  final bool isLast;
  final TextInputAction? textInputAction;
  final Color? fillColor;
  final Color borderColor;
  final TextEditingController? controller;
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(ResponsiveUtils.width(5)),
      height: ResponsiveUtils.height(68),
      width: ResponsiveUtils.width(50),
      child: TextFormField(
        controller: controller,
        onFieldSubmitted: onFieldSubmitted,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "";
          }
          return null;
        },
        keyboardType: TextInputType.phone,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        textInputAction: textInputAction,
        onChanged: (value) {
          if (value.isNotEmpty && !isLast) {
            FocusManager.instance.primaryFocus?.nextFocus();
          }
        },
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        style: TextStyle(
          fontSize: ResponsiveUtils.width(20), // Increase font size
          fontWeight: FontWeight.w400,
          color: AppColors.blueLighter,
        ),
        decoration: InputDecoration(
          isDense: false,
          // Change this to false
          contentPadding: EdgeInsets.symmetric(
            vertical: ResponsiveUtils.height(18), // Add vertical padding
          ),
          filled: true,
          fillColor: fillColor ?? AppColors.blue,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.width(8)),
            borderSide: BorderSide(color: borderColor, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.width(8)),
            borderSide: BorderSide(color: borderColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.width(8)),
            borderSide: BorderSide(color: borderColor, width: 1),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.width(8)),
            borderSide: BorderSide(color: borderColor, width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.width(8)),
            borderSide: const BorderSide(color: AppColors.blue, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.width(8)),
            borderSide: const BorderSide(color: AppColors.blue, width: 1),
          ),
          errorStyle: const TextStyle(height: 0, fontSize: 0),
        ),
      ),
    );
  }
}
