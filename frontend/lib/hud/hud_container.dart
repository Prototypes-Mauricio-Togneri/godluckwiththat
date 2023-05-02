import 'package:flutter/material.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/hud/building_menu_hud.dart';
import 'package:gatewayguardians/hud/resource_hud.dart';

class HudContainer extends StatelessWidget {
  final GameState state;

  const HudContainer(this.state);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: [
          ResourceHud(state),
          //MenuButtonHud(state),
          if (state.selectedBuilding != null)
            BuildingMenuHud(
              state: state,
              building: state.selectedBuilding!,
            ),
        ],
      ),
    );
  }
}
