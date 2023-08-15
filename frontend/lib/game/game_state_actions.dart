import 'package:godluckwiththat/game/base_game_state.dart';
import 'package:godluckwiththat/models/buildings/building.dart';

mixin GameStateActions on BaseGameState {
  void onUpgradeHeadquarters() {
    repaint();
  }

  void onAddVillagerQueue() {
    colony.headquarters.addVillagerQueue();
    repaint();
  }

  void onRemoveVillagerQueue() {
    colony.headquarters.removeVillagerQueue();
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
