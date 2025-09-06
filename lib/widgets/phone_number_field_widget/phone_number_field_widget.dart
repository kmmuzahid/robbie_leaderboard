import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_icon_path.dart';
import '../../utils/app_size.dart';

class PhoneNumberFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(PhoneNumber) onInputChanged;
  final Function(bool)? onInputValidated;
  final bool readOnly;
  final PhoneNumber? initialValue;

  const PhoneNumberFieldWidget({
    super.key,
    required this.controller,
    required this.onInputChanged,
    this.onInputValidated,
    required this.initialValue,
    this.readOnly = false,
  });

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
        padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.width(12)),
        child: InternationalPhoneNumberInput(
          onInputChanged: onInputChanged,
          initialValue: initialValue,
          onInputValidated: onInputValidated,
          textFieldController: controller,
          selectorConfig: const SelectorConfig(
            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
          ),
          ignoreBlank: true,
          autoValidateMode: AutovalidateMode.disabled,
          inputDecoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Enter phone number',
            hintStyle: TextStyle(
              color: AppColors.blueLighter,
              fontWeight: FontWeight.w400,
              fontSize: ResponsiveUtils.width(16),
            ),
            contentPadding: EdgeInsets.all(ResponsiveUtils.width(18)),
          ),
          textStyle: TextStyle(
            color: AppColors.blueLighter,
            fontWeight: FontWeight.w400,
            fontSize: ResponsiveUtils.width(16),
          ),
          inputBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide(
              color: AppColors.blue,
              width: ResponsiveUtils.width(1),
            ),
          ),
          selectorTextStyle: TextStyle(
            color: AppColors.blueLighter,
            fontWeight: FontWeight.w400,
            fontSize: ResponsiveUtils.width(16),
          ),
          isEnabled: !readOnly,
        ),
      ),
    );
  }
}
