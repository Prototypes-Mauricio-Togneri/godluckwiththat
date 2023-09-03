import 'package:dafluta/dafluta.dart';
import 'package:flutter/services.dart';
import 'package:godluckwiththat/json/json_match.dart';
import 'package:godluckwiththat/models/buildings/misc/headquarters.dart';
import 'package:godluckwiththat/models/colony.dart';
import 'package:godluckwiththat/models/inventory.dart';
import 'package:godluckwiththat/types/menu_type.dart';
import 'package:godluckwiththat/types/resource_type.dart';

class BaseGameState extends BaseState {
  num totalTimeElapsed = 0;
  MenuType menuType = MenuType.headquarters;
  final JsonMatch jsonMatch;
  late final Colony colony;

  BaseGameState(this.jsonMatch) {
    totalTimeElapsed = jsonMatch.totalTimeElapsed;

    colony = Colony(
      inventory: Inventory.fromResourceMap({
        ResourceType.villager: 5,
        ResourceType.water: 50,
        ResourceType.food: 100,
        ResourceType.wood: 200,
        ResourceType.stone: 0,
      }),
      buildings: [],
      patches: [],
      freeVillagers: 5,
    );

    colony.addBuildings([
      Headquarters(
        colony: colony,
        level: 1,
      ),
    ]);
  }

  bool isSelected(MenuType type) => menuType == type;

  void onMenuSelected(MenuType type) {
    menuType = type;
    notify();
  }

  int get day => totalTimeElapsed.toInt();

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
    colony.update(dt);
  }

  void onOpenMainMenu() {}
}
