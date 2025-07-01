import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../../utils/app_size.dart';
import '../../../widgets/icon_widget/icon_widget.dart';

class CustomGButton {
  static GButton build({
    required String iconPath,
    required String label,
    required int index,
    required int selectedIndex,
    required Color selectedColor,
    required Color unselectedColor,
  }) {
    return GButton(
      icon: Icons.home, // Required but not visible
      leading: SizedBox(
        width: ResponsiveUtils.width(70),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconWidget(
              icon: iconPath,
              width: 24,
              height: 24,
              color: selectedIndex == index ? selectedColor : unselectedColor,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: selectedIndex == index ? selectedColor : unselectedColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
