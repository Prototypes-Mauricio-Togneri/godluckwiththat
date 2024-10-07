import 'package:godluckwiththat/extensions/duration_extension.dart';
import 'package:intl/intl.dart';

class Formatter {
  static String production(num amount) {
    final NumberFormat formatter = NumberFormat('#.##');

    return formatter.format(amount);
  }

  static String resource(num amount) {
    final NumberFormat formatter = NumberFormat('0');

    return formatter.format(amount);
  }

  static String days(num amount) {
    final NumberFormat formatter = NumberFormat('0');

    return formatter.format(amount);
  }

  static String years(num amount) {
    final NumberFormat formatter = NumberFormat('0');

    return formatter.format(amount);
  }

  static String time(num amount) => Duration(seconds: amount.toInt()).formatted;
}
