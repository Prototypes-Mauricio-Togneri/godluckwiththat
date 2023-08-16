import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/game/base_game_state.dart';
import 'package:godluckwiththat/types/building_type.dart';

mixin GameStateActions on BaseGameState {
  void onAddVillagerQueue(ResourceMap cost) {
    colony.headquarters.addVillagerQueue(cost);
    colony.removeResources(cost);
  }

  void onRemoveVillagerQueue(ResourceMap cost) {
    colony.headquarters.removeVillagerQueue();
    colony.addResources(cost);
  }

  // ======================================================================== \\

  void onAddUpgradeHeadquarters(ResourceMap cost) {
    colony.headquarters.addUpgradeQueue(cost);
    colony.removeResources(cost);
  }

  void onRemoveUpgradeHeadquarters(ResourceMap cost) {
    colony.headquarters.removeUpgradeQueue();
    colony.addResources(cost);
  }

  // ======================================================================== \\

  void onAddConstructBuilding(ResourceMap cost, BuildingType buildingType) {
    colony.addConstructBuildingQueue(cost, buildingType);
    colony.removeResources(cost);
  }

  void onRemoveConstructBuilding(ResourceMap cost, BuildingType buildingType) {
    colony.removeConstructBuildingQueue(buildingType);
    colony.addResources(cost);
  }
}
