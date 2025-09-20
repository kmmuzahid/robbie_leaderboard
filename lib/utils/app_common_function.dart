import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_leaderboard/constants/app_colors.dart';

class AppCommonFunction {
  static String formatNumber(dynamic value) {
    String formatted = NumberFormat("#,##0.00").format(value);
    return formatted;
  }

  static void showSnackbar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
      ),
      backgroundColor: AppColors.white,
    ));
  }
}
