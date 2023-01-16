import 'package:tensionnode/types/resource_type.dart';

class GameState {
  int red = 0;
  int green = 0;
  int blue = 0;

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
