import 'package:flutter/material.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/widgets/text_widget/text_widgets.dart';

class DropdownButtonWidget extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const DropdownButtonWidget({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      elevation: 20,
      value: value,
      dropdownColor: AppColors.blue,
      iconEnabledColor: AppColors.white,
      icon: const Icon(Icons.keyboard_arrow_down_outlined),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: TextWidget(
            text: item,
            fontColor: AppColors.white,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.blue,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
