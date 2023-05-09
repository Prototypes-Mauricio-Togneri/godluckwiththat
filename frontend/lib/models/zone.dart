import 'package:gatewayguardians/app/constants.dart';
import 'package:gatewayguardians/extensions/resource_map_extension.dart';
import 'package:gatewayguardians/json/json_zone.dart';
import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/models/construction.dart';
import 'package:gatewayguardians/models/patch.dart';
import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/types/resource_type.dart';
import 'package:gatewayguardians/types/zone_status.dart';

class Zone {
  final String id;
  final double x;
  final double y;
  String owner;
  final List<Patch> patches;
  final List<Construction> constructions;
  ZoneStatus status;

  Zone({
    required this.id,
    required this.x,
    required this.y,
    required this.owner,
    required this.patches,
    required this.constructions,
    required this.status,
  });

  bool get isOwned => owner == Constants.PLAYER_OWNER;

  bool get isNeutral => owner.isEmpty;

  void update(double dt) {
    for (final Construction construction in constructions) {
      construction.update(dt);
    }

    for (final Patch patch in patches) {
      patch.update(dt);
    }
  }

  void explore() {
    status = ZoneStatus.explored;
  }

  void conquer() {
    owner = Constants.PLAYER_OWNER;
  }

  ResourceMap explorationCost() => {
        ResourceType.food: 100,
      };

  ResourceMap conquerCost() => {
        ResourceType.food: 100,
      };

  void onStartConstruction(Construction construction) {
    constructions.add(construction);
  }

  void onDestroyBuilding(Building building) {
    for (final Patch patch in patches) {
      if ((patch.hasBuilding) && (patch.building == building)) {
        patch.destroyBuilding();
        break;
      }
    }
  }

  List<BuildingType> basic() {
    final List<BuildingType> result = [];

    if (!patches.any((e) => e.has(BuildingType.house))) {
      result.add(BuildingType.house);
    }

    if (!patches.any((e) => e.has(BuildingType.warehouse))) {
      result.add(BuildingType.warehouse);
    }

    return result;
  }

  List<BuildingType> producers() {
    final List<BuildingType> result = [];

    if (!patches.any((e) => e.has(BuildingType.farm))) {
      result.add(BuildingType.farm);
    }

    if (!patches.any((e) => e.has(BuildingType.woodcutter))) {
      result.add(BuildingType.woodcutter);
    }

    if (!patches.any((e) => e.has(BuildingType.quarry))) {
      result.add(BuildingType.quarry);
    }

    if (!patches.any((e) => e.has(BuildingType.copper_mine))) {
      result.add(BuildingType.copper_mine);
    }

    if (!patches.any((e) => e.has(BuildingType.iron_mine))) {
      result.add(BuildingType.iron_mine);
    }

    if (!patches.any((e) => e.has(BuildingType.gold_mine))) {
      result.add(BuildingType.gold_mine);
    }

    return result;
  }

  List<BuildingType> military() {
    final List<BuildingType> result = [];

    if (!patches.any((e) => e.has(BuildingType.barracks))) {
      result.add(BuildingType.barracks);
    }

    if (!patches.any((e) => e.has(BuildingType.archery))) {
      result.add(BuildingType.archery);
    }

    if (!patches.any((e) => e.has(BuildingType.cavalry))) {
      result.add(BuildingType.cavalry);
    }

    if (!patches.any((e) => e.has(BuildingType.workshop))) {
      result.add(BuildingType.workshop);
    }

    if (!patches.any((e) => e.has(BuildingType.fortress))) {
      result.add(BuildingType.fortress);
    }

    return result;
  }

  JsonZone get json => JsonZone(
        id: id,
        x: x,
        y: y,
        owner: owner,
        status: status,
        patches: patches.map((p) => p.json).toList(),
      );
}
