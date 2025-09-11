import 'package:intl/intl.dart';

class AppCommonFunction {
  static String formatNumber(dynamic value) {
    String formatted = NumberFormat("#,##0.00").format(value);
    return formatted;
  }
}
