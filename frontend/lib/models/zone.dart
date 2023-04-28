import 'package:flame/game.dart';
import 'package:gatewayguardians/extensions/resource_map_extension.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/models/buildings/archery.dart';
import 'package:gatewayguardians/models/buildings/barracks.dart';
import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/models/buildings/cavalry.dart';
import 'package:gatewayguardians/models/buildings/copper_mine.dart';
import 'package:gatewayguardians/models/buildings/farm.dart';
import 'package:gatewayguardians/models/buildings/fortress.dart';
import 'package:gatewayguardians/models/buildings/gold_mine.dart';
import 'package:gatewayguardians/models/buildings/house.dart';
import 'package:gatewayguardians/models/buildings/iron_mine.dart';
import 'package:gatewayguardians/models/buildings/producer.dart';
import 'package:gatewayguardians/models/buildings/quarry.dart';
import 'package:gatewayguardians/models/buildings/warehouse.dart';
import 'package:gatewayguardians/models/buildings/woodcutter.dart';
import 'package:gatewayguardians/models/buildings/workshop.dart';
import 'package:gatewayguardians/models/colony.dart';
import 'package:gatewayguardians/models/construction.dart';
import 'package:gatewayguardians/models/patch.dart';
import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/types/patch_location.dart';

class Zone {
  final String id;
  final double x;
  final double y;
  final Colony colony;
  final List<Building> buildings;
  final List<Construction> constructions;
  final List<Patch> patches;
  final int maxBuildings;

  static const double CENTER_X = 184.5;
  static const double CENTER_Y = 160.5;
  static const double RADIUS = 157;

  Zone({
    required this.id,
    required this.x,
    required this.y,
    required this.colony,
    required this.buildings,
    required this.constructions,
    required this.patches,
    required this.maxBuildings,
  });

  void update(double dt) {
    for (final Construction construction in constructions) {
      construction.update(dt);
    }

    for (final Building building in buildings) {
      building.update(dt);
    }
  }

  bool contains(Vector2 position) {
    final double distance =
        Vector2(x + CENTER_X, y + CENTER_Y).distanceTo(position);

    return distance < RADIUS;
  }

  Building? getBuilding(BuildingType buildingType) {
    for (final Building building in buildings) {
      if (building.buildingType == buildingType) {
        return building;
      }
    }

    return null;
  }

  void onStartConstruction(Construction construction) {
    constructions.add(construction);
  }

  void onConstructionCompleted(Construction construction) {
    constructions.remove(construction);
    final BuildingType buildingType = construction.buildingType;
    final Building? building = getBuilding(buildingType);

    if (building != null) {
      building.level = construction.toLevel;
    } else {
      final ResourceMap cost = buildingType.cost(construction.toLevel);
      colony.inventory.removeResources(cost.resources());

      buildings.add(Building.create(
        colony: colony,
        zone: this,
        buildingType: buildingType,
        level: construction.toLevel,
        workers: 0,
        patch: buildingType.isProducer ? _patchForBuilding(buildingType) : null,
      ));
    }

    GameState.instance.notify();
  }

  Patch patchByLocation(PatchLocation location) {
    for (final Patch patch in patches) {
      if (patch.location == location) {
        return patch;
      }
    }

    throw Exception('Patch not found for $location');
  }

  bool _isPatchAvailable(Patch patch) {
    for (final Building building in buildings) {
      if ((building is Producer) && building.patch == patch) {
        return false;
      }
    }

    return true;
  }

  Patch _patchForBuilding(BuildingType buildingType) {
    for (final Patch patch in patches) {
      if ((patch.resourceType == buildingType.produces) &&
          _isPatchAvailable(patch)) {
        return patch;
      }
    }

    throw Exception('Available patch not found for $buildingType');
  }

  List<BuildingType> basic() {
    final List<BuildingType> result = [];

    if (!buildings.any((e) => e is House)) {
      result.add(BuildingType.house);
    }

    if (!buildings.any((e) => e is Warehouse)) {
      result.add(BuildingType.warehouse);
    }

    return result;
  }

  List<BuildingType> producers() {
    final List<BuildingType> result = [];

    if (!buildings.any((e) => e is Farm)) {
      result.add(BuildingType.farm);
    }

    if (!buildings.any((e) => e is Woodcutter)) {
      result.add(BuildingType.woodcutter);
    }

    if (!buildings.any((e) => e is Quarry)) {
      result.add(BuildingType.quarry);
    }

    if (!buildings.any((e) => e is CopperMine)) {
      result.add(BuildingType.copper_mine);
    }

    if (!buildings.any((e) => e is IronMine)) {
      result.add(BuildingType.iron_mine);
    }

    if (!buildings.any((e) => e is GoldMine)) {
      result.add(BuildingType.gold_mine);
    }

    return result;
  }

  List<BuildingType> military() {
    final List<BuildingType> result = [];

    if (!buildings.any((e) => e is Barracks)) {
      result.add(BuildingType.barracks);
    }

    if (!buildings.any((e) => e is Archery)) {
      result.add(BuildingType.archery);
    }

    if (!buildings.any((e) => e is Cavalry)) {
      result.add(BuildingType.cavalry);
    }

    if (!buildings.any((e) => e is Workshop)) {
      result.add(BuildingType.workshop);
    }

    if (!buildings.any((e) => e is Fortress)) {
      result.add(BuildingType.fortress);
    }

    return result;
  }
}
