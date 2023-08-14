import 'package:dafluta/dafluta.dart';
import 'package:flutter/services.dart';
import 'package:gatewayguardians/app/constants.dart';
import 'package:gatewayguardians/json/json_match.dart';
import 'package:gatewayguardians/models/buildings/misc/headquarters.dart';
import 'package:gatewayguardians/models/colony.dart';
import 'package:gatewayguardians/models/inventory.dart';
import 'package:gatewayguardians/types/menu_type.dart';
import 'package:gatewayguardians/types/resource_type.dart';

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
        ResourceType.water: 100,
        ResourceType.food: 200,
        ResourceType.wood: 300,
        ResourceType.stone: 400,
      }),
      buildings: [
        Headquarters(level: 1),
      ],
      freeVillagers: 5,
    );
  }

  int get day => totalTimeElapsed ~/ Constants.SECONDS_PER_DAY;

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
    repaint();
  }

  void openMenu(MenuType type) {
    menuType = type;
    repaint();
  }

  void onOpenMainMenu() {}

  void repaint() => Delayed.post(notify);
}
