import 'package:dafluta/dafluta.dart';
import 'package:flutter/services.dart';
import 'package:godluckwiththat/json/json_match.dart';
import 'package:godluckwiththat/models/buildings/misc/headquarters.dart';
import 'package:godluckwiththat/models/buildings/producers/well.dart';
import 'package:godluckwiththat/models/colony.dart';
import 'package:godluckwiththat/models/inventory.dart';
import 'package:godluckwiththat/types/menu_type.dart';
import 'package:godluckwiththat/types/resource_type.dart';

class BaseGameState extends BaseState {
  num totalTimeElapsed = 0;
  MenuType menuType = MenuType.water;
  final JsonMatch jsonMatch;
  late final Colony colony;

  BaseGameState(this.jsonMatch) {
    totalTimeElapsed = jsonMatch.totalTimeElapsed;

    colony = Colony(
      inventory: Inventory.fromResourceMap({
        ResourceType.villager: 5,
        ResourceType.water: 100,
        ResourceType.food: 200,
        ResourceType.wood: 300,
        ResourceType.stone: 400,
      }),
      buildings: [],
      patches: [],
      freeVillagers: 5,
    );

    colony.buildings.addAll([
      Headquarters(
        colony: colony,
        level: 1,
      ),
      Well(
        colony: colony,
        level: 2,
        villagers: 0,
        resourcesLeft: 100,
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
