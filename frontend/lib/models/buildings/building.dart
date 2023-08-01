import 'package:gatewayguardians/extensions/resource_map_extension.dart';
import 'package:gatewayguardians/models/buildings/military/archery.dart';
import 'package:gatewayguardians/models/buildings/military/barracks.dart';
import 'package:gatewayguardians/models/buildings/military/cavalry.dart';
import 'package:gatewayguardians/models/buildings/military/fortress.dart';
import 'package:gatewayguardians/models/buildings/military/workshop.dart';
import 'package:gatewayguardians/models/buildings/misc/headquarters.dart';
import 'package:gatewayguardians/models/buildings/misc/house.dart';
import 'package:gatewayguardians/models/buildings/misc/warehouse.dart';
import 'package:gatewayguardians/models/buildings/producers/copper_mine.dart';
import 'package:gatewayguardians/models/buildings/producers/farm.dart';
import 'package:gatewayguardians/models/buildings/producers/gold_mine.dart';
import 'package:gatewayguardians/models/buildings/producers/iron_mine.dart';
import 'package:gatewayguardians/models/buildings/producers/quarry.dart';
import 'package:gatewayguardians/models/buildings/producers/woodcutter.dart';
import 'package:gatewayguardians/types/building_type.dart';

class Building {
  final BuildingType buildingType;
  int level;
  int villagers;

  Building({
    required this.buildingType,
    required this.level,
    required this.villagers,
  });

  bool get hasVillagers => villagers > 0;

  bool get canHaveMoreVillagers => villagers < level;

  bool get canAddVillagers => level > villagers;

  bool get isDestroyable => buildingType != BuildingType.headquarters;

  ResourceMap get costNextLevel => buildingType.cost(level + 1);

  String get buildingLabel {
    if (isProducer) {
      return '$villagers/$level';
    } else {
      return '$level';
    }
  }

  bool get isProducer =>
      (buildingType == BuildingType.farm) ||
      (buildingType == BuildingType.woodcutter) ||
      (buildingType == BuildingType.quarry) ||
      (buildingType == BuildingType.copper_mine) ||
      (buildingType == BuildingType.iron_mine) ||
      (buildingType == BuildingType.gold_mine);

  bool get isTrainer =>
      (buildingType == BuildingType.headquarters) ||
      (buildingType == BuildingType.barracks) ||
      (buildingType == BuildingType.archery) ||
      (buildingType == BuildingType.cavalry) ||
      (buildingType == BuildingType.workshop);

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
          villagers: villagers,
        );
      case BuildingType.house:
        return House(
          level: level,
        );
      case BuildingType.warehouse:
        return Warehouse(
          level: level,
        );
      case BuildingType.farm:
        return Farm(
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
      case BuildingType.copper_mine:
        return CopperMine(
          level: level,
          villagers: villagers,
        );
      case BuildingType.iron_mine:
        return IronMine(
          level: level,
          villagers: villagers,
        );
      case BuildingType.gold_mine:
        return GoldMine(
          level: level,
          villagers: villagers,
        );
      case BuildingType.barracks:
        return Barracks(
          level: level,
        );
      case BuildingType.archery:
        return Archery(
          level: level,
        );
      case BuildingType.cavalry:
        return Cavalry(
          level: level,
        );
      case BuildingType.workshop:
        return Workshop(
          level: level,
        );
      case BuildingType.fortress:
        return Fortress(
          level: level,
        );
    }
  }
}
