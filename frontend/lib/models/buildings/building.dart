import 'package:flutter/material.dart';
import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/buildings/misc/headquarters.dart';
import 'package:godluckwiththat/models/buildings/misc/house.dart';
import 'package:godluckwiththat/models/buildings/misc/warehouse.dart';
import 'package:godluckwiththat/models/buildings/producers/field.dart';
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

  bool get canHoldMoreVillagers => level > villagers;

  Color get villagersAmountColor {
    if (villagers == 0) {
      return Palette.error;
    } else if (villagers == level) {
      return Palette.success;
    } else {
      return Palette.white;
    }
  }

  ResourceMap get upgradeCost => buildingType.cost(level + 1);

  bool get canAddVillagers => colony.hasFreeVillagers && canHoldMoreVillagers;

  bool get canRemoveVillagers => hasVillagers;

  void addUpgradeQueue(ResourceMap cost) {
    upgradeTask ??= UpgradeBuildingTask(cost);
  }

  void removeUpgradeQueue() {
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

  String get buildingLabel {
    if (isProducer) {
      return '$villagers/$level';
    } else {
      return '$level';
    }
  }

  bool get isProducer =>
      (buildingType == BuildingType.well) ||
      (buildingType == BuildingType.field) ||
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

  void destroy() {}

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
      case BuildingType.field:
        return Field(
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
