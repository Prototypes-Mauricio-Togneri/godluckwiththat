import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/game/base_game_state.dart';
import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/models/tasks/construction_task.dart';
import 'package:godluckwiththat/models/tasks/exploration_task.dart';

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

  void onAddConstructionTask(ConstructionTask task) {
    if (task.hasPatch) {
      colony.removePatch(task.patch!);
    }

    colony.addConstructionTask(task);
    colony.removeFreeVillagers(1);
    colony.removeResources(task.buildingType.initialCost);
  }

  void onRemoveConstructionTask(ConstructionTask task) {
    if (!task.isCompleted) {
      if (task.hasPatch) {
        colony.addPatch(task.patch!);
      }

      colony.removeConstructionTask(task);
      colony.addFreeVillagers(1);
      colony.addResources(task.buildingType.initialCost);
    }
  }

  // ======================================================================== \\

  void onAddExplorationTask(ExplorationTask task) {
    colony.addExplorationTask(task);
    colony.removeFreeVillagers(task.villagers);
  }

  void onRemoveExplorationTask(ExplorationTask task) {
    if (!task.isCompleted) {
      colony.removeExplorationTask(task);
      colony.addFreeVillagers(task.villagers);
    }
  }
}
