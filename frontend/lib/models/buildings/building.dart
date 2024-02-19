import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/buildings/producers/farm.dart';
import 'package:godluckwiththat/models/buildings/producers/quarry.dart';
import 'package:godluckwiththat/models/buildings/producers/well.dart';
import 'package:godluckwiththat/models/buildings/producers/woodcutter.dart';
import 'package:godluckwiththat/models/buildings/trainers/house.dart';
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

  bool get isTrainer => false;

  bool get canUpgrade => colony.inventory.hasResources(upgradeCost.resources());

  void upgrade() {
    if (canUpgrade) {
      colony.inventory.removeResources(upgradeCost.resources());
      level++;
    }
  }

  void destroy() {
    colony.removeBuilding(this);
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
