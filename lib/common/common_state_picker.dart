import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_country_state/flutter_country_state.dart';
import 'package:flutter_country_state/state_screen.dart';
import 'package:path/path.dart';

import '../constants/app_colors.dart';

class CommonStatePicker extends StatelessWidget {
  const CommonStatePicker({Key? key, required this.onSelectState}) : super(key: key);
  final Function(String state) onSelectState;

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
            height: MediaQuery.of(context).size.height * 0.7,
            child: ShowStateDialog(
              onSelectedState: () {
                onSelectState(Selected.state);
              },
            ),
          ),
        );
      },
      style: const TextStyle(color: AppColors.white),
      decoration: InputDecoration(
        suffixIcon: const Icon(Icons.arrow_drop_down, color: AppColors.white),
        hintText: 'Select State',
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
