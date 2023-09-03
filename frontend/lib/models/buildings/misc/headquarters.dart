import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/models/colony.dart';
import 'package:godluckwiththat/models/tasks/create_villager_task.dart';
import 'package:godluckwiththat/types/building_type.dart';

class Headquarters extends Building {
  final List<CreateVillagerTask> createVillagerTasks = [];

  Headquarters({
    required super.colony,
    required super.level,
  }) : super(
          buildingType: BuildingType.headquarters,
          villagers: 0,
        );

  void addVillagerTask(ResourceMap cost) {
    createVillagerTasks.add(CreateVillagerTask(cost: cost));
  }

  void removeVillagerTask() {
    createVillagerTasks.removeAt(createVillagerTasks.length - 1);
  }

  @override
  void update(double dt, Colony colony) {
    super.update(dt, colony);

    if (createVillagerTasks.isNotEmpty) {
      final CreateVillagerTask task = createVillagerTasks.first;

      if (task.update(dt)) {
        colony.onCreateVillagerTaskFinished(task);
        createVillagerTasks.removeAt(0);
      }
    }
  }
}
