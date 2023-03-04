import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/components/base/building.dart';
import 'package:tensionnode/components/game/construction.dart';
import 'package:tensionnode/components/game/headquarters.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/game/game_state.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/widgets/menus/building_menu.dart';
import 'package:tensionnode/widgets/menus/construction_menu.dart';
import 'package:tensionnode/widgets/menus/headquarters_menu.dart';

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
    if (game.selectedNode() is Headquarters) {
      return HeadquartersMenu(
        game,
        game.selectedNode(),
      );
    } else if (game.selectedNode() is Construction) {
      return ConstructionMenu(
        game,
        game.selectedNode(),
      );
    } else if (game.selectedNode() is Building) {
      return BuildingMenu(
        game,
        game.selectedNode(),
      );
    } else {
      throw Exception('No valid node is selected');
    }
  }
}
