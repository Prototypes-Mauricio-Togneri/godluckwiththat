import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/models/colony.dart';
import 'package:gatewayguardians/models/tasks/create_villager_task.dart';
import 'package:gatewayguardians/types/building_type.dart';

class Headquarters extends Building {
  List<CreateVillagerTask> tasks = [];

  Headquarters({
    required super.level,
  }) : super(
          buildingType: BuildingType.headquarters,
          villagers: 0,
        );

  void createVillager() {
    tasks.add(CreateVillagerTask(6));
  }

  @override
  void update(double dt, Colony colony) {
    final List<CreateVillagerTask> unfinishedTasks = [];

    for (final CreateVillagerTask task in tasks) {
      if (task.update(dt)) {
        colony.addFreeVillagers(1);
      } else {
        unfinishedTasks.add(task);
      }
    }

    tasks = unfinishedTasks;
  }
}
