import 'package:gatewayguardians/app/constants.dart';
import 'package:gatewayguardians/json/json_zone.dart';
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
import 'package:gatewayguardians/models/buildings/quarry.dart';
import 'package:gatewayguardians/models/buildings/warehouse.dart';
import 'package:gatewayguardians/models/buildings/woodcutter.dart';
import 'package:gatewayguardians/models/buildings/workshop.dart';
import 'package:gatewayguardians/models/construction.dart';
import 'package:gatewayguardians/models/patch.dart';
import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/types/zone_status.dart';

class Zone {
  final String id;
  final double x;
  final double y;
  final String owner;
  final List<Patch> patches;
  final List<Construction> constructions;
  final ZoneStatus status;

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

  void update(double dt) {
    for (final Construction construction in constructions) {
      construction.update(dt);
    }

    for (final Patch patch in patches) {
      patch.update(dt);
    }
  }

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

    if (!patches.any((e) => e.has(House))) {
      result.add(BuildingType.house);
    }

    if (!patches.any((e) => e.has(Warehouse))) {
      result.add(BuildingType.warehouse);
    }

    return result;
  }

  List<BuildingType> producers() {
    final List<BuildingType> result = [];

    if (!patches.any((e) => e.has(Farm))) {
      result.add(BuildingType.farm);
    }

    if (!patches.any((e) => e.has(Woodcutter))) {
      result.add(BuildingType.woodcutter);
    }

    if (!patches.any((e) => e.has(Quarry))) {
      result.add(BuildingType.quarry);
    }

    if (!patches.any((e) => e.has(CopperMine))) {
      result.add(BuildingType.copper_mine);
    }

    if (!patches.any((e) => e.has(IronMine))) {
      result.add(BuildingType.iron_mine);
    }

    if (!patches.any((e) => e.has(GoldMine))) {
      result.add(BuildingType.gold_mine);
    }

    return result;
  }

  List<BuildingType> military() {
    final List<BuildingType> result = [];

    if (!patches.any((e) => e.has(Barracks))) {
      result.add(BuildingType.barracks);
    }

    if (!patches.any((e) => e.has(Archery))) {
      result.add(BuildingType.archery);
    }

    if (!patches.any((e) => e.has(Cavalry))) {
      result.add(BuildingType.cavalry);
    }

    if (!patches.any((e) => e.has(Workshop))) {
      result.add(BuildingType.workshop);
    }

    if (!patches.any((e) => e.has(Fortress))) {
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
