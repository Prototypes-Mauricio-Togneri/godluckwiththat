import 'package:flutter/material.dart';
import 'package:tensionplanet/game/game_state.dart';
import 'package:tensionplanet/hud/menu_button_hud.dart';
import 'package:tensionplanet/hud/resource_hud.dart';
import 'package:tensionplanet/hud/village_switcher.dart';
import 'package:tensionplanet/models/buildings/building.dart';
import 'package:tensionplanet/utils/palette.dart';

class OverlayMenus extends StatelessWidget {
  final GameState state;

  const OverlayMenus(this.state);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: [
          VillageSwitcher(state),
          ResourceHud(state),
          MenuButtonHud(state),
          if (state.selectedBuilding != null)
            Positioned(
              top: (constraints.maxHeight * state.selectedBuilding!.offset.dy) -
                  (constraints.maxHeight / 10),
              left: (constraints.maxWidth * state.selectedBuilding!.offset.dx) -
                  (constraints.maxHeight / 10),
              child: BuildingQuickMenu(
                building: state.selectedBuilding!,
                size: constraints.maxHeight / 5,
              ),
            ),
        ],
      ),
    );
  }
}

class BuildingQuickMenu extends StatelessWidget {
  final Building building;
  final double size;

  const BuildingQuickMenu({
    required this.building,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.error.withAlpha(50),
      width: size,
      height: size,
    );
  }
}
