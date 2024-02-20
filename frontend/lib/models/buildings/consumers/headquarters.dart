import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/buildings/consumers/consumer.dart';
import 'package:godluckwiththat/models/tasks/create_villager_task.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/resource_type.dart';

class Headquarters extends Consumer {
  Headquarters({
    required super.colony,
    required super.level,
  }) : super(
          buildingType: BuildingType.headquarters,
          resourceType: ResourceType.villager,
        );

  @override
  ResourceMap get trainingCost => {
        ResourceType.food: 50,
      };

  @override
  void train() {
    if (canTrain) {
      colony.villagerTasks.add(CreateVillagerTask(cost: trainingCost));
      colony.resourceInventory.removeItems(trainingCost);
    }
  }
}
