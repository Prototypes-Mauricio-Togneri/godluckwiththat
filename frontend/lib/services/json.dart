import 'dart:convert';

class Json {
  static String encode(Object object) {
    try {
      const JsonEncoder encoder = JsonEncoder.withIndent('  ');

      return encoder.convert(object);
    } catch (e) {
      return e.toString();
    }
  }
}
