import 'package:flutter/material.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/hud/island_hud.dart';
import 'package:gatewayguardians/hud/menu_button_hud.dart';
import 'package:gatewayguardians/hud/resources_hud.dart';
import 'package:gatewayguardians/utils/palette.dart';

class LeftMenu extends StatelessWidget {
  final GameState state;

  const LeftMenu(this.state);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.grey,
      width: 300,
      height: double.infinity,
      child: Column(
        children: [
          ResourcesHud(state),
          if (state.selectedIsland != null)
            IslandHud(
              state: state,
              island: state.selectedIsland!,
            ),
          const Spacer(),
          MenuButtonHud(state),
        ],
      ),
    );
  }
}
