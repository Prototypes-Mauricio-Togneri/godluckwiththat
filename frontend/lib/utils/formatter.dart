import 'package:godluckwiththat/extensions/duration_extension.dart';
import 'package:intl/intl.dart';

class Formatter {
  static const String PRODUCTION_RATE_UNIT = '/s';

  static String production(num amount) {
    final NumberFormat formatter = NumberFormat('#.##');

    return formatter.format(amount);
  }

  static String resource(num amount) {
    final NumberFormat formatter = NumberFormat('0');

    return formatter.format(amount.floor());
  }

  static String time(num amount) => Duration(seconds: amount.toInt()).formatted;
}
