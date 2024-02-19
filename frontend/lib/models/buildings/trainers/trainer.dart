import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/models/resource.dart';
import 'package:godluckwiththat/types/resource_type.dart';

abstract class Trainer extends Building {
  final ResourceType resourceType;

  Trainer({
    required this.resourceType,
    required super.buildingType,
    required super.colony,
    required super.level,
  });

  num get resources => colony.inventory.get(resourceType);

  num get maxResourceCapacity;

  ResourceMap get trainingCost;

  bool get isEmptyOfResources => resources == 0;

  bool get isFullOfResources => resources >= maxResourceCapacity;

  bool get canTrain =>
      (colony.totalPopulation < colony.populationLimit) &&
      colony.inventory.hasResources(trainingCost.resources());

  @override
  bool get isTrainer => true;

  void train() {
    if (canTrain) {
      colony.inventory.addResource(Resource.one(resourceType));
      colony.inventory.removeResources(trainingCost.resources());

      if (resourceType == ResourceType.villager) {
        colony.addFreeVillagers(1);
      }
    }
  }
}
