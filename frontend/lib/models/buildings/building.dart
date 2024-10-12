import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/buildings/consumers/headquarters.dart';
import 'package:godluckwiththat/models/buildings/passive/house.dart';
import 'package:godluckwiththat/models/buildings/passive/market.dart';
import 'package:godluckwiththat/models/buildings/passive/monument.dart';
import 'package:godluckwiththat/models/buildings/passive/storehouse.dart';
import 'package:godluckwiththat/models/buildings/producers/academy.dart';
import 'package:godluckwiththat/models/buildings/producers/altar.dart';
import 'package:godluckwiththat/models/buildings/producers/copper_mine.dart';
import 'package:godluckwiththat/models/buildings/producers/farm.dart';
import 'package:godluckwiththat/models/buildings/producers/gold_mine.dart';
import 'package:godluckwiththat/models/buildings/producers/iron_mine.dart';
import 'package:godluckwiththat/models/buildings/producers/logging_camp.dart';
import 'package:godluckwiththat/models/buildings/producers/quarry.dart';
import 'package:godluckwiththat/models/buildings/producers/shrine.dart';
import 'package:godluckwiththat/models/buildings/producers/temple.dart';
import 'package:godluckwiththat/models/colony.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/headquarters_type.dart';

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

  bool get canUpgrade => colony.canUpgrade(this);

  void upgrade() {
    if (canUpgrade) {
      level++;
      colony.increaseTerritoryUsed();
      colony.resources.removeItems(upgradeCost);
      colony.notify();
    }
  }

  factory Building.create({
    required Colony colony,
    required BuildingType buildingType,
    required int level,
    required int workers,
    HeadquartersType headquartersType = HeadquartersType.camp,
  }) {
    switch (buildingType) {
      case BuildingType.headquarters:
        return Headquarters(
          colony: colony,
          level: level,
          type: headquartersType,
        );
      case BuildingType.house:
        return House(
          colony: colony,
          level: level,
        );
      case BuildingType.academy:
        return Academy(
          colony: colony,
          level: level,
          workers: workers,
        );
      case BuildingType.storehouse:
        return Storehouse(
          colony: colony,
          level: level,
        );
      case BuildingType.market:
        return Market(
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
        return Woodcutter(
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
      case BuildingType.altar:
        return Altar(
          colony: colony,
          level: level,
        );
      case BuildingType.shrine:
        return Shrine(
          colony: colony,
          level: level,
          workers: workers,
        );
      case BuildingType.temple:
        return Temple(
          colony: colony,
          level: level,
          workers: workers,
        );
      case BuildingType.monument:
        return Monument(
          colony: colony,
          level: level,
        );
    }
  }
}
