import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/widgets/shimmer_loading_widget/shimmer_loading.dart';
import 'package:the_leaderboard/widgets/space_widget/space_widget.dart';
import 'package:the_leaderboard/widgets/text_widget/text_widgets.dart';

class PhoneNumberFieldWidget extends StatelessWidget {
  final String label;
  final bool isLoading;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function(bool) onValidated;

  const PhoneNumberFieldWidget({
    super.key,
    required this.label,
    required this.isLoading,
    this.controller,
    this.onChanged,
    required this.onValidated,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          text: label,
          fontColor: AppColors.greyLight,
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        const SpaceWidget(spaceHeight: 8),
        isLoading
            ? const ShimmerLoading(width: double.infinity, height: 55)
            : Container(
                decoration: BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InternationalPhoneNumberInput(
                  textFieldController: controller,
                  initialValue: PhoneNumber(isoCode: 'BD'),
                  onInputChanged: (value) {
                    if (onChanged != null) {
                      onChanged!(value.phoneNumber ?? '');
                    }
                  },
                  onInputValidated: (isValid) {
                    onValidated(isValid);
                  },
                  selectorConfig: const SelectorConfig(
                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    leadingPadding: 12,
                  ),
                  formatInput: true,
                  textStyle: const TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  selectorTextStyle: const TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                  ),
                  inputDecoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColors.blue,
                    hintText: "Enter phone number",
                    hintStyle: TextStyle(
                      color: AppColors.white.withOpacity(0.6),
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
