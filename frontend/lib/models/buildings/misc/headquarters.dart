import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/models/colony.dart';
import 'package:gatewayguardians/models/tasks/create_villager_task.dart';
import 'package:gatewayguardians/types/building_type.dart';

class Headquarters extends Building {
  List<CreateVillagerTask> createVillagerTasks = [];

  Headquarters({
    required super.level,
  }) : super(
          buildingType: BuildingType.headquarters,
          villagers: 0,
        );

  void createVillager() {
    createVillagerTasks.add(CreateVillagerTask(6));
  }

  @override
  void update(double dt, Colony colony) {
    final List<CreateVillagerTask> unfinishedTasks = [];

    for (final CreateVillagerTask task in createVillagerTasks) {
      if (task.update(dt)) {
        colony.createVillager();
      } else {
        unfinishedTasks.add(task);
      }
    }

    createVillagerTasks = unfinishedTasks;
  }
}
