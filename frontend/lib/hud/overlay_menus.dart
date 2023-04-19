import 'package:flutter/material.dart';
import 'package:tensionplanet/game/game_component.dart';
import 'package:tensionplanet/game/game_state.dart';
import 'package:tensionplanet/hud/menu_button_hud.dart';
import 'package:tensionplanet/hud/resource_hud.dart';
import 'package:tensionplanet/hud/village_switcher.dart';

class OverlayMenus extends StatelessWidget {
  final GameComponent game;
  final GameState state;

  const OverlayMenus({
    required this.game,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        VillageSwitcher(
          game: game,
          state: state,
        ),
        ResourceHud(
          game: game,
          state: state,
        ),
        MenuButtonHud(
          game: game,
          state: state,
        ),
      ],
    );
  }
}
