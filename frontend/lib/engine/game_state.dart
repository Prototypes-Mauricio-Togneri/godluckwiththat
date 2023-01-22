import 'package:tensionnode/json/json_match.dart';
import 'package:tensionnode/types/resource_type.dart';

class GameState {
  int version = 0;
  String id = '';
  int red = 0;
  int green = 0;
  int blue = 0;

  void load(JsonMatch jsonMatch) {
    version = jsonMatch.version;
    id = jsonMatch.id;
    red = jsonMatch.resources.red;
    green = jsonMatch.resources.green;
    blue = jsonMatch.resources.blue;
  }

  void addResource(ResourceType type) {
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
}
