import 'package:flame/game.dart';
import 'package:gatewayguardians/app/constants.dart';
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
import 'package:gatewayguardians/models/construction.dart';
import 'package:gatewayguardians/models/patch.dart';
import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/types/zone_location.dart';
import 'package:gatewayguardians/types/zone_status.dart';

class Zone {
  final String id;
  final double x;
  final double y;
  final String owner;
  final List<Building> buildings;
  final List<Construction> constructions;
  final List<Patch> patches;
  final int maxBuildings;
  final ZoneStatus status;

  static const double RADIUS = 160;

  Zone({
    required this.id,
    required this.x,
    required this.y,
    required this.owner,
    required this.buildings,
    required this.constructions,
    required this.patches,
    required this.maxBuildings,
    required this.status,
  });

  bool get isOwned => owner == Constants.ZONE_OWNER_PLAYER;

  void update(double dt) {
    for (final Construction construction in constructions) {
      construction.update(dt);
    }

    for (final Building building in buildings) {
      building.update(dt);
    }
  }

  bool contains(Vector2 position) {
    final double distance = Vector2(x, y).distanceTo(position);

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

  Patch patchByLocation(ZoneLocation location) {
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

  Patch patchForBuilding(BuildingType buildingType) {
    for (final Patch patch in patches) {
      if ((patch.patchType.resourceType == buildingType.produces) &&
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
