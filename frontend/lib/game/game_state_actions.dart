import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/game/base_game_state.dart';
import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/models/tasks/exploration_task.dart';
import 'package:godluckwiththat/types/building_type.dart';

mixin GameStateActions on BaseGameState {
  void onAddVillagerTask(ResourceMap cost) {
    colony.headquarters.addVillagerTask(cost);
    colony.removeResources(cost);
  }

  void onRemoveVillagerTask(ResourceMap cost) {
    colony.headquarters.removeVillagerTask();
    colony.addResources(cost);
  }

  // ======================================================================== \\

  void onAddUpgradeBuildingTask({
    required Building building,
    required ResourceMap cost,
  }) {
    building.addUpgradeTask(cost);
    colony.removeResources(cost);
  }

  void onRemoveUpgradeBuildingTask({
    required Building building,
    required ResourceMap cost,
  }) {
    building.removeUpgradeTask();
    colony.addResources(cost);
  }

  // ======================================================================== \\

  void onAddConstructBuildingTask(BuildingType buildingType) {
    colony.addConstructBuildingTask(buildingType);
    colony.removeResources(buildingType.initialCost);
  }

  void onRemoveConstructBuildingTask(BuildingType buildingType) {
    colony.removeConstructBuildingTask(buildingType);
    colony.addResources(buildingType.initialCost);
  }

  // ======================================================================== \\

  void onAddExplorationTask(ExplorationTask task) {
    colony.addExplorationTask(task);
    colony.removeFreeVillagers(task.villagers);
  }

  void onRemoveExplorationTask(ExplorationTask task) {
    colony.removeExplorationTask(task);
    colony.addFreeVillagers(task.villagers);
  }
}
