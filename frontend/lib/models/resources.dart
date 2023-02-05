import 'package:tensionnode/json/json_resources.dart';
import 'package:tensionnode/types/resource_type.dart';

class Resources {
  num red = 0;
  num green = 0;
  num blue = 0;

  Resources({
    required this.red,
    required this.green,
    required this.blue,
  });

  factory Resources.empty() => Resources(red: 0, green: 0, blue: 0);

  void set({
    required num red,
    required num green,
    required num blue,
  }) {
    this.red = red;
    this.green = green;
    this.blue = blue;
  }

  void add(ResourceType type) {
    switch (type) {
      case ResourceType.red:
        red++;
        break;
      case ResourceType.green:
        green++;
        break;
      case ResourceType.blue:
        blue++;
        break;
    }
  }

  void remove(Resources resources) {
    red -= resources.red;
    green -= resources.green;
    blue -= resources.blue;
  }

  bool has(Resources resources) =>
      (red >= resources.red) &&
      (green >= resources.green) &&
      (blue >= resources.blue);

  JsonResources get json => JsonResources(red: red, green: green, blue: blue);
}
