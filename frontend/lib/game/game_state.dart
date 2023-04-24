import 'package:dafluta/dafluta.dart';
import 'package:gatewayguardians/app/constants.dart';
import 'package:gatewayguardians/dialog/buildings_dialog.dart';
import 'package:gatewayguardians/game/game_component.dart';
import 'package:gatewayguardians/json/json_building.dart';
import 'package:gatewayguardians/json/json_match.dart';
import 'package:gatewayguardians/json/json_patch.dart';
import 'package:gatewayguardians/json/json_zone.dart';
import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/models/colony.dart';
import 'package:gatewayguardians/models/construction.dart';
import 'package:gatewayguardians/models/inventory.dart';
import 'package:gatewayguardians/models/patch.dart';
import 'package:gatewayguardians/models/research.dart';
import 'package:gatewayguardians/models/zone.dart';

class GameState extends BaseState {
  num totalTimeElapsed = 0;
  num refreshTimeout = 0;
  bool loaded = false;

  final Research research = Research();
  final JsonMatch jsonMatch;
  late Colony colony;
  late Zone currentZone;
  Building? selectedBuilding;

  static late GameState instance;

  GameState(this.jsonMatch);

  void load() {
    totalTimeElapsed = jsonMatch.totalTimeElapsed;

    colony = Colony(
      inventory: Inventory.fromJson(jsonMatch.colony.inventory),
      zones: [],
      freeVillagers: jsonMatch.colony.freeVillagers,
    );

    for (final JsonZone jsonZone in jsonMatch.colony.zones) {
      final Zone zone = Zone(
        id: jsonZone.id,
        colony: colony,
        buildings: [],
        constructions: [],
        patches: [],
        maxBuildings: jsonZone.maxBuildings,
      );

      for (final JsonPatch jsonPatch in jsonZone.patches) {
        zone.patches.add(Patch(
          resourceType: jsonPatch.type,
          location: jsonPatch.location,
        ));
      }

      for (final JsonBuilding jsonBuilding in jsonZone.buildings) {
        zone.buildings.add(Building.create(
          colony: colony,
          zone: zone,
          buildingType: jsonBuilding.type,
          level: jsonBuilding.level,
          workers: jsonBuilding.workers,
          patch: (jsonBuilding.location != null)
              ? zone.patchByLocation(jsonBuilding.location!)
              : null,
        ));
      }

      colony.zones.add(zone);
    }

    currentZone = colony.zones[0];

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

    colony.update(dt);
  }

  void onMapClicked() {
    selectedBuilding = null;
    notify();
  }

  void onBuildingSelected(Building building) {
    selectedBuilding = building;
    notify();
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
