import 'package:flutter/services.dart';

class DateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String digits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    String year = '';
    String month = '';
    String day = '';

    // Year
    if (digits.length >= 4) {
      year = digits.substring(0, 4);
    } else if (digits.isNotEmpty) {
      year = digits.substring(0, digits.length);
    }

    // Month with validation
    if (digits.length >= 6) {
      month = digits.substring(4, 6);
      int m = int.parse(month);
      if (m < 1) m = 1;
      if (m > 12) m = 12;
      month = m.toString().padLeft(2, '0');
    } else if (digits.length > 4) {
      month = digits.substring(4, digits.length);
      int m = int.parse(month);
      if (m < 1) m = 1;
      if (m > 12) m = 12;
      month = m.toString().padLeft(month.length, '0');
    }

    // Day with validation
    if (digits.length >= 8) {
      day = digits.substring(6, 8);
      int d = int.parse(day);
      if (d < 1) d = 1;
      if (d > 31) d = 31;
      day = d.toString().padLeft(2, '0');
    } else if (digits.length > 6) {
      day = digits.substring(6, digits.length);
      int d = int.parse(day);
      if (d < 1) d = 1;
      if (d > 31) d = 31;
      day = d.toString().padLeft(day.length, '0');
    }

    // Combine to formatted text
    String newText = '';
    if (year.isNotEmpty) newText += year;
    if (month.isNotEmpty) newText += '-$month';
    if (day.isNotEmpty) newText += '-$day';
    if (newText.length > 10) newText = newText.substring(0, 10);

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
