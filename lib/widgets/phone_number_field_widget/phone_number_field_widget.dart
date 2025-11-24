import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_icon_path.dart';
import '../../utils/app_size.dart';

class PhoneNumberFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(PhoneNumber) onInputChanged;
  final Function(bool)? onInputValidated;
  final bool readOnly;
  final PhoneNumber? initialValue;
  final double radius;

  const PhoneNumberFieldWidget({
    super.key,
    required this.controller,
    required this.onInputChanged,
    this.onInputValidated,
      this.initialValue,
    this.readOnly = false,
      this.radius = 24
  });

  @override
  State<PhoneNumberFieldWidget> createState() => _PhoneNumberFieldWidgetState();
}

class _PhoneNumberFieldWidgetState extends State<PhoneNumberFieldWidget> {
  PhoneNumber? _currentPhoneNumber;
  late int length;

  @override
  void initState() {
    length = getMaxPhoneLength(widget.initialValue?.isoCode ?? 'ZA');
    super.initState();
    _currentPhoneNumber = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveUtils.initialize(context);

    return Card(
      elevation: 5,
      color: AppColors.blue,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.radius)),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.blue,
          borderRadius: BorderRadius.circular(24),
        ),
        padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.width(12)),
        child: InternationalPhoneNumberInput(
          onInputChanged: (PhoneNumber number) {
            setState(() {
              _currentPhoneNumber = number;
              length = getMaxPhoneLength(number.isoCode ?? 'ZA');
            });
            widget.onInputChanged(number);
          },
          onSaved: (value) {
            widget.onInputChanged(value);
          },
          onSubmit: () {
            widget.onInputChanged(_currentPhoneNumber!);
          },
          onInputValidated: widget.onInputValidated,
          initialValue: widget.initialValue,
          textFieldController: widget.controller,
          maxLength: length - 1,
          // THIS IS THE KEY: Show only national number (no country code)
          formatInput: false,
          countries: null, // all countries
          selectorConfig: const SelectorConfig(
            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
            showFlags: true,
            useEmoji: false,
            setSelectorButtonAsPrefixIcon: true,
            leadingPadding: 12,
            trailingSpace: false,
          ),

          autoValidateMode: AutovalidateMode.disabled,
          ignoreBlank: true,
          isEnabled: !widget.readOnly,

          // Hide country code visually
          hintText: 'Enter phone number',
          textStyle: TextStyle(
            color: AppColors.blueLighter,
            fontWeight: FontWeight.w400,
            fontSize: ResponsiveUtils.width(16),
          ),
          selectorTextStyle: TextStyle(
            color: AppColors.blueLighter,
            fontWeight: FontWeight.w400,
            fontSize: ResponsiveUtils.width(16),
          ),

          inputDecoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Enter phone number',
            hintStyle: TextStyle(
              color: AppColors.blueLighter.withOpacity(0.6),
              fontWeight: FontWeight.w400,
              fontSize: ResponsiveUtils.width(16),
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: ResponsiveUtils.width(18),
              horizontal: ResponsiveUtils.width(8),
            ),
          ),

          // This is the magic line:
          // Prevents country code from appearing in the text field
          // while still using it internally for formatting & validation

          // Optional: customize how the selected country appears
          // (you can show flag + dial code separately if needed)
        ),
      ),
    );
  }

  /// Returns the correct maximum national number length for the selected country
  /// Based on official libphonenumber metadata (same as WhatsApp uses)
  int getMaxPhoneLength(String isoCode) {
    const Map<String, int> maxLengths = {
      // Special / rare
      '001': 15, // Global services (almost never used)

      // 13–14 digits – only some fixed lines
      'LY': 13, // Libya (rare)
      'SD': 13, // Sudan (rare)

      // 12 digits
      'RU': 12, // Russia/Kazakhstan fixed lines (mobile is 10)
      'KZ': 12,

      // 11 digits – very important for mobile
      'BD': 11, // Bangladesh ← critical
      'PK': 11, // Pakistan
      'BR': 11, // Brazil mobile (11 digits)
      'AR': 11, // Argentina
      'CO': 11, // Colombia
      'CL': 11, // Chile
      'PE': 11, // Peru

      // 10 digits – most common worldwide
      'US': 10, 'CA': 10, 'MX': 10, 'AU': 10, 'NZ': 10,
      'CN': 11, // China is 11
      'IN': 10, // India mobile = 10 digits
      'GB': 10, // UK = 10 digits (shown as 07XXXXXXXXX)
      'NG': 10, 'KE': 10, 'ZA': 10, 'EG': 10, 'PH': 10,
      'ID': 11, // Indonesia mobile = 10–12 → safe max 11
      'TH': 10, 'MY': 10, 'VN': 10,
      'JP': 10, 'KR': 11,

      // 9 digits – most of Europe & some Asia
      'FR': 9, // France
      'ES': 9, // Spain
      'NL': 9, // Netherlands
      'BE': 9, // Belgium
      'SE': 9, // Sweden
      'PL': 9, // Poland
      'PT': 9, // Portugal
      'GR': 10, // Greece
      'TR': 10, // Turkey

      // Germany & Italy – mobile is 10–11, fixed can be longer
      'DE': 11, // Germany: mobile 11, fixed up to 12 → safe max 11
      'IT': 11, // Italy: mobile 10, fixed up to 12 → safe max 11

      // 8 digits
      'SG': 8, // Singapore
      'HK': 8, // Hong Kong
      'NO': 8, // Norway
      'DK': 8, // Denmark
      'CH': 9, // Switzerland

      // Default fallback (very safe)
      'default': 15,
    };

    return maxLengths[isoCode] ?? maxLengths['default'] ?? 15;
  }
}
