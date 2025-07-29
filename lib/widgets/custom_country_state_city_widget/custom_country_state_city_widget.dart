import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:flutter/material.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/utils/app_size.dart';

class CustomCountryStateCityWidget extends StatelessWidget {
  const CustomCountryStateCityWidget(
      {super.key,
      required this.countryController,
      required this.stateController,
      required this.cityController});
  final TextEditingController countryController;
  final TextEditingController stateController;
  final TextEditingController cityController;
  @override
  Widget build(BuildContext context) {
    return CountryStateCityPicker(
      country: countryController,
      state: stateController,
      city: cityController,
      dialogColor: AppColors.white, // optional

      textFieldDecoration: InputDecoration(
        fillColor: AppColors.blue,
        filled: true,
        contentPadding: EdgeInsets.all(ResponsiveUtils.width(18)),
        hintStyle: TextStyle(
          color: AppColors.blueLighter,
          fontWeight: FontWeight.w400,
          fontSize: ResponsiveUtils.width(16),
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.all(13),
          child: Icon(
            Icons.arrow_drop_down, // use your custom arrow icon here
            size: ResponsiveUtils.width(18),
            color: Colors.white,
          ),
        ),
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
            color: Colors.red,
            width: ResponsiveUtils.width(1),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
            color: Colors.red,
            width: ResponsiveUtils.width(1),
          ),
        ),
      ),
    );
  }
}
