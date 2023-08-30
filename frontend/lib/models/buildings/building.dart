import 'package:flutter/material.dart';
import 'package:godluckwiththat/app/constants.dart';
import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/buildings/misc/headquarters.dart';
import 'package:godluckwiththat/models/buildings/misc/house.dart';
import 'package:godluckwiththat/models/buildings/misc/warehouse.dart';
import 'package:godluckwiththat/models/buildings/producers/farm.dart';
import 'package:godluckwiththat/models/buildings/producers/quarry.dart';
import 'package:godluckwiththat/models/buildings/producers/well.dart';
import 'package:godluckwiththat/models/buildings/producers/woodcutter.dart';
import 'package:godluckwiththat/models/colony.dart';
import 'package:godluckwiththat/models/tasks/upgrade_building_task.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/utils/palette.dart';

class Building {
  final Colony colony;
  final BuildingType buildingType;
  int level;
  int villagers;
  UpgradeBuildingTask? upgradeTask;

  Building({
    required this.colony,
    required this.buildingType,
    required this.level,
    required this.villagers,
  });

  bool get hasVillagers => villagers > 0;

  int get maxCapacity => level * Constants.BUILDING_CAPACITY_PER_LEVEL;

  bool get canHoldMoreVillagers => maxCapacity > villagers;

  Color get villagersAmountColor {
    if (villagers == 0) {
      return Palette.error;
    } else if (villagers == maxCapacity) {
      return Palette.success;
    } else {
      return Palette.white;
    }
  }

  ResourceMap get upgradeCost => buildingType.cost(level + 1);

  bool get canAddVillagers => colony.hasFreeVillagers && canHoldMoreVillagers;

  bool get canRemoveVillagers => hasVillagers;

  void addUpgradeTask(UpgradeBuildingTask task) {
    upgradeTask ??= task;
  }

  void removeUpgradeTask() {
    upgradeTask = null;
  }

  @mustCallSuper
  void update(double dt, Colony colony) {
    if (upgradeTask != null) {
      if (upgradeTask!.update(dt)) {
        level++;
        upgradeTask = null;
      }
    }
  }

  bool get isProducer =>
      (buildingType == BuildingType.well) ||
      (buildingType == BuildingType.farm) ||
      (buildingType == BuildingType.woodcutter) ||
      (buildingType == BuildingType.quarry);

  void addVillager() {
    if (colony.hasFreeVillagers && canHoldMoreVillagers) {
      villagers += colony.removeFreeVillagers(1);
    }
  }

  void removeVillagers() {
    if (hasVillagers) {
      villagers -= colony.addFreeVillagers(1);
    }
  }

  void destroy() {
    colony.removeBuilding(this);
    colony.addFreeVillagers(villagers);
  }

  factory Building.create({
    required Colony colony,
    required BuildingType buildingType,
    required int level,
    required int villagers,
    required double resourcesLeft,
  }) {
    switch (buildingType) {
      case BuildingType.headquarters:
        return Headquarters(
          colony: colony,
          level: level,
        );
      case BuildingType.house:
        return House(
          colony: colony,
          level: level,
        );
      case BuildingType.warehouse:
        return Warehouse(
          colony: colony,
          level: level,
        );
      case BuildingType.well:
        return Well(
          colony: colony,
          level: level,
          villagers: villagers,
          resourcesLeft: resourcesLeft,
        );
      case BuildingType.farm:
        return Farm(
          colony: colony,
          level: level,
          villagers: villagers,
          resourcesLeft: resourcesLeft,
        );
      case BuildingType.woodcutter:
        return Woodcutter(
          colony: colony,
          level: level,
          villagers: villagers,
          resourcesLeft: resourcesLeft,
        );
      case BuildingType.quarry:
        return Quarry(
          colony: colony,
          level: level,
          villagers: villagers,
          resourcesLeft: resourcesLeft,
        );
    }
  }
}
