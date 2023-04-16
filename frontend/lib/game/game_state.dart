import 'package:dafluta/dafluta.dart';
import 'package:tensionplanet/json/json_match.dart';
import 'package:tensionplanet/models/inventory.dart';
import 'package:tensionplanet/models/research.dart';
import 'package:tensionplanet/models/resource.dart';
import 'package:tensionplanet/types/resource_type.dart';

class GameState extends BaseState {
  num _totalTimeElapsed = 0;
  bool loaded = false;

  final Inventory inventory = Inventory.empty();
  final Research research = Research();
  final JsonMatch jsonMatch;

  GameState(this.jsonMatch) {
    _totalTimeElapsed = jsonMatch.totalTimeElapsed;

    inventory.addResource(const Resource(ResourceType.food, 600));
    inventory.addResource(const Resource(ResourceType.wood, 500));
    inventory.addResource(const Resource(ResourceType.stone, 400));
    inventory.addResource(const Resource(ResourceType.copper, 300));
    inventory.addResource(const Resource(ResourceType.iron, 200));
    inventory.addResource(const Resource(ResourceType.gold, 100));
  }

  void setLoaded() {
    loaded = true;
    //notify();
  }

  void update(double dt) {
    _totalTimeElapsed += dt;
    print(_totalTimeElapsed);
  }
}
