import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/models/colony.dart';
import 'package:gatewayguardians/models/tasks/create_villager_task.dart';
import 'package:gatewayguardians/types/building_type.dart';

class Headquarters extends Building {
  final List<CreateVillagerTask> createVillagerTasks = [];

  Headquarters({
    required super.level,
  }) : super(
          buildingType: BuildingType.headquarters,
          villagers: 0,
        );

  void addVillagerQueue() {
    createVillagerTasks.add(CreateVillagerTask(6));
  }

  void removeVillagerQueue() {
    createVillagerTasks.removeAt(createVillagerTasks.length - 1);
  }

  @override
  void update(double dt, Colony colony) {
    if (createVillagerTasks.isNotEmpty) {
      if (createVillagerTasks.first.update(dt)) {
        colony.createVillager();
        createVillagerTasks.removeAt(0);
      }
    }
  }
}
