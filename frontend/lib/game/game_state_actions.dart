import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/game/base_game_state.dart';
import 'package:godluckwiththat/models/buildings/building.dart';

mixin GameStateActions on BaseGameState {
  void onUpgradeHeadquarters(ResourceMap cost) {
    colony.headquarters.addUpgradeQueue(cost);
    colony.removeResources(cost);
    repaint();
  }

  void onAddVillagerQueue(ResourceMap cost) {
    colony.headquarters.addVillagerQueue(cost);
    colony.removeResources(cost);
    repaint();
  }

  void onRemoveVillagerQueue(ResourceMap cost) {
    colony.headquarters.removeVillagerQueue();
    colony.addResources(cost);
    repaint();
  }

  void onBuildHouse() {
    repaint();
  }

  void onRemoveHouseQueue() {
    repaint();
  }

  void onAddVillager(Building building) {
    if (colony.hasFreeVillagers) {
      building.addVillagers(colony.removeFreeVillagers(1));
      repaint();
    }
  }

  void onRemoveVillager(Building building) {
    if (building.hasVillagers) {
      building.removeVillagers(colony.addFreeVillagers(1));
      repaint();
    }
  }
}
