import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'input_formatters/date_input_formatter.dart';
import 'input_formatters/phone_input_formater.dart';

enum ValidationType {
  validateRequired,
  validateEmail,
  validatePhone,
  validatePassword,
  validateDate,
  validateConfirmPassword,
  validateURL,
  validateNumber,
  validateCreditCard,
  validatePostalCode,
  validateMinLength,
  validateMaxLength,
  validateCustomPattern,
  validateDateRange,
  validateAlphaNumeric,
  validateUsername,
  validateTime,
  validateOTP,
  validateCurrency,
  validateIP,
  validateFullName,
  validateNID,
  notRequired,
}

class InputHelper {
  static List<TextInputFormatter> getInputFormatters(ValidationType type) {
    switch (type) {
      case ValidationType.validateDate:
        return [DateFormatter()];
      case ValidationType.validateEmail:
        return [FilteringTextInputFormatter.deny(RegExp(r'\s'))];
      case ValidationType.validatePhone:
        return [PhoneNumberFormatter()];
      case ValidationType.validatePassword:
        return [LengthLimitingTextInputFormatter(20)];
      case ValidationType.validateNumber:
        return [FilteringTextInputFormatter.digitsOnly];
      case ValidationType.validateCreditCard:
        return [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(16),
        ];
      case ValidationType.validatePostalCode:
        return [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(5),
        ];
      case ValidationType.validateCurrency:
        return [
          FilteringTextInputFormatter.digitsOnly,
          TextInputFormatter.withFunction((oldValue, newValue) {
            final text = newValue.text;
            if (text.contains(RegExp(r'^\d*\.?\d{0,2}'))) {
              return newValue;
            }
            return oldValue;
          }),
        ];
      case ValidationType.validateAlphaNumeric:
        return [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'))];
      case ValidationType.validateUsername:
        return [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_]'))];
      case ValidationType.validateOTP:
        return [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(6),
        ];
      case ValidationType.validateTime:
        return [FilteringTextInputFormatter.allow(RegExp(r'[0-9:]'))];
      case ValidationType.validateIP:
        return [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(15),
        ];
      case ValidationType.validateFullName:
        return [
          FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z'\- ]")),
        ];
      case ValidationType.validateNID:
        return [FilteringTextInputFormatter.digitsOnly];
      default:
        return [];
    }
  }

  static TextInputType getKeyboardType(ValidationType type) {
    switch (type) {
      case ValidationType.validateRequired:
        return TextInputType.text;
      case ValidationType.validateEmail:
        return TextInputType.emailAddress;
      case ValidationType.validatePhone:
        return TextInputType.phone;
      case ValidationType.validatePassword:
      case ValidationType.validateConfirmPassword:
        return TextInputType.visiblePassword;
      case ValidationType.validateDate:
      case ValidationType.validateDateRange:
      case ValidationType.validateTime:
        return TextInputType.datetime;
      case ValidationType.validateURL:
        return TextInputType.url;
      case ValidationType.validateNumber:
      case ValidationType.validateCreditCard:
      case ValidationType.validatePostalCode:
      case ValidationType.validateNID:
        return TextInputType.number;
      case ValidationType.validateCurrency:
        return const TextInputType.numberWithOptions(decimal: true);
      default:
        return TextInputType.text;
    }
  }

  // VALIDATION LOGIC
  static String? validate(
    ValidationType type,
    String? value, {
    int? minLength,
    int? maxLength,
    DateTime? startDate,
    DateTime? endDate,
    String? originalPassword,
  }) {
    switch (type) {
      case ValidationType.validateRequired:
        return _validateRequired(value);
      case ValidationType.validateEmail:
        return _validateEmail(value);
      case ValidationType.validatePhone:
        return _validatePhone(value);
      case ValidationType.validatePassword:
        return _validatePassword(value);
      case ValidationType.validateDate:
        return _validateDate(value);
      case ValidationType.validateConfirmPassword:
        return _validateConfirmPassword(value, originalPassword);
      case ValidationType.validateURL:
        return _validateURL(value);
      case ValidationType.validateNumber:
        return _validateNumber(value);
      case ValidationType.validateCreditCard:
        return _validateCreditCard(value);
      case ValidationType.validatePostalCode:
        return _validatePostalCode(value);
      case ValidationType.validateMinLength:
        return _validateMinLength(value, minLength!);
      case ValidationType.validateMaxLength:
        return _validateMaxLength(value, maxLength!);
      case ValidationType.validateCustomPattern:
        return _validateCustomPattern(value, '', '');
      case ValidationType.validateDateRange:
        return _validateDateRange(value, startDate!, endDate!);
      case ValidationType.validateAlphaNumeric:
        return _validateAlphaNumeric(value);
      case ValidationType.validateUsername:
        return _validateUsername(value);
      case ValidationType.validateTime:
        return _validateTime(value);
      case ValidationType.validateOTP:
        return _validateOTP(value);
      case ValidationType.validateCurrency:
        return _validateCurrency(value);
      case ValidationType.validateIP:
        return _validateIP(value);
      case ValidationType.validateFullName:
        return _validateFullName(value);
      case ValidationType.validateNID:
        return _validateNID(value);
      case ValidationType.notRequired:
        return null;
    }
  }

  static String? _validateNID(String? value) {
    final nidRegex = RegExp(r'^\d{12}$');
    if (value == null || value.isEmpty) {
      return "National ID is required.";
    }
    if (!nidRegex.hasMatch(value)) {
      return "Invalid National ID. Must be 12 digits.";
    }
    return null;
  }

  static String? _validateFullName(String? value) {
    final nameRegex = RegExp(r"^[a-zA-Z]+(?:[ '-][a-zA-Z]+)*$");
    if (value == null || value.isEmpty) {
      return "Full name is required.";
    }
    if (!nameRegex.hasMatch(value)) {
      return "Invalid full name format.";
    }
    return null;
  }

  static String? _validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return "This field is required.";
    }
    return null;
  }

  static String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required.";
    }
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return "Invalid email address.";
    }
    return null;
  }

  static String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return "Phone number is required.";
    }
    final phoneRegex = RegExp(r'^\d{3}-\d{3}-\d{4}$');
    if (!phoneRegex.hasMatch(value)) {
      return "Invalid phone number. Use format XXX-XXX-XXXX.";
    }
    return null;
  }

  static String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required.";
    }
    final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*\d).{8,}$');
    if (!passwordRegex.hasMatch(value)) {
      return "Password must contain at least 8 characters, one uppercase letter, and one number.";
    }
    return null;
  }

  static String? _validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return "Date is required.";
    }
    try {
      final dateFormat = DateFormat('yyyy-MM-dd');
      dateFormat.parseStrict(value);
    } catch (e) {
      return "Invalid date format. Use YYYY-MM-DD.";
    }
    return null;
  }

  static String? _validateConfirmPassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return "Please confirm your password.";
    }
    if (value != originalPassword) {
      return "Passwords do not match.";
    }
    return null;
  }

  static String? _validateURL(String? value) {
    if (value == null || value.isEmpty) {
      return "URL is required.";
    }
    final urlRegex = RegExp(
      r'^(https?:\/\/)?([a-z0-9-]+\.)+[a-z]{2,6}(\/[^\s]*)?$',
      caseSensitive: false,
    );
    if (!urlRegex.hasMatch(value)) {
      return "Invalid URL format.";
    }
    return null;
  }

  static String? _validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "Number is required.";
    }
    if (double.tryParse(value) == null) {
      return "Invalid number format.";
    }
    return null;
  }

  static String? _validateCreditCard(String? value) {
    if (value == null || value.isEmpty) {
      return "Credit card number is required.";
    }
    final cardRegex = RegExp(r'^\d{16}$');
    if (!cardRegex.hasMatch(value)) {
      return "Invalid credit card number. Must be 16 digits.";
    }
    return null;
  }

  static String? _validatePostalCode(String? value) {
    if (value == null || value.isEmpty) {
      return "Postal code is required.";
    }
    final postalCodeRegex = RegExp(r'^[0-9]{5}(?:-[0-9]{4})?$');
    if (!postalCodeRegex.hasMatch(value)) {
      return "Invalid postal code.";
    }
    return null;
  }

  static String? _validateMinLength(String? value, int minLength) {
    if (value == null || value.isEmpty) {
      return "This field is required.";
    }
    if (value.length < minLength) {
      return "Minimum length is $minLength characters.";
    }
    return null;
  }

  static String? _validateMaxLength(String? value, int maxLength) {
    if (value == null || value.isEmpty) {
      return "This field is required.";
    }
    if (value.length > maxLength) {
      return "Maximum length is $maxLength characters.";
    }
    return null;
  }

  static String? _validateCustomPattern(String? value, String pattern, String errorMessage) {
    if (value == null || value.isEmpty) {
      return "This field is required.";
    }
    final regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return errorMessage.isNotEmpty ? errorMessage : "Invalid format.";
    }
    return null;
  }

  static String? _validateDateRange(String? value, DateTime startDate, DateTime endDate) {
    if (value == null || value.isEmpty) {
      return "Date is required.";
    }
    try {
      final date = DateFormat('yyyy-MM-dd').parseStrict(value);
      if (date.isBefore(startDate) || date.isAfter(endDate)) {
        return "Date must be between ${DateFormat('yyyy-MM-dd').format(startDate)} and ${DateFormat('yyyy-MM-dd').format(endDate)}.";
      }
    } catch (e) {
      return "Invalid date format.";
    }
    return null;
  }

  static String? _validateAlphaNumeric(String? value) {
    if (value == null || value.isEmpty) {
      return "This field is required.";
    }
    final regex = RegExp(r'^[a-zA-Z0-9]+$');
    if (!regex.hasMatch(value)) {
      return "Only letters and numbers are allowed.";
    }
    return null;
  }

  static String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return "Username is required.";
    }
    final regex = RegExp(r'^[a-zA-Z0-9_]{3,15}$');
    if (!regex.hasMatch(value)) {
      return "Username must be 3–15 characters and can include letters, numbers, and underscores.";
    }
    return null;
  }

  static String? _validateTime(String? value) {
    if (value == null || value.isEmpty) {
      return "Time is required.";
    }
    final timeRegex = RegExp(r'^[0-2]?[0-9]:[0-5][0-9]$');
    if (!timeRegex.hasMatch(value)) {
      return "Invalid time format. Use HH:MM.";
    }
    return null;
  }

  static String? _validateOTP(String? value) {
    if (value == null || value.isEmpty) {
      return "OTP is required.";
    }
    final otpRegex = RegExp(r'^\d{6}$');
    if (!otpRegex.hasMatch(value)) {
      return "Invalid OTP. Must be 6 digits.";
    }
    return null;
  }

  static String? _validateCurrency(String? value) {
    if (value == null || value.isEmpty) {
      return "Amount is required.";
    }
    final currencyRegex = RegExp(r'^\d+(\.\d{1,2})?$');
    if (!currencyRegex.hasMatch(value)) {
      return "Invalid amount format.";
    }
    return null;
  }

  static String? _validateIP(String? value) {
    if (value == null || value.isEmpty) {
      return "IP address is required.";
    }
    final ipRegex = RegExp(r'^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$');
    if (!ipRegex.hasMatch(value)) {
      return "Invalid IP address format.";
    }
    return null;
  }
}
