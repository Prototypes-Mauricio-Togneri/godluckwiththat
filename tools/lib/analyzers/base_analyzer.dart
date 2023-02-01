import 'package:tension_node_tools/json/json_analytic_event.dart';

class BaseAnalyzer {
  final String file;

  const BaseAnalyzer(this.file);

  List<T> events<T>(T Function(JsonAnalyticEvent) function) {
    final List<JsonAnalyticEvent> list = JsonAnalyticEvent.fromFile('stats/$file.json');
    final List<T> result = [];

    for (final JsonAnalyticEvent json in list) {
      result.add(function(json));
    }

    return result;
  }
}
