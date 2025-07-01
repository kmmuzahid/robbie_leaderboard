import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../widgets/text_widget/text_widgets.dart';

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
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
