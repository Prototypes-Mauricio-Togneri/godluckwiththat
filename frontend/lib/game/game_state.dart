import 'package:dafluta/dafluta.dart';
import 'package:tensionplanet/app/constants.dart';
import 'package:tensionplanet/dialog/buildings_dialog.dart';
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

  final Research research = Research();
  final JsonMatch jsonMatch;
  final List<Village> villages = [];
  late Village currentVillage;
  Building? selectedBuilding;

  static late GameState instance;

  GameState(this.jsonMatch);

  void load() {
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
          workers: jsonBuilding.workers,
          patch: (jsonBuilding.location != null)
              ? village.patchByLocation(jsonBuilding.location!)
              : null,
        ));
      }

      villages.add(village);
    }

    currentVillage = villages[0];

    GameComponent.instance.loadVillage(currentVillage);

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

    if (refreshTimeout > Constants.RESOURCES_HUD_REFRESH_TIMEOUT) {
      refreshTimeout--;
      notify();
    }

    for (final Village village in villages) {
      village.update(dt);
    }
  }

  void onMapClicked() {
    selectedBuilding = null;
    notify();
  }

  void onBuildingSelected(Building building) {
    selectedBuilding = building;
    notify();
    //GameComponent.instance.showBuildingQuickMenu(building);
  }

  void onStartConstruction(Construction construction) {
    construction.village.constructions.add(construction);
  }

  void onConstructionCompleted(Construction construction) {
    construction.village.onConstructionCompleted(construction);
    GameComponent.instance.loadVillage(currentVillage);
  }

  void onOpenMainMenu() {}

  void onOpenConstructionMenu() => BuildingsDialog.show(this);

  void onOpenResearchMenu() {}

  void onOpenMilitaryMenu() {}

  void onOpenMap() {}

  void onOpenReportsMenu() {}

  void onOpenVillagesOverviewMenu() {}

  void onOpenExpeditionsMenu() {}
}
