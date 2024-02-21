import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/types/unit_type.dart';

abstract class Consumer extends Building {
  final UnitType unitType;

  Consumer({
    required this.unitType,
    required super.buildingType,
    required super.colony,
    required super.level,
  });

  ResourceMap get trainingCost;

  bool get canTrain {
    final int totalPopulation =
        colony.currentPopulation + colony.villagerTasks.length;

    return (totalPopulation < colony.populationLimit) &&
        colony.resourceInventory.hasItems(trainingCost);
  }

  @override
  bool get isConsumer => true;

  void train();

  /*void train() {
    if (canTrain) {
      colony.inventory.addResource(Resource.one(resourceType));
      colony.inventory.removeResources(trainingCost.resources());

      if (resourceType == ResourceType.villager) {
        colony.addFreeVillagers(1);
      }
    }
  }*/
}
