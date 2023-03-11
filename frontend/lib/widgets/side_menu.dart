import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionplanet/game/game_component.dart';
import 'package:tensionplanet/game/game_state.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/widgets/menus/building_menu.dart';
import 'package:tensionplanet/widgets/menus/construction_menu.dart';
import 'package:tensionplanet/widgets/menus/headquarters_menu.dart';

class SideMenu extends StatelessWidget {
  final GameComponent game;
  final GameState state;

  const SideMenu(this.game, this.state);

  @override
  Widget build(BuildContext context) {
    if (game.hasNodeSelected) {
      return Container(
        width: 300,
        height: double.infinity,
        color: Palette.grey,
        padding: const EdgeInsets.all(10),
        child: _showSelectedNode(),
      );
    } else {
      return const Empty();
    }
  }

  Widget _showSelectedNode() {
    if (game.selectedNode().isHeadquarters) {
      return HeadquartersMenu(
        game,
        game.selectedNode(),
      );
    } else if (game.selectedNode().isConstruction) {
      return ConstructionMenu(
        game,
        game.selectedNode(),
      );
    } else if (game.selectedNode().isBuilding) {
      return BuildingMenu(
        game,
        game.selectedNode(),
      );
    } else {
      throw Exception('No valid node is selected');
    }
  }
}
