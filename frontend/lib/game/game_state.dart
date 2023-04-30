import 'package:dafluta/dafluta.dart';
import 'package:flame/components.dart';
import 'package:gatewayguardians/app/constants.dart';
import 'package:gatewayguardians/components/zone_component.dart';
import 'package:gatewayguardians/dialog/buildings_dialog.dart';
import 'package:gatewayguardians/extensions/component_extension.dart';
import 'package:gatewayguardians/extensions/resource_map_extension.dart';
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
import 'package:gatewayguardians/types/building_type.dart';

class GameState extends BaseState {
  num totalTimeElapsed = 0;
  num refreshTimeout = 0;
  bool loaded = false;

  final Research research = Research();
  final JsonMatch jsonMatch;
  final List<Zone> zones = [];
  late Colony colony;
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

    for (final JsonZone jsonZone in jsonMatch.zones) {
      final Zone zone = Zone(
        id: jsonZone.id,
        x: jsonZone.x,
        y: jsonZone.y,
        owner: jsonZone.owner,
        buildings: [],
        constructions: [],
        patches: [],
        maxBuildings: jsonZone.maxBuildings,
        status: jsonZone.status,
      );

      for (final JsonPatch jsonPatch in jsonZone.patches) {
        zone.patches.add(Patch(
          patchType: jsonPatch.type,
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
          location: jsonBuilding.location,
          patch: zone.patchByLocation(jsonBuilding.location!),
        ));
      }

      if (zone.isOwned) {
        colony.zones.add(zone);
      }

      zones.add(zone);
    }

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

  Zone _zoneById(String id) {
    for (final Zone zone in zones) {
      if (zone.id == id) {
        return zone;
      }
    }

    throw Exception('Zone with id $id not found');
  }

  void onMapClicked(Vector2 position) {
    for (final Zone zone in zones) {
      if (zone.contains(position)) {
        BuildingsDialog.show(
          state: this,
          zone: _zoneById(zone.id),
        );
        return;
      }
    }

    selectedBuilding = null;
    notify();
  }

  void onMouseMoved(Vector2 position) {
    final List<ZoneComponent> list = GameComponent.instance.layerSprites
        .getComponents(ZoneComponent)
        .map((e) => e as ZoneComponent)
        .toList();

    for (final ZoneComponent zone in list) {
      if (zone.zone.contains(position)) {
        zone.onHoverEnter();
      } else {
        zone.onHoverLeave();
      }
    }
  }

  void onBuildingSelected(Building building) {
    selectedBuilding = building;
    notify();
  }

  void onStartConstruction(Construction construction) {
    construction.zone.constructions.add(construction);
  }

  void onConstructionCompleted(Construction construction) {
    final Zone zone = construction.zone;
    zone.constructions.remove(construction);

    final BuildingType buildingType = construction.buildingType;
    final Building? building = zone.getBuilding(buildingType);

    if (building != null) {
      building.level = construction.toLevel;
    } else {
      final ResourceMap cost = buildingType.cost(construction.toLevel);
      colony.inventory.removeResources(cost.resources());

      zone.buildings.add(Building.create(
        colony: colony,
        zone: zone,
        buildingType: buildingType,
        level: construction.toLevel,
        workers: 0,
        location: construction.location,
        patch: buildingType.isProducer
            ? zone.patchForBuilding(buildingType)
            : null,
      ));
    }

    notify();
  }

  void onOpenMainMenu() {}

  void onOpenReportsMenu() {}

  void onOpenExpeditionsMenu() {}
}
