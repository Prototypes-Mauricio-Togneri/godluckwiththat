import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/game/base_game_state.dart';
import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/models/patch.dart';
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

  void onAddConstructionFromPatchTask(Patch patch) {
    colony.patches.remove(patch);
    onAddConstructionTask(ConstructionTask(
      buildingType: patch.patchType.buildingType,
      resourcesAmount: patch.amount.toDouble(),
    ));
  }

  void onAddConstructionTask(ConstructionTask task) {
    colony.addConstructionTask(task);
    colony.removeFreeVillagers(1);
    colony.removeResources(task.buildingType.initialCost);
  }

  void onRemoveConstructionTask(ConstructionTask task) {
    colony.removeConstructionTask(task);
    colony.addFreeVillagers(1);
    colony.addResources(task.buildingType.initialCost);
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
