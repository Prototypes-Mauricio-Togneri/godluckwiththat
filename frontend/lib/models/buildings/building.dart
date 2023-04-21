import 'package:flutter/widgets.dart';
import 'package:tensionplanet/components/building_sprite.dart';
import 'package:tensionplanet/game/game_state.dart';
import 'package:tensionplanet/models/buildings/archery.dart';
import 'package:tensionplanet/models/buildings/barracks.dart';
import 'package:tensionplanet/models/buildings/cavalry.dart';
import 'package:tensionplanet/models/buildings/copper_mine.dart';
import 'package:tensionplanet/models/buildings/farm.dart';
import 'package:tensionplanet/models/buildings/gold_mine.dart';
import 'package:tensionplanet/models/buildings/headquarters.dart';
import 'package:tensionplanet/models/buildings/house.dart';
import 'package:tensionplanet/models/buildings/iron_mine.dart';
import 'package:tensionplanet/models/buildings/market.dart';
import 'package:tensionplanet/models/buildings/quarry.dart';
import 'package:tensionplanet/models/buildings/warehouse.dart';
import 'package:tensionplanet/models/buildings/woodcutter.dart';
import 'package:tensionplanet/models/buildings/workshop.dart';
import 'package:tensionplanet/models/patch.dart';
import 'package:tensionplanet/models/village.dart';
import 'package:tensionplanet/types/building_type.dart';

class Building {
  final Village village;
  final BuildingType buildingType;
  final Offset offset;
  int level;
  int villagers;

  Building({
    required this.village,
    required this.buildingType,
    required this.offset,
    required this.level,
    required this.villagers,
  });

  void update(double dt) {}

  BuildingSprite get sprite => BuildingSprite(this);

  void onUpgrade() {
    level++;
  }

  void onAddVillager() {
    if (village.hasFreeVillagers) {
      villagers += village.removeFreeVillager();
      GameState.instance.notify();
    }
  }

  void onRemoveVillager() {
    if (village.hasFreeVillagers) {
      villagers -= village.addFreeVillager();
      GameState.instance.notify();
    }
  }

  factory Building.create({
    required Village village,
    required BuildingType buildingType,
    required int level,
    required int villagers,
    Patch? patch,
  }) {
    switch (buildingType) {
      case BuildingType.headquarters:
        return Headquarters(
          village: village,
          level: level,
          villagers: villagers,
        );
      case BuildingType.house:
        return House(
          village: village,
          level: level,
        );
      case BuildingType.market:
        return Market(
          village: village,
          level: level,
        );
      case BuildingType.warehouse:
        return Warehouse(
          village: village,
          level: level,
        );
      case BuildingType.farm:
        return Farm(
          village: village,
          patch: patch!,
          level: level,
          villagers: villagers,
          productionTime: buildingType.productionTime(level),
        );
      case BuildingType.woodcutter:
        return Woodcutter(
          village: village,
          patch: patch!,
          level: level,
          villagers: villagers,
          productionTime: buildingType.productionTime(level),
        );
      case BuildingType.quarry:
        return Quarry(
          village: village,
          patch: patch!,
          level: level,
          villagers: villagers,
          productionTime: buildingType.productionTime(level),
        );
      case BuildingType.copper_mine:
        return CopperMine(
          village: village,
          patch: patch!,
          level: level,
          villagers: villagers,
          productionTime: buildingType.productionTime(level),
        );
      case BuildingType.iron_mine:
        return IronMine(
          village: village,
          patch: patch!,
          level: level,
          villagers: villagers,
          productionTime: buildingType.productionTime(level),
        );
      case BuildingType.gold_mine:
        return GoldMine(
          village: village,
          patch: patch!,
          level: level,
          villagers: villagers,
          productionTime: buildingType.productionTime(level),
        );
      case BuildingType.barracks:
        return Barracks(
          village: village,
          level: level,
        );
      case BuildingType.archery:
        return Archery(
          village: village,
          level: level,
        );
      case BuildingType.cavalry:
        return Cavalry(
          village: village,
          level: level,
        );
      case BuildingType.workshop:
        return Workshop(
          village: village,
          level: level,
        );
      case BuildingType.fortress:
        return Workshop(
          village: village,
          level: level,
        );
    }
  }
}
