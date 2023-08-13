import 'package:dafluta/dafluta.dart';
import 'package:gatewayguardians/states/game_state.dart';
import 'package:gatewayguardians/types/menu_type.dart';

class MenuState extends BaseState {
  final GameState gameState;
  MenuType menuType;

  MenuState({
    required this.gameState,
    required this.menuType,
  });

  void onMenuSelected(MenuType type) {
    menuType = type;
    gameState.openMenu(type);
    notify();
  }

  bool isSelected(MenuType type) => menuType == type;
}
