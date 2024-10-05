import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/buildings/consumers/headquarters.dart';
import 'package:godluckwiththat/models/buildings/consumers/house.dart';
import 'package:godluckwiththat/models/buildings/producers/copper_mine.dart';
import 'package:godluckwiththat/models/buildings/producers/farm.dart';
import 'package:godluckwiththat/models/buildings/producers/gold_mine.dart';
import 'package:godluckwiththat/models/buildings/producers/iron_mine.dart';
import 'package:godluckwiththat/models/buildings/producers/logging_camp.dart';
import 'package:godluckwiththat/models/buildings/producers/quarry.dart';
import 'package:godluckwiththat/models/colony.dart';
import 'package:godluckwiththat/types/building_type.dart';

class Building {
  final Colony colony;
  final BuildingType buildingType;
  int level;

  Building({
    required this.colony,
    required this.buildingType,
    required this.level,
  });

  ResourceMap get upgradeCost => buildingType.cost(level + 1);

  void update(double dt) {}

  bool get isProducer => false;

  bool get isConsumer => false;

  bool get canUpgrade => colony.resources.hasItems(upgradeCost);

  void upgrade() {
    if (canUpgrade) {
      colony.resources.removeItems(upgradeCost);
      level++;
    }
  }

  factory Building.create({
    required Colony colony,
    required BuildingType buildingType,
    required int level,
    required int workers,
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
      case BuildingType.academy:
        // TODO(momo): implement
        return House(
          colony: colony,
          level: level,
        );
      case BuildingType.storehouse:
        // TODO(momo): implement
        return House(
          colony: colony,
          level: level,
        );
      case BuildingType.market:
        // TODO(momo): implement
        return House(
          colony: colony,
          level: level,
        );
      case BuildingType.farm:
        return Farm(
          colony: colony,
          level: level,
          workers: workers,
        );
      case BuildingType.woodcutter:
        return LoggingCamp(
          colony: colony,
          level: level,
          workers: workers,
        );
      case BuildingType.quarry:
        return Quarry(
          colony: colony,
          level: level,
          workers: workers,
        );
      case BuildingType.copperMine:
        return CopperMine(
          colony: colony,
          level: level,
          workers: workers,
        );
      case BuildingType.ironMine:
        return IronMine(
          colony: colony,
          level: level,
          workers: workers,
        );
      case BuildingType.goldMine:
        return GoldMine(
          colony: colony,
          level: level,
          workers: workers,
        );
    }
  }
}
