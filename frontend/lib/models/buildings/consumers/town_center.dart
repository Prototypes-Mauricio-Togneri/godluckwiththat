import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/buildings/consumers/consumer.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/unit_type.dart';

class TownCenter extends Consumer {
  TownCenter({
    required super.colony,
    required super.level,
  }) : super(
          buildingType: BuildingType.townCenter,
          unitType: UnitType.villager,
        );

  @override
  ResourceMap get trainingCost => UnitType.villager.cost;

  @override
  void train() {
    if (canTrain) {
      colony.createVillager();
    }
  }
}
