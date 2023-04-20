import 'package:flutter/material.dart';
import 'package:tensionplanet/game/game_state.dart';
import 'package:tensionplanet/hud/menu_button_hud.dart';
import 'package:tensionplanet/hud/resource_hud.dart';
import 'package:tensionplanet/hud/village_switcher.dart';

class OverlayMenus extends StatelessWidget {
  final GameState state;

  const OverlayMenus(this.state);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        VillageSwitcher(state),
        ResourceHud(state),
        MenuButtonHud(state),
      ],
    );
  }
}
