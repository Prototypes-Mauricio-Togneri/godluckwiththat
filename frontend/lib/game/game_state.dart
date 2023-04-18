import 'package:dafluta/dafluta.dart';
import 'package:tensionplanet/json/json_match.dart';
import 'package:tensionplanet/models/inventory.dart';
import 'package:tensionplanet/models/research.dart';
import 'package:tensionplanet/models/resource.dart';
import 'package:tensionplanet/models/village.dart';
import 'package:tensionplanet/types/resource_type.dart';

class GameState extends BaseState {
  num totalTimeElapsed = 0;
  bool loaded = false;

  final Inventory inventory = Inventory.empty();
  final Research research = Research();
  final JsonMatch jsonMatch;
  final List<Village> villages = [];
  late Village currentVillage;

  GameState(this.jsonMatch) {
    totalTimeElapsed = jsonMatch.totalTimeElapsed;

    inventory.addResource(const Resource(ResourceType.food, 300));
    inventory.addResource(const Resource(ResourceType.wood, 100));
    inventory.addResource(const Resource(ResourceType.stone, 0));
    inventory.addResource(const Resource(ResourceType.copper, 0));
    inventory.addResource(const Resource(ResourceType.iron, 0));
    inventory.addResource(const Resource(ResourceType.gold, 0));
    inventory.addResource(const Resource(ResourceType.villager, 10));
  }

  void addVillages(List<Village> villages) {
    villages.addAll(villages);
    currentVillage = villages[0];
  }

  void setLoaded() {
    loaded = true;
    //notify();
  }

  void addResource(ResourceType resourceType) {
    inventory.addResource(Resource(resourceType, 1));
    notify();
  }

  void update(double dt) {
    totalTimeElapsed += dt;
    print(totalTimeElapsed);

    for (final Village village in villages) {
      village.update(dt);
    }
  }
}
