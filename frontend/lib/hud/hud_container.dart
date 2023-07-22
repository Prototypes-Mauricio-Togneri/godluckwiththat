import 'package:flutter/material.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/hud/building_menu_hud.dart';
import 'package:gatewayguardians/hud/patch_menu_hud.dart';
import 'package:gatewayguardians/hud/zone_menu_hud.dart';

class HudContainer extends StatelessWidget {
  final GameState state;

  const HudContainer(this.state);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: [
          if (state.selectedBuilding != null)
            BuildingMenuHud(
              state: state,
              building: state.selectedBuilding!,
            )
          else if (state.selectedPatch != null)
            PatchMenuHud(
              state: state,
              patch: state.selectedPatch!,
            )
          else if (state.selectedZone != null)
            ZoneMenuHud(
              state: state,
              zone: state.selectedZone!,
            ),
        ],
      ),
    );
  }
}
