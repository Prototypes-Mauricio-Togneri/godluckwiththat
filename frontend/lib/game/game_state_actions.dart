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

  void onAddConstructBuildingTask({
    required ResourceMap cost,
    required BuildingType buildingType,
  }) {
    colony.addConstructBuildingTask(cost, buildingType);
    colony.removeResources(cost);
  }

  void onRemoveConstructBuildingTask({
    required ResourceMap cost,
    required BuildingType buildingType,
  }) {
    colony.removeConstructBuildingTask(buildingType);
    colony.addResources(cost);
  }

  // ======================================================================== \\

  void onAddExplorationTask(ExplorationTask task) {
    //colony.addConstructBuildingTask(cost, buildingType);
    //colony.removeResources(cost);
  }

  void onRemoveExplorationTask(ExplorationTask task) {
    //colony.removeConstructBuildingTask(buildingType);
    //colony.addResources(cost);
  }
}
