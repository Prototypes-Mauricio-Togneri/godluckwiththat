import 'package:godluckwiththat/extensions/resource_map_extension.dart';
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
  int get maxResourceCapacity => colony.populationLimit;

  @override
  ResourceMap get trainingCost => {
        ResourceType.food: 50,
      };
}
