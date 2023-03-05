import 'dart:convert';

class Json {
  static String encode(Object object) {
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');

    return encoder.convert(object);
  }
}
