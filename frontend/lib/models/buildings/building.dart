import 'package:flutter/widgets.dart';
import 'package:tensionplanet/components/building_sprite.dart';
import 'package:tensionplanet/game/game_state.dart';
import 'package:tensionplanet/models/buildings/archery.dart';
import 'package:tensionplanet/models/buildings/barracks.dart';
import 'package:tensionplanet/models/buildings/cavalry.dart';
import 'package:tensionplanet/models/buildings/copper_mine.dart';
import 'package:tensionplanet/models/buildings/farm.dart';
import 'package:tensionplanet/models/buildings/fortress.dart';
import 'package:tensionplanet/models/buildings/gold_mine.dart';
import 'package:tensionplanet/models/buildings/headquarters.dart';
import 'package:tensionplanet/models/buildings/house.dart';
import 'package:tensionplanet/models/buildings/iron_mine.dart';
import 'package:tensionplanet/models/buildings/quarry.dart';
import 'package:tensionplanet/models/buildings/warehouse.dart';
import 'package:tensionplanet/models/buildings/woodcutter.dart';
import 'package:tensionplanet/models/buildings/workshop.dart';
import 'package:tensionplanet/models/patch.dart';
import 'package:tensionplanet/models/zone.dart';
import 'package:tensionplanet/types/building_type.dart';

class Building {
  final Zone zone;
  final BuildingType buildingType;
  final Offset offset;
  int level;
  int workers;

  Building({
    required this.zone,
    required this.buildingType,
    required this.offset,
    required this.level,
    required this.workers,
  });

  bool get hasWorkers => workers > 0;

  BuildingSprite get sprite => BuildingSprite(this);

  void update(double dt) {}

  void onUpgrade() {
    level++;
    GameState.instance.notify();
  }

  void onAddVillager() {
    if (zone.hasFreeVillagers) {
      workers += zone.removeFreeVillager();
      GameState.instance.notify();
    }
  }

  void onRemoveVillager() {
    if (hasWorkers) {
      workers -= zone.addFreeVillager();
      GameState.instance.notify();
    }
  }

  factory Building.create({
    required Zone zone,
    required BuildingType buildingType,
    required int level,
    required int workers,
    Patch? patch,
  }) {
    switch (buildingType) {
      case BuildingType.headquarters:
        return Headquarters(
          zone: zone,
          level: level,
          workers: workers,
        );
      case BuildingType.house:
        return House(
          zone: zone,
          level: level,
        );
      case BuildingType.warehouse:
        return Warehouse(
          zone: zone,
          level: level,
        );
      case BuildingType.farm:
        return Farm(
          zone: zone,
          patch: patch!,
          level: level,
          workers: workers,
          productionTime: buildingType.productionTime(level),
        );
      case BuildingType.woodcutter:
        return Woodcutter(
          zone: zone,
          patch: patch!,
          level: level,
          workers: workers,
          productionTime: buildingType.productionTime(level),
        );
      case BuildingType.quarry:
        return Quarry(
          zone: zone,
          patch: patch!,
          level: level,
          workers: workers,
          productionTime: buildingType.productionTime(level),
        );
      case BuildingType.copper_mine:
        return CopperMine(
          zone: zone,
          patch: patch!,
          level: level,
          workers: workers,
          productionTime: buildingType.productionTime(level),
        );
      case BuildingType.iron_mine:
        return IronMine(
          zone: zone,
          patch: patch!,
          level: level,
          workers: workers,
          productionTime: buildingType.productionTime(level),
        );
      case BuildingType.gold_mine:
        return GoldMine(
          zone: zone,
          patch: patch!,
          level: level,
          workers: workers,
          productionTime: buildingType.productionTime(level),
        );
      case BuildingType.barracks:
        return Barracks(
          zone: zone,
          level: level,
        );
      case BuildingType.archery:
        return Archery(
          zone: zone,
          level: level,
        );
      case BuildingType.cavalry:
        return Cavalry(
          zone: zone,
          level: level,
        );
      case BuildingType.workshop:
        return Workshop(
          zone: zone,
          level: level,
        );
      case BuildingType.fortress:
        return Fortress(
          zone: zone,
          level: level,
        );
    }
  }
}
