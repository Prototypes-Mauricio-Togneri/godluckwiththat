import 'package:flutter/services.dart';
import 'package:tensionnode/json/json_match.dart';

class Loader {
  static Future<JsonMatch> match(String path) async {
    final String json = await rootBundle.loadString(path);

    return JsonMatch.fromString(json);
  }
}
