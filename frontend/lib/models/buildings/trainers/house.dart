import 'package:godluckwiththat/models/buildings/trainers/trainer.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/resource_type.dart';

class House extends Trainer {
  House({
    required super.colony,
    required super.level,
  }) : super(
          buildingType: BuildingType.house,
          resourceType: ResourceType.villager,
        );

  @override
  int get resources => colony.inventory.get(ResourceType.villager).toInt();

  @override
  int get capacity => colony.populationLimit;
}
