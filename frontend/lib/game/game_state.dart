import 'package:dafluta/dafluta.dart';
import 'package:tensionplanet/app/constants.dart';
import 'package:tensionplanet/dialog/buildings_dialog.dart';
import 'package:tensionplanet/game/game_component.dart';
import 'package:tensionplanet/json/json_building.dart';
import 'package:tensionplanet/json/json_match.dart';
import 'package:tensionplanet/json/json_patch.dart';
import 'package:tensionplanet/json/json_zone.dart';
import 'package:tensionplanet/models/buildings/building.dart';
import 'package:tensionplanet/models/construction.dart';
import 'package:tensionplanet/models/inventory.dart';
import 'package:tensionplanet/models/patch.dart';
import 'package:tensionplanet/models/research.dart';
import 'package:tensionplanet/models/zone.dart';

class GameState extends BaseState {
  num totalTimeElapsed = 0;
  num refreshTimeout = 0;
  bool loaded = false;

  final Research research = Research();
  final JsonMatch jsonMatch;
  final List<Zone> zones = [];
  late Zone currentZone;
  Building? selectedBuilding;

  static late GameState instance;

  GameState(this.jsonMatch);

  void load() {
    totalTimeElapsed = jsonMatch.totalTimeElapsed;

    for (final JsonZone jsonZone in jsonMatch.zones) {
      final Zone zone = Zone(
        inventory: Inventory.fromJson(jsonZone.inventory),
        freeVillagers: jsonZone.freeVillagers,
        buildings: [],
        constructions: [],
        patches: [],
      );

      for (final JsonPatch jsonPatch in jsonZone.patches) {
        zone.patches.add(Patch(
          resourceType: jsonPatch.type,
          location: jsonPatch.location,
        ));
      }

      for (final JsonBuilding jsonBuilding in jsonZone.buildings) {
        zone.buildings.add(Building.create(
          zone: zone,
          buildingType: jsonBuilding.type,
          level: jsonBuilding.level,
          workers: jsonBuilding.workers,
          patch: (jsonBuilding.location != null)
              ? zone.patchByLocation(jsonBuilding.location!)
              : null,
        ));
      }

      zones.add(zone);
    }

    currentZone = zones[0];

    GameComponent.instance.loadZone(currentZone);

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

    for (final Zone zone in zones) {
      zone.update(dt);
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
    construction.zone.constructions.add(construction);
  }

  void onConstructionCompleted(Construction construction) {
    construction.zone.onConstructionCompleted(construction);
    GameComponent.instance.loadZone(currentZone);
  }

  void onOpenMainMenu() {}

  void onOpenConstructionMenu() => BuildingsDialog.show(this);

  void onOpenResearchMenu() {}

  void onOpenMilitaryMenu() {}

  void onOpenMap() {}

  void onOpenReportsMenu() {}

  void onOpenZonesOverviewMenu() {}

  void onOpenExpeditionsMenu() {}
}
