import 'package:flutter/material.dart';
import 'package:tensionplanet/game/game_state.dart';
import 'package:tensionplanet/hud/building_quick_menu.dart';
import 'package:tensionplanet/hud/menu_button_hud.dart';
import 'package:tensionplanet/hud/resource_hud.dart';
import 'package:tensionplanet/hud/zone_switcher_hud.dart';

class HudContainer extends StatelessWidget {
  final GameState state;

  const HudContainer(this.state);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: [
          ZoneSwitcherHud(state),
          ResourceHud(state),
          MenuButtonHud(state),
          if (state.selectedBuilding != null)
            Positioned(
              top: (constraints.maxHeight * state.selectedBuilding!.offset.dy) -
                  (constraints.maxHeight / 10),
              left: (constraints.maxWidth * state.selectedBuilding!.offset.dx) -
                  (constraints.maxHeight / 10),
              child: BuildingQuickMenu(
                colony: state.colony,
                building: state.selectedBuilding!,
                size: constraints.maxHeight / 5,
              ),
            ),
        ],
      ),
    );
  }
}
