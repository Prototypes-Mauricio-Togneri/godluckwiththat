import 'package:dafluta/dafluta.dart';
import 'package:tensionplanet/game/game_component.dart';
import 'package:tensionplanet/json/json_building.dart';
import 'package:tensionplanet/json/json_match.dart';
import 'package:tensionplanet/json/json_patch.dart';
import 'package:tensionplanet/json/json_village.dart';
import 'package:tensionplanet/models/buildings/building.dart';
import 'package:tensionplanet/models/construction.dart';
import 'package:tensionplanet/models/inventory.dart';
import 'package:tensionplanet/models/patch.dart';
import 'package:tensionplanet/models/research.dart';
import 'package:tensionplanet/models/village.dart';

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

    for (final JsonVillage jsonVillage in jsonMatch.villages) {
      final Village village = Village(
        name: jsonVillage.name,
        inventory: Inventory.fromJson(jsonVillage.inventory),
        freeVillagers: jsonVillage.freeVillagers,
        buildings: [],
        constructions: [],
        patches: [],
      );

      for (final JsonPatch jsonPatch in jsonVillage.patches) {
        village.patches.add(Patch(
          resourceType: jsonPatch.type,
          location: jsonPatch.location,
        ));
      }

      for (final JsonBuilding jsonBuilding in jsonVillage.buildings) {
        village.buildings.add(Building.create(
          village: village,
          buildingType: jsonBuilding.type,
          level: jsonBuilding.level,
          patch: (jsonBuilding.location != null)
              ? village.patchByLocation(jsonBuilding.location!)
              : null,
        ));
      }

      villages.add(village);
    }

    currentVillage = villages[0];
  }

  void initialize(GameComponent value) {
    gameComponent = value;
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
