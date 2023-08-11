import 'package:dafluta/dafluta.dart';
import 'package:flutter/services.dart';
import 'package:gatewayguardians/json/json_match.dart';
import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/models/colony.dart';
import 'package:gatewayguardians/models/inventory.dart';
import 'package:gatewayguardians/types/menu_type.dart';
import 'package:gatewayguardians/types/resource_type.dart';

class GameState extends BaseState {
  num totalTimeElapsed = 0;
  MenuType menuType = MenuType.headquarters;
  final JsonMatch jsonMatch;
  late final Colony colony;

  GameState(this.jsonMatch) {
    totalTimeElapsed = jsonMatch.totalTimeElapsed;

    colony = Colony(
      inventory: Inventory.fromResourceMap({
        ResourceType.villager: 5,
        ResourceType.food: 200,
        ResourceType.wood: 200,
      }),
      buildings: [],
      freeVillagers: 5,
    );
  }

  void onPop() {
    // TODO(momo): show main menu
  }

  void onKey(RawKeyEvent event) {
    if (event.isKeyPressed(LogicalKeyboardKey.escape) && !event.repeat) {
      // TODO(momo): show main menu
    }
  }

  void update(double dt) {
    totalTimeElapsed += dt;
  }

  void openMenu(MenuType type) {
    menuType = type;
    notify();
  }

  void addVillager(Building building) {
    if (colony.hasFreeVillagers) {
      building.addVillagers(colony.removeFreeVillagers(1));
      notify();
    }
  }

  void removeVillager(Building building) {
    if (building.hasVillagers) {
      building.removeVillagers(colony.addFreeVillagers(1));
      notify();
    }
  }

  void onOpenMainMenu() {}
}
