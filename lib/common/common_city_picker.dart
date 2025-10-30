import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_country_state/city_screen.dart';
import 'package:flutter_country_state/flutter_country_state.dart';

import '../constants/app_colors.dart';

class CommonCityPicker extends StatelessWidget {
  const CommonCityPicker({Key? key, required this.onSelectCity}) : super(key: key);
  final Function(String city) onSelectCity;

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      onTap: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          isDismissible: false,
          builder: (context) => SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: ShowCityDialog(
              onSelectedCity: () {
                onSelectCity(Selected.city);
              },
            ),
          ),
        );
      },
      style: const TextStyle(color: AppColors.white),
      decoration: InputDecoration(
        suffixIcon: const Icon(Icons.arrow_drop_down, color: AppColors.white),
        hintText: 'Select City',
        hintStyle: const TextStyle(
          color: AppColors.greyDarker,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: AppColors.blue,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
