import 'package:flutter/material.dart';
import 'package:the_leaderboard/constants/app_strings.dart';
import '../../../constants/app_colors.dart';
import '../../../widgets/text_widget/text_widgets.dart';

class LeaderboardDropdown extends StatelessWidget {
  final String value;
  final List<String> text;
  final ValueChanged<String?> onChanged;

  const LeaderboardDropdown({
    super.key,
    required this.value,
    required this.text,
    required this.onChanged,
  });

  // Helper to get display text
  String _getDisplayText(String item) {
    return switch (item) {
      'Leaderboard' => AppStrings.leaderboardText,
      'Event Leaderboard' => AppStrings.eventLeaderboard,
      'Creator Leaderboard' => AppStrings.creatorLeaderboard,
      _ => item,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40, // Fixed height for consistency
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(Icons.arrow_drop_down, color: AppColors.white),
          dropdownColor: AppColors.blueDark,
          borderRadius: BorderRadius.circular(12),

          // This removes default padding & centers text perfectly
          selectedItemBuilder: (context) {
            return text.map((item) {
              return Center(
                child: TextWidget(
                  text: _getDisplayText(item),
                  fontColor: AppColors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList();
          },

          // Popup menu items (normal spacing)
          items: text.map((item) {
            return DropdownMenuItem(
              value: item,
              child: TextWidget(
                text: _getDisplayText(item),
                fontColor: AppColors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            );
          }).toList(),

          onChanged: onChanged,
        ),
      ),
    );
  }
}
