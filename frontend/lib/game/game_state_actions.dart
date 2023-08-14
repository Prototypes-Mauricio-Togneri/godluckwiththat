import 'package:gatewayguardians/game/base_game_state.dart';
import 'package:gatewayguardians/models/buildings/building.dart';

mixin GameStateActions on BaseGameState {
  void onUpgradeHeadquarters() {
    repaint();
  }

  void onCreateVillager() {
    repaint();
  }

  void onRemoveVillagerQueue() {
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
