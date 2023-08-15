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

class Building {
  final BuildingType buildingType;
  int level;
  int villagers;
  UpgradeBuildingTask? upgradeTask;

  Building({
    required this.buildingType,
    required this.level,
    required this.villagers,
  });

  bool get hasVillagers => villagers > 0;

  bool get canHaveMoreVillagers => villagers < level;

  bool get canAddVillagers => level > villagers;

  ResourceMap get upgradeCost => buildingType.cost(level + 1);

  void addUpgradeQueue(ResourceMap cost) {
    upgradeTask ??= UpgradeBuildingTask(cost);
  }

  void removeVillagerQueue() {
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

  void addVillagers(int amount) {
    villagers += amount;
  }

  void removeVillagers(int amount) {
    villagers -= amount;
  }

  factory Building.create({
    required BuildingType buildingType,
    required int level,
    required int villagers,
  }) {
    switch (buildingType) {
      case BuildingType.headquarters:
        return Headquarters(
          level: level,
        );
      case BuildingType.house:
        return House(
          level: level,
        );
      case BuildingType.warehouse:
        return Warehouse(
          level: level,
        );
      case BuildingType.well:
        return Well(
          level: level,
          villagers: villagers,
        );
      case BuildingType.field:
        return Field(
          level: level,
          villagers: villagers,
        );
      case BuildingType.woodcutter:
        return Woodcutter(
          level: level,
          villagers: villagers,
        );
      case BuildingType.quarry:
        return Quarry(
          level: level,
          villagers: villagers,
        );
    }
  }
}
