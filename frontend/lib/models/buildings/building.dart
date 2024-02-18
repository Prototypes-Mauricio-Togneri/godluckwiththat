import 'package:flutter/material.dart';
import 'package:godluckwiththat/app/constants.dart';
import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/buildings/misc/house.dart';
import 'package:godluckwiththat/models/buildings/producers/farm.dart';
import 'package:godluckwiththat/models/buildings/producers/quarry.dart';
import 'package:godluckwiththat/models/buildings/producers/well.dart';
import 'package:godluckwiththat/models/buildings/producers/woodcutter.dart';
import 'package:godluckwiththat/models/colony.dart';
import 'package:godluckwiththat/types/building_type.dart';

class Building {
  final Colony colony;
  final BuildingType buildingType;
  int level;
  int villagers;

  Building({
    required this.colony,
    required this.buildingType,
    required this.level,
    required this.villagers,
  });

  bool get hasVillagers => villagers > 0;

  int get maxCapacity => level * Constants.BUILDING_CAPACITY_PER_LEVEL;

  bool get canHoldMoreVillagers => maxCapacity > villagers;

  ResourceMap get upgradeCost => buildingType.cost(level + 1);

  bool get canAddVillagers => colony.hasFreeVillagers && canHoldMoreVillagers;

  bool get canRemoveVillagers => hasVillagers;

  @mustCallSuper
  void update(double dt, Colony colony) {}

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
  }) {
    switch (buildingType) {
      case BuildingType.house:
        return House(
          colony: colony,
          level: level,
        );
      case BuildingType.well:
        return Well(
          colony: colony,
          level: level,
          villagers: villagers,
        );
      case BuildingType.farm:
        return Farm(
          colony: colony,
          level: level,
          villagers: villagers,
        );
      case BuildingType.woodcutter:
        return Woodcutter(
          colony: colony,
          level: level,
          villagers: villagers,
        );
      case BuildingType.quarry:
        return Quarry(
          colony: colony,
          level: level,
          villagers: villagers,
        );
    }
  }
}
