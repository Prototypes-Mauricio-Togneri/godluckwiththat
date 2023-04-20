import 'package:dafluta/dafluta.dart';
import 'package:tensionplanet/game/game_component.dart';
import 'package:tensionplanet/json/json_match.dart';
import 'package:tensionplanet/models/buildings/building.dart';
import 'package:tensionplanet/models/construction.dart';
import 'package:tensionplanet/models/inventory.dart';
import 'package:tensionplanet/models/research.dart';
import 'package:tensionplanet/models/resource.dart';
import 'package:tensionplanet/models/village.dart';
import 'package:tensionplanet/types/building_type.dart';
import 'package:tensionplanet/types/resource_type.dart';

class GameState extends BaseState {
  num totalTimeElapsed = 0;
  num refreshTimeout = 0;
  bool loaded = false;

  late final GameComponent gameComponent;
  final Research research = Research();
  final JsonMatch jsonMatch;
  final List<Village> villages = [];
  late Village currentVillage;

  GameState(this.jsonMatch) {
    totalTimeElapsed = jsonMatch.totalTimeElapsed;
  }

  void initialize(GameComponent value) {
    gameComponent = value;

    final Inventory inventory = Inventory.empty();
    inventory.addResource(const Resource(ResourceType.food, 300));
    inventory.addResource(const Resource(ResourceType.wood, 100));
    inventory.addResource(const Resource(ResourceType.stone, 0));
    inventory.addResource(const Resource(ResourceType.copper, 0));
    inventory.addResource(const Resource(ResourceType.iron, 0));
    inventory.addResource(const Resource(ResourceType.gold, 0));
    inventory.addResource(const Resource(ResourceType.villager, 10));

    final Village village = Village(
      name: 'Home village',
      inventory: inventory,
      buildings: [],
      freeVillagers: 10,
      constructions: [],
    );
    village.addBuildings([
      Building.create(
        village: village,
        buildingType: BuildingType.headquarters,
        level: 1,
      ),
    ]);

    villages.addAll([village]);
    currentVillage = village;

    gameComponent.loadVillage(currentVillage);

    Delayed.post(() {
      loaded = true;
      notify();
    });
  }

  void update(double dt) {
    totalTimeElapsed += dt;
    refreshTimeout += dt;

    if (totalTimeElapsed == 0) {
      print(totalTimeElapsed);
    }

    if (refreshTimeout > 1) {
      refreshTimeout--;
      notify();
    }

    for (final Village village in villages) {
      village.update(dt);
    }
  }

  void onBuildingSelected(Building building) {}

  void onStartConstruction(Construction construction) {
    construction.village.constructions.add(construction);
  }

  void onConstructionCompleted(Construction construction) {
    construction.village.onConstructionCompleted(construction);
    gameComponent.loadVillage(currentVillage);
  }
}
